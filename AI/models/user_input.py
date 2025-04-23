from pydantic import BaseModel
from typing import List, Union

class UserInput(BaseModel):
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
