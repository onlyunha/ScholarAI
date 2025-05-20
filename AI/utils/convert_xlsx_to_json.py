import pandas as pd
import json

def convert_faq_xlsx_to_json(xlsx_path="data/faq.xlsx", json_path="data/faq.json"):
    # 엑셀 파일 읽기
    df = pd.read_excel(xlsx_path)

    # 열 이름 확인 및 정리 (필요시 수정)
    required_columns = {"ID", "질문", "답변", "분류"}
    if not required_columns.issubset(set(df.columns)):
        raise ValueError(f"엑셀 파일에 필요한 열이 없습니다: {required_columns}")

    # JSON 형식 리스트로 변환
    faq_list = df.to_dict(orient="records")

    # JSON 저장
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(faq_list, f, ensure_ascii=False, indent=2)

    print(f"✅ 변환 완료: {json_path} 저장됨")

if __name__ == "__main__":
    convert_faq_xlsx_to_json()
