from typing import List, Dict

def filter_scholarships_by_rules(scholarships: List[Dict], user_info: Dict) -> List[Dict]:
    """
    사용자 정보와 장학금 조건이 일치하는 장학금만 반환합니다.
    NULL 값이 있는 경우는 일단 '통과'하도록 처리합니다.
    """
    def check_rule(scholarship, user_info):
        # 학년 기준 필터링
        if scholarship.get("지원학년") and user_info.get("학년"):
            if user_info["학년"] not in scholarship["지원학년"]:
                return False
        
        # 전공 기준 필터링
        if scholarship.get("전공제한") and user_info.get("전공"):
            if user_info["전공"] not in scholarship["전공제한"]:
                return False

        # 지역 기준 필터링
        if scholarship.get("거주지") and user_info.get("지역"):
            if user_info["지역"] not in scholarship["거주지"]:
                return False

        return True

    return [sch for sch in scholarships if check_rule(sch, user_info)]
