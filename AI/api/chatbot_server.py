from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from faq_chatbot.chatbot import FAQChatBot

app = FastAPI()
chatbot = FAQChatBot()

class FAQRequest(BaseModel):
    category: str
    question: str

@app.post("/faq-answer")
def get_faq_answer(req: FAQRequest):
    result = chatbot.get_answer(req.question, req.category)
    if not result:
        raise HTTPException(status_code=404, detail="해당 분류에서 유사 질문을 찾을 수 없습니다.")
    return result
