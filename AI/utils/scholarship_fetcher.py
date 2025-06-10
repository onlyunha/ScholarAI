import requests
import json
import os
from config.settings import KOSAF_API_BASE_URL, KOSAF_API_KEY, KOSAF_API_PATH
import time

url = KOSAF_API_BASE_URL + KOSAF_API_PATH

headers = {
    "Authorization": f"Infuser {KOSAF_API_KEY}"
}

all_data = []
page = 1
per_page = 100  # 필요시 API 문서 최대 허용값으로 조정

while True:
    params = {
        "page": page,
        "perPage": per_page
    }
    response = requests.get(url, headers=headers, params=params)
    
    if response.status_code != 200:
        print(f"API 호출 실패: {response.status_code} {response.text}")
        break
    
    result = response.json()
    items = result.get("data", [])
    
    if not items:
        break
    
    all_data.extend(items)
    print(f"페이지 {page} 데이터 수: {len(items)} / 누적 데이터 수: {len(all_data)}")
    
    total_count = result.get("totalCount", 0)
    if len(all_data) >= total_count:
        break
    
    page += 1
    time.sleep(0.2)  # API 호출 제한 고려

os.makedirs("data", exist_ok=True)
with open("data/scholarship_new.json", "w", encoding="utf-8") as f:
    json.dump(all_data, f, ensure_ascii=False, indent=2)

print(f"전체 {len(all_data)}건 데이터를 data/scholarship_new.json에 저장했습니다.")
