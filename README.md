<div align="center">
  <img src="https://github.com/user-attachments/assets/669b34b0-9d33-4e13-b0f9-c84dda51e862" width="1000"
    /><br><br>

  <h1>🎓 ScholarAI</h1>

  <p><strong>ScholarAI</strong>는 장학금 정보 탐색의 복잡함을 덜고,<br>
  <strong>개인 맞춤형 추천</strong>을 통해 사용자가 <strong>가장 알맞은 장학금</strong>을<br>
  쉽고 빠르게 찾을 수 있도록 도와주는 <strong>모바일 애플리케이션</strong>입니다.<br><br><br><br></p>


## 🧑‍💻 Team Members
<table>
  <thead>
    <tr>
      <th>이름</th>
      <th>역할</th>
      <th>담당 업무</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>🧭 <strong>황윤하</strong></td>
      <td><strong>팀장 / Frontend</strong></td>
      <td>Flutter 기반 UI/UX 개발 및 앱 구조 설계</td>
    </tr>
    <tr>
      <td>🗄️ <strong>고희연</strong></td>
      <td><strong>Backend</strong></td>
      <td>Spring Boot 기반 API 설계 및 DB 관리</td>
    </tr>
    <tr>
      <td>🤖 <strong>곽나현</strong></td>
      <td><strong>AI</strong></td>
      <td>챗봇 구축 및 장학금 추천 알고리즘 개발</td>
    </tr>
  </tbody>
</table>
<br><br>
<br><br>

## 🛠️ Tech Stack

#### Frontend
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)

#### Backend
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Spring Security](https://img.shields.io/badge/Spring_Security-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white)](https://spring.io/projects/spring-security)
[![Spring Data JPA](https://img.shields.io/badge/Spring_Data_JPA-007396?style=for-the-badge)](https://spring.io/projects/spring-data-jpa)
[![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)](https://jwt.io)

#### AI & Chatbot
[![OpenAI](https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white)](https://openai.com)
[![LangChain](https://img.shields.io/badge/LangChain-000000?style=for-the-badge)](https://www.langchain.com)
[![ChromaDB](https://img.shields.io/badge/Chroma-FF6F61?style=for-the-badge)](https://www.trychroma.com)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)

#### Database & API Protocol
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io)
[![REST API](https://img.shields.io/badge/REST%20API-02569B?style=for-the-badge)]()

#### External Services & Authentication
[![Google](https://img.shields.io/badge/Google-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://developers.google.com/identity)
[![KakaoTalk](https://img.shields.io/badge/KakaoTalk-FFCD00?style=for-the-badge&logo=kakaotalk&logoColor=black)](https://developers.kakao.com)
[![Gmail](https://img.shields.io/badge/Gmail-EA4335?style=for-the-badge&logo=gmail&logoColor=white)](https://gmail.com)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
<br><br>
<sub>📌 [ScholarAI 시스템 구조도 보기](https://github.com/user-attachments/assets/e93c206a-3115-4260-841e-f9dd5cd255e9)</sub>

<br><br>
<br><br>
## 📁 Project Structure
</div>

```
ScholarAI/
├── frontend/                         Flutter 모바일 앱 (크로스 플랫폼)
│   ├── lib/
│   │   ├── screens/                  로그인, 홈, 프로필 등 각 페이지 UI
│   │   ├── widgets/                  재사용 가능한 UI 컴포넌트
│   │   ├── providers/                상태 관리 (Auth, Profile 등)
│   │   ├── services/                 알림, 게시판, API 연동
│   │   ├── constants/                색상, 문자열, 이미지 등 전역 상수
│   │   └── main.dart                 앱 진입점
│   ├── ios/, android/, macos/...     플랫폼별 빌드 설정
│   └── web/                          PWA용 리소스 (icons, manifest 등)
│
├── backend/                          Spring Boot 기반 REST API 서버
│   ├── src/main/java/...             API 컨트롤러, 서비스, 모델 등
│   ├── src/main/resources/           설정 파일, application.yml 등
│   └── build.gradle / pom.xml        빌드 설정
│
├── ai/                               FastAPI 기반 추천 시스템 및 챗봇
│   ├── api.py                        FastAPI 엔트리포인트
│   ├── model.py                      장학금 추천 모델 로직
│   ├── chatbot/                      챗봇 질문 분류, 응답 처리 모듈
│   └── requirements.txt              의존성 리스트
│
├── docs/                             시스템 구조도, 설계서, 발표자료
├── .gitignore                        Git 제외 파일 설정
└── README.md                         프로젝트 개요 및 실행 가이드

```
<div align="center">

<br><br>
<br><br>
## 🚀 How to Run

#### 1. Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```
<sub>💡 Flutter SDK 설치 필요: [Flutter 설치 가이드](https://docs.flutter.dev/get-started/install)<br></sub>
<sub>💡 Android Emulator 또는 iOS Simulator 필요<br></sub>
<br><br>

#### 2. Backend (Spring Boot)

```bash
cd backend
./gradlew bootRun
```

<sub>💡 기본 포트: `8080`<br></sub>
<sub>💡 설정파일 위치: `backend/src/main/resources/application.yml`<br></sub>
<sub>💡 JDK 17 이상 권장<br></sub>

<br><br>
#### 3. AI Server (FastAPI)

```bash
cd ai
pip install -r requirements.txt
uvicorn api:app --reload --port 8000
```

<sub>💡 Python 3.8 이상 권장<br></sub>
<sub>💡 기본 포트: `8000`<br></sub>
<sub>💡 API 문서는 `/docs` 에서 Swagger UI 제공<br></sub>
<br><br>
<br><br>

## 🔗 Related Links
**Github** https://github.com/onlyunha/ScholarAI <br>
**📝 Notion**:<br>
**🎥 시연 영상**: <br>

<br><br>
<br><br>
</div>
