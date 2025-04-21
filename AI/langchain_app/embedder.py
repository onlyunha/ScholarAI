from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import OpenAIEmbeddings
from dotenv import load_dotenv

load_dotenv()

def store_embeddings(documents, persist_directory="chroma_db"):
    embedding = OpenAIEmbeddings(model="text-embedding-ada-002")

    vectordb = Chroma.from_documents(
        documents=documents,
        embedding=embedding,
        persist_directory=persist_directory
    )

    vectordb.persist()
    return vectordb
