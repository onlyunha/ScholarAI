import requests
import json
from config.settings import API_BASE_URL, API_PATH, API_KEY

def fetch_scholarship_data():
    url = f"{API_BASE_URL}{API_PATH}"
    params = {
        'serviceKey': API_KEY,
        'page': 1,
        'perPage': 1000,
        'returnType': 'JSON'
    }

    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()['data']
        with open('data/scholarships.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print(f"✅ {len(data)}개의 장학금 데이터를 저장했습니다.")
        return data
    else:
        print("❌ API 호출 실패:", response.status_code)
        return []
