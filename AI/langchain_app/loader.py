import json
from langchain_community.document_loaders import JSONLoader
from langchain.schema import Document

def load_processed_scholarship_documents(json_path: str) -> list[Document]:
    loader = JSONLoader(
        file_path=json_path,
        jq_schema=".[]",
        text_content=False
    )

    raw_docs = loader.load()
    documents = []

    for doc in raw_docs:
        data = json.loads(doc.page_content) 

        documents.append(Document(
            page_content=json.dumps(data, ensure_ascii=False),  # JSON 그대로 넣기
            metadata={
                "scholarship_id": data.get("scholarship_id", ""),
                "name": data.get("product_name", ""),
                "website_url": data.get("website_url", ""),
                "application_end_date": data.get("application_end_date", "")
            }
        ))

    return documents