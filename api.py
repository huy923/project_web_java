import os
import math
from typing import Any

import fastapi as fa
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import ollama


app = fa.FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


EMBEDDING_MODEL = os.getenv("OLLAMA_EMBED_MODEL", "hf.co/CompendiumLabs/bge-base-en-v1.5-gguf")
CHAT_MODEL = os.getenv("OLLAMA_CHAT_MODEL", "llama3")

DATA_FILE = os.getenv("RAG_DATA_FILE", "data.txt")
TOP_K = int(os.getenv("RAG_TOP_K", "4"))
MAX_HISTORY = int(os.getenv("CHAT_MAX_HISTORY", "12"))


class ChatRequest(BaseModel):
    user_input: str
    history: list[dict[str, str]] = []


_rag_cache: dict[str, Any] = {
    "mtime": None,
    "chunks": [],
    "embeddings": [],
}


def _cosine_similarity(a: list[float], b: list[float]) -> float:
    dot = 0.0
    na = 0.0
    nb = 0.0
    for x, y in zip(a, b):
        dot += x * y
        na += x * x
        nb += y * y
    denom = math.sqrt(na) * math.sqrt(nb)
    if denom == 0.0:
        return 0.0
    return dot / denom


def _load_text_chunks(path: str) -> list[str]:
    if not os.path.exists(path):
        return []

    with open(path, "r", encoding="utf-8") as f:
        raw = f.read().strip()

    if not raw:
        return []

    parts = [p.strip() for p in raw.split("\n\n") if p.strip()]
    chunks: list[str] = []
    for p in parts:
        if len(p) <= 900:
            chunks.append(p)
            continue

        # soft chunk large paragraphs
        step = 800
        for i in range(0, len(p), step):
            sub = p[i : i + 900].strip()
            if sub:
                chunks.append(sub)
    return chunks


def _ensure_rag_index() -> None:
    try:
        mtime = os.path.getmtime(DATA_FILE)
    except OSError:
        mtime = None

    if _rag_cache["mtime"] == mtime:
        return

    chunks = _load_text_chunks(DATA_FILE)
    embeddings: list[list[float]] = []
    if chunks:
        for chunk in chunks:
            emb = ollama.embed(model=EMBEDDING_MODEL, input=chunk)["embeddings"][0]
            embeddings.append(emb)

    _rag_cache["mtime"] = mtime
    _rag_cache["chunks"] = chunks
    _rag_cache["embeddings"] = embeddings


def _retrieve_context(query: str) -> list[str]:
    _ensure_rag_index()

    chunks: list[str] = _rag_cache["chunks"]
    embeddings: list[list[float]] = _rag_cache["embeddings"]
    if not chunks:
        return []

    q_emb = ollama.embed(model=EMBEDDING_MODEL, input=query)["embeddings"][0]
    scored = [(_cosine_similarity(q_emb, emb), idx) for idx, emb in enumerate(embeddings)]
    scored.sort(reverse=True, key=lambda x: x[0])

    out: list[str] = []
    for score, idx in scored[: max(TOP_K, 1)]:
        if score <= 0:
            continue
        out.append(chunks[idx])
    return out


@app.get("/")
async def root():
    return {"message": "OK"}


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "chat_model": CHAT_MODEL,
        "embedding_model": EMBEDDING_MODEL,
        "data_file": DATA_FILE,
    }


@app.post("/chat")
async def chat(request: ChatRequest):
    user_text = (request.user_input or "").strip()
    if not user_text:
        return {"response": ""}

    history = request.history or []
    trimmed_history = history[-MAX_HISTORY:]
    messages: list[dict[str, str]] = []

    context_chunks = _retrieve_context(user_text)
    context_block = "\n\n".join([f"- {c}" for c in context_chunks])

    system_prompt = (
        "You are a helpful assistant for a hotel management system. "
        "Answer clearly and briefly. If you use provided context, cite it implicitly by keeping it consistent. "
        "If you don't know, say you don't know."
    )
    if context_block:
        system_prompt += "\n\nContext (from data.txt):\n" + context_block

    messages.append({"role": "system", "content": system_prompt})
    for m in trimmed_history:
        role = (m.get("role") or "").strip()
        content = (m.get("content") or "").strip()
        if role in {"user", "assistant"} and content:
            messages.append({"role": role, "content": content})
    messages.append({"role": "user", "content": user_text})

    result = ollama.chat(model=CHAT_MODEL, messages=messages)
    reply = (result.get("message") or {}).get("content") if isinstance(result, dict) else None
    if not reply:
        reply = str(result)
    return {"response": reply}


@app.post("/chatbot")
async def chatbot_compat(request: ChatRequest):
    return await chat(request)