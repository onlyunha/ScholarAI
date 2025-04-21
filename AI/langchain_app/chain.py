from langchain_community.chat_models import ChatOpenAI
from langchain.chains import LLMChain
from langchain_app.prompt_template import rag_prompt

def get_qa_chain():
    llm = ChatOpenAI(model_name="gpt-4", temperature=0)
    llm_chain = LLMChain(llm=llm, prompt=rag_prompt)
    return llm_chain
