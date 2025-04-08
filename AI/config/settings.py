from dotenv import load_dotenv
import os

load_dotenv()

API_BASE_URL = os.getenv("BASE_URL", "").strip()
API_PATH = os.getenv("SCHOLARSHIP_ENDPOINT", "").strip()
API_KEY = os.getenv("SERVICE_KEY", "").strip()