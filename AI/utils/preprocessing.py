import json
import re
from datetime import datetime
from typing import List, Dict
import os


def normalize_date(date_str: str) -> str:
    """
    날짜 문자열을 ISO 형식(YYYY-MM-DD)으로 변환
    """
    try:
        return datetime.strptime(date_str, "%Y-%m-%d").date().isoformat()
    except:
        return ""
    
def parse_list(field: str) -> List[str]:
    if field:
        return [s.strip() for s in re.split(r'[,\n]', field) if s.strip()]
    return []

def parse_bullet_or_text(field: str):
    """
    ○가 여러 개면 list[str], 하나면 str, 없으면 그대로 반환
    """
    if not field or not isinstance(field, str):
        return field

    # ○가 없으면 그대로 반환
    if "○" not in field:
        return field.strip()

    parts = [s.strip(" ○\n") for s in field.split("○") if s.strip()]
    if len(parts) == 1:
        return parts[0]  # 단일 항목이면 str로
    return parts  # 다수 항목이면 list[str]

def parse_required_documents(field) -> List[str]:
    """
    '○' 기호 기준으로 분리.
    '※' 포함 문장은 분리 저장.
    입력이 str이든 list든 유연하게 처리.
    """
    # str이면 리스트로 변환
    if isinstance(field, str):
        field = [field]
    elif not isinstance(field, list):
        return []

    full_text = " ".join(field)
    result = []

    for segment in full_text.split("○"):
        segment = segment.strip()
        if not segment:
            continue

        if "※" in segment:
            parts = segment.split("※")
            if parts[0].strip():
                result.append(parts[0].strip())
            for after in parts[1:]:
                if after.strip():
                    result.append(after.strip())
        else:
            result.append(segment)

    return result


def is_valid_application_end_date(date_str: str) -> bool:
    """
    마감일이 오늘 날짜 이후인지 판별
    """
    end_date = datetime.fromisoformat(date_str).date()
    today = datetime.today().date()
    return end_date >= today


def normalize_scholarship(raw: Dict) -> Dict:
    """
    한국장학재단 원시 JSON 항목을 표준화된 딕셔너리로 변환
    """

    return {
        "scholarship_id": raw.get("번호", ""),
        "product_name": raw.get("상품명", ""),
        "organization_name": raw.get("운영기관명", ""),
        "organization_type": raw.get("운영기관구분", ""),
        "product_type": raw.get("상품구분", ""),
        "university_type": raw.get("대학구분", ""),
        "grade_semester": parse_list(raw.get("학년구분", "")),
        "major_field": parse_list(raw.get("학과구분", "")),
        "academic_requirement": parse_bullet_or_text(raw.get("성적기준", "")),
        "income_requirement": parse_bullet_or_text(raw.get("소득기준", "")),
        "funding_amount": parse_bullet_or_text(raw.get("지원금액", "")),
        "specific_eligibility": parse_bullet_or_text(raw.get("특정자격", "")),
        "regional_requirement": parse_bullet_or_text(raw.get("지역거주여부", "")),
        "selection_method": parse_bullet_or_text(raw.get("선발방법", "")),
        "selection_count": parse_bullet_or_text(raw.get("선발인원", "")),
        "eligibility_restriction": parse_bullet_or_text(raw.get("자격제한", "")),
        "recommendation_required": parse_bullet_or_text(raw.get("추천필요여부", "")),
        "required_documents": parse_required_documents(raw.get("제출서류", [])),
        "website_url": raw.get("홈페이지주소", ""),
        "application_start_date": normalize_date(raw.get("모집시작일", "")),
        "application_end_date": normalize_date(raw.get("모집종료일", ""))
    }
    


def preprocess_scholarship_json(input_path: str, output_path: str):
    # 기존 출력 파일이 있다면 삭제
    if os.path.exists(output_path):
        os.remove(output_path)

    with open(input_path, 'r', encoding='utf-8') as f:
        raw_data = json.load(f)

    processed = []
    for item in raw_data:
        norm = normalize_scholarship(item)
        # 마감일 유효성 필터링
        if not is_valid_application_end_date(norm["application_end_date"]):
            continue

        processed.append(norm)

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(processed, f, ensure_ascii=False, indent=2)
