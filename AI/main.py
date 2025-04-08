# main.py

from api.scholarship_api import fetch_scholarship_data
from recommend.content_recommender import recommend_similar_scholarships
from recommend.rule_filter import filter_scholarships_by_rules 
import json

# 1. 장학금 데이터 로드 (공공 API로부터)
scholarships = fetch_scholarship_data()

# 2. 사용자 정보 예시
user_info = {
    "age": 22,
    "income_quartile": 2,
    "university": "서울대학교",
    "major": "컴퓨터공학과",
    "grade": 3.9
}

# 3. 룰 기반 필터링
filtered = filter_scholarships_by_rules(scholarships, user_info)

# 4. 사용자가 찜한 장학금 예시 ID
liked_ids = ["1", "31"]  # 실제 ID로 교체 필요

# 5. 콘텐츠 기반 유사 추천
recommendations = recommend_similar_scholarships(filtered, liked_ids)

# 6. 결과 출력
print("추천된 장학금 목록:")
for rec in recommendations:
    print(f"- {rec.get('상품명')} (ID: {rec.get('번호')})")
