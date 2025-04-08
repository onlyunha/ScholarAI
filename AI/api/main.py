'''
from fastapi import FastAPI, Request
from pydantic import BaseModel
from typing import List, Dict
from recommend.rule_filter import filter_scholarships_by_rules
from recommend.content_recommender import recommend_similar_scholarships

app = FastAPI()

# 입력 JSON 형식 정의
class RecommendationRequest(BaseModel):
    user_info: Dict[str, str]
    liked_ids: List[str]
    all_scholarships: List[Dict]

@app.post("/recommend")
def get_recommendations(request: RecommendationRequest):
    # 1. 룰 기반 필터링
    filtered = filter_scholarships_by_rules(request.all_scholarships, request.user_info)
    
    # 2. 콘텐츠 기반 추천
    recommended = recommend_similar_scholarships(filtered, request.liked_ids, top_k=5)

    return {"recommendations": recommended}'''