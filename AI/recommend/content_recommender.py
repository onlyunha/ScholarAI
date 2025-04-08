from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
from typing import List, Dict

def recommend_similar_scholarships(
    filtered_scholarships: List[Dict],
    liked_scholarship_ids: List[str],
    top_k: int = 5
) -> List[Dict]:
    """
    필터링된 장학금 중 사용자가 찜한 장학금과 유사한 장학금 추천

    :param filtered_scholarships: 룰 기반으로 필터링된 장학금 리스트
    :param liked_scholarship_ids: 사용자가 찜한 장학금 id 리스트
    :param top_k: 추천 개수
    :return: 유사 장학금 추천 리스트
    """
    if not filtered_scholarships:
        return []

    df = pd.DataFrame(filtered_scholarships)

    # 텍스트 필드 조합 (비어있으면 빈 문자열로 처리)
    df["text"] = (
        df["상품명"].fillna("") + " " +
        df["선발방법"].fillna("") + " " +
        df["성적기준"].fillna("") + " " +
        df["소득기준"].fillna("") + " " +
        df["자격제한"].fillna("") + " " +
        df["제출서류"].fillna("") + " " +
        df["특정자격"].fillna("")
    )

    # TF-IDF 벡터화
    tfidf = TfidfVectorizer()
    tfidf_matrix = tfidf.fit_transform(df["text"])

    # 사용자가 찜한 장학금 index 추출
    liked_indices = df[df["번호"].isin(liked_scholarship_ids)].index.tolist()
    if not liked_indices:
        return []

    # 찜한 장학금과의 평균 유사도 계산
    similarity_scores = cosine_similarity(tfidf_matrix, tfidf_matrix[liked_indices])
    avg_scores = similarity_scores.mean(axis=1)

    # 찜한 장학금은 제외
    df["score"] = avg_scores
    df = df[~df["번호"].isin(liked_scholarship_ids)]

    # 상위 추천 추출
    top_recommended = df.sort_values(by="score", ascending=False).head(top_k)
    return top_recommended.to_dict(orient="records")
