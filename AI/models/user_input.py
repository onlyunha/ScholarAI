from pydantic import BaseModel
from typing import List, Union

'''class UserInput(BaseModel):
    university_type: str
    grade_semester: List[str]
    major_field: List[str]
    academic_requirement: str
    academic_status: str
    income_requirement: str
    specific_eligibility: Union[List[str], str]
    regional_requirement: str
    is_disabled: str
    is_basic_living_recipient: str

from pydantic import BaseModel
from decimal import Decimal'''

class UserInput(BaseModel):
    birthYear: int                      # 출생년도
    gender: str                         # 성별
    residence: str                     # 거주지
    universityType: str               # 대학구분
    university: str                    # 대학명
    academicStatus: str               # 학적 상태
    semester: int                     # 학기
    majorField: str                  # 학과 구분
    major: str                        # 전공명
    gpa: float                     # 성적
    incomeLevel: int                 # 소득분위
    disabled: bool                 # 장애여부
    multiChild: bool              # 다자녀가구여부
    basicLivingRecipient: bool  # 기초생활수급자여부
    secondLowestIncome: bool    # 차상위계층여부
