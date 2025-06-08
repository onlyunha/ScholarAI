from langchain.prompts import PromptTemplate

rag_prompt = PromptTemplate.from_template("""
다음은 장학금 정보들입니다. 모든 장학금 정보는 JSON 객체이며, input_documents 리스트에 포함되어 있습니다.
아래 JSON 리스트에서 사용자 조건에 부합하는 장학금 **3개 이하**로 골라서 각 장학금의 **scholarship_id 값만 리스트 형태로 출력하세요.**
**input_documents 외부의 장학금은 절대 추천하지 마세요.**                          

[장학금 정보]
```json
{input_documents}

[사용자 정보]
{formatted_user_input}


formatted_user_input과 가장 유사한 장학금을 input_documents 내부 JSON 중에서 최대 3개까지 골라서 추천해줘.

출력은 반드시 아래 조건을 엄격히 지켜야 해:
  반드시 **장학금 ID(scholarship_id)만 배열로 출력**하세요.
  배열 외 다른 어떤 정보도 절대 출력하지 마세요.
  추천 장학금 상세 정보(이름, 기관명, 금액 등)는 절대 출력하지 마세요.
  단, 출력은 아래와 같은 형식으로 scholarship_id 값만 리스트로 출력해줘.
  다른 정보는 절대 포함하지 말고, **JSON 원문도 절대 출력하지 마.**

출력 형식 예시:

 ["scholarship_id_1", "scholarship_id_2", "scholarship_id_3", ...]


""")
