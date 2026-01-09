import fastapi as fa
from pydantic import BaseModel
import ollama

app = fa.FastAPI()

EMBEDDING_MODEL = 'hf.co/CompendiumLabs/bge-base-en-v1.5-gguf'
LANGUAGE_MODEL = 'bge-m3'

class ChatRequest(BaseModel):
    user_input: str
    history: list[dict[str, str]]


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/chatbot")
async def chatbot(request: ChatRequest):
    text = request.user_input.lower()
    history = []
    for i in request.history:
        history.append({"role": i["role"], "content": i["content"]})
    enbedding = ollama.embeddings(
        model="hf.co/CompendiumLabs/bge-base-en-v1.5-gguf",
        text=text
    )
    
    response = ollama.chat(
        model="bge-m3",
        messages=[
            {"role": "user", "content": text},
            {"role": "history", "content": history},
            {"role": "system", "content": "You are a helpful assistant."}
        ]
    )
    
    return {"response": response}