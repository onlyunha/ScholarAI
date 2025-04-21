from dotenv import load_dotenv
import os

load_dotenv()

### KOSAF ###
KOSAF_API_BASE_URL = os.getenv("KOSAF_BASE_URL", "").strip()
KOSAF_API_PATH = os.getenv("KOSAF_ENDPOINT", "").strip()
KOSAF_API_KEY = os.getenv("KOSAF_API_KEY", "").strip()

### OpenAI API ###
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")