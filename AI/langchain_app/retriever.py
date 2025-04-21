# rag_retriever.py
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma

def get_retriever(persist_directory="chroma_db"):
    embedding = OpenAIEmbeddings(model="text-embedding-ada-002")
    vectordb = Chroma(
        persist_directory=persist_directory,
        embedding_function=embedding
    )
    return vectordb.as_retriever(
        search_type="mmr",  
        search_kwargs={"k": 5} 
    )