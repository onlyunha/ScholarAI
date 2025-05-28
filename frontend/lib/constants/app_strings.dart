/// =============================================================
/// File : app_strings.dart
/// Desc : string 상수
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-28
/// Updt : 2025-04-28
/// =============================================================
library;

class AppStrings {
  // --- 공통 단어 ---
  static const email = '이메일';
  static const authCode = '인증코드';
  static const confirm = '확인';
  static const resend = '재전송';
  static const password = '비밀번호';
  static const passwordConfirm = '비밀번호 확인';
  static const passwordConfirmLabel = '비밀번호 확인';
  static const nextButton = '다음';

  // --- 화면별 타이틀 ---
  static const loginTitle = '로그인';
  static const signupTitle = '이메일로 회원가입';
  static const passwordSettingTitle = '비밀번호 설정';
  static const signupSuccessTitle = '인증 성공';
  static const signupFailedTitle = '인증 실패';
  static const welcomeTitle = '가입을 환영해요!';

  // --- 입력 필드 힌트 ---
  static const emailHint = 'example@email.com';
  static const authCodeHint = '6자리 인증코드 입력';

  // --- 버튼 텍스트 ---
  static const loginButton = '로그인';
  static const sendAuthCodeButton = '인증코드 전송';
  static const verifyCodeButton = '인증하기';
  static const reenterEmailButton = '이메일 재입력';
  static const noAccount = '아직 계정이 없다면?';
  static const completeButton = '완료';

  // --- 다이얼로그 내용 ---
  static const signupSuccessContent = '인증되었습니다!';
  static const signupFailedContent = '인증코드를 다시 확인해주세요.';
  static const sendCodeResendTitle = '코드 재전송';
  static const sendCodeResendContent = '코드를 재전송하시겠습니까?';
  static const cancelButton = '취소';

  // --- 에러 메시지 ---
  static const emailFormatError = '올바른 이메일 형식을 입력해주세요.';
  static const sendCodeFailed = '인증코드 전송에 실패했습니다.';
  static const emailError = '이메일을 다시 확인해주세요.';
  static const passwordError = '비밀번호를 다시 확인해주세요.';
  static const passwordMismatchError = '비밀번호가 일치하지 않습니다.';
  static const passwordErrorCondition = '비밀번호 생성 조건을 확인해주세요.';
  static const signupFailed = '회원가입에 실패했습니다.';
  static const networkError = '네트워크 오류가 발생했습니다.';
  static const nameFormatError = '한글 또는 영어만 입력 (최대 20자)';
  static const nameFailed = '이름 설정에 실패했습니다.';

  // --- 비밀번호 조건 관련 텍스트 ---
  static const passwordCondition = '영어, 숫자 조합 최소 10자리 이상';
  static const passwordConfirmMatch = '비밀번호 확인 일치';

  // --- 안내 문구 ---
  static const welcomeSubtitle = '사용하실 이름을 입력해주세요.';

  // --- 입력 필드 라벨 ---
  static const name = '이름';

  // --- 장학금 화면 관련 ---
  static const scholarshipSearchTab = '장학금 검색';
  static const scholarshipRecommendTab = '장학금 추천';
  static const scholarshipSearchTitle = '장학금 검색하기';
  static const scholarshipRecommendTitle = '장학금 추천받기';
  static const searchFilterButton = '검색 필터';
  static const filterTypeTitle = '종류';
  static const filterPeriodTitle = '기간';
  static const filterResetButton = '초기화';
  static const filterApplyButton = '적용';
  static const keywordHint = '키워드를 입력하세요';
  static const detailInfoTitle = '상세 정보';
}
