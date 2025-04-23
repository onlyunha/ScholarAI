# langchain_app/utils/query_formatter.py
from models.user_input import UserInput

def format_user_input_as_query(user_input:UserInput) -> str:
    lines = []
    for k, v in user_input.dict().items():
        if isinstance(v, list):
            lines.append(f"{k}: {', '.join(v)}")
        else:
            lines.append(f"{k}: {v}")
    return "\n".join(lines)
