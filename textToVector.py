import ollama
import json
import os
# Load the dataset

dataset = []
with open('rules.txt', 'r', encoding='utf-8') as file:
    dataset.extend(file.readlines())

print(f'Loaded {len(dataset)} entries')

os.makedirs("vector_db", exist_ok=True)
# Implement the retrieval system

EMBEDDING_MODEL = 'hf.co/CompendiumLabs/bge-base-en-v1.5-gguf'

# Each element in the VECTOR_DB will be a tuple (chunk, embedding)
# The embedding is a list of floats, for example: [0.1, 0.04, -0.34, 0.21, ...]

VECTOR_DB = []
VECTOR_DB_PATH = 'vector.json'

def add_chunk_to_database(chunk):
    embedding = ollama.embed(model=EMBEDDING_MODEL, input=chunk)['embeddings'][0]
    VECTOR_DB.append((chunk, embedding))

for i, chunk in enumerate(dataset):
    add_chunk_to_database(chunk)
    print(f'Added chunk {i+1}/{len(dataset)} to the database')
with open(VECTOR_DB_PATH, 'w', encoding='utf-8') as f:
    json.dump(VECTOR_DB, f, ensure_ascii=False, indent=2)