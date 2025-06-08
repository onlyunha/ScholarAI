import json
import re
from konlpy.tag import Okt

okt = Okt()

SUBSTITUTION_DICT = {
    "어떻게 해요": "신청 방법",
    "어떻게 하나요": "신청 방법",
    "어떻게하나요": "신청 방법",
    "언제 해요": "신청 시기",
    "언제 하나요": "신청 시기",
    "할 수 있나요": "신청 가능 여부",
    "가능한가요": "신청 가능 여부",
    "알려 주세요": "방법 안내",
}

STOPWORDS = {"요", "죠", "가요", "인가요", "하나요", "좀", "좀요"}

def normalize_question(text):
    text = text.strip().lower()
    text = re.sub(r"[^\w\s가-힣]", "", text)

    for key, val in SUBSTITUTION_DICT.items():
        text = text.replace(key, val)

    tokens = okt.morphs(text)
    tokens = [t for t in tokens if t not in STOPWORDS]

    return " ".join(tokens)


def preprocess_faq_json(input_path="data/faq.json", output_path="data/faq_normalized.json"):
    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    for item in data:
        item["질문_전처리"] = normalize_question(item["질문"])

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"✅ 전처리 완료: {output_path}에 저장되었습니다.")


if __name__ == "__main__":
    preprocess_faq_json()