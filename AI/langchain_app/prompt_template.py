from langchain.prompts import PromptTemplate

rag_prompt = PromptTemplate.from_template("""
다음은 장학금 정보들입니다. 모든 장학금 정보는 JSON 객체이며, input_documents 리스트에 포함되어 있습니다.
아래 JSON 리스트에서 사용자 조건에 부합하는 장학금 **3개 이하**로 골라 주세요.  
**input_documents 외부의 장학금은 절대 추천하지 마세요.**                          

[장학금 정보]
```json
{input_documents}

[사용자 정보]
{formatted_user_input}


formatted_user_input과 가장 유사한 장학금을 input_documents 내부 JSON 중에서 최대 3개까지 골라서 추천해줘.

출력은 반드시 아래 조건을 지켜야 해:
 반드시 input_documents에 포함된 JSON을 **그대로 복사해서 출력**할 것
 절대 새로운 내용을 상상하거나 생성하지 마세요
 존재하지 않는 장학금 데이터를 만들지 말고, input_documents 내부에 있는 항목만 출력할 것

 새로운 정보를 생성하거나 추론하지 말 것
 **동일한 장학금(scholarship_id 기준)은 한 번만 추천할 것**
 같은 scholarship_id를 가진 장학금은 절대 두 번 이상 출력하지 마.
 최대 3개까지 추천하며, 1~2개만 적합하면 그것만 출력할 것
 **input_documents 안의 JSON 객체를 그대로 복사해서 출력할 것** (순서나 키도 바꾸지 마)
 **새로운 장학금 데이터를 생성하거나 수정하지 말 것**
 **input_documents 안의 JSON만 사용하고, 그 외에는 절대로 생성하지 말 것**
 **출력은 반드시 input_documents 안에 존재하는 JSON 중 일부를 그대로 복사해 구성할 것**

출력 형식 예시:
[
  {{
    "scholarship_id": "...",
    "product_name": "...",
    "organization_name": "...",
    "funding_amount": "...",
    "application_end_date": "...",
    "website_url": "..."
  }},
  ...
]
""")
