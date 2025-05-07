/// =============================================================
/// File : welcome_screen.dart
/// Desc : 앱의 시작화면 - 로그인/회원가입 진입 제공
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-02
/// Updt : 2025-04-28
/// =============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_images.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/constants/config.dart';
import 'dart:convert';
import 'home/main_screen.dart';

// 시작 화면 (Welcome)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // 이메일 로그인 화면으로 이동
  void goToLogin(BuildContext context) {
    context.go(AppRoutes.login); // 수정
  }

  // 구글 로그인 처리
  Future<void> handleGoogleSignIn(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;

      if (idToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/api/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'idToken': idToken}),
        );

        if (response.statusCode == 200) {
          context.go(AppRoutes.main);
        } else {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('로그인 실패'),
                  content: Text('Google 로그인 실패: ${response.body}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
          );
        }
      }
    } catch (e) {
      print('구글 로그인 실패: $e');
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('에러'),
              content: Text('Google 로그인 중 문제가 발생했습니다.\n\n$e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    }
  }

  // 카카오 로그인 처리
  Future<void> handleKakaoLogin(BuildContext context) async {
    try {
      // 카카오톡 설치 여부에 따라 로그인 방식 분기
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // idToken이 필요할 경우 추가로 가져올 수 있음
      final user = await UserApi.instance.me();

      // 토큰 서버로 전달
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/kakao'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': token.accessToken}),
      );

 if (response.statusCode == 200) {
      context.go(AppRoutes.main);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('로그인 실패'),
          content: Text('Kakao 로그인 실패: ${response.body}'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
        ),
      );
    }
  } catch (e) {
    print('카카오 로그인 실패: $e');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('에러'),
        content: Text('Kakao 로그인 중 문제가 발생했습니다.\n\n$e'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(), // 라이트 모드 고정
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 어플 로고 및 슬로건
                Column(
                  children: [
                    Image.asset(
                      AppImages.mainLogo,
                      height: 120,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(height: 0),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Scholar',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: kPrimaryColor,
                              letterSpacing: -1.5,
                            ),
                          ),
                          TextSpan(
                            text: 'AI',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      '내 손 안의 기회, 당신만을 위한 맞춤형 장학금',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // Google 로그인 버튼
                customSocialButton(
                  assetPath: AppImages.googleLogo,
                  text: 'Google로 계속하기',
                  backgroundColor: const Color(0xFFf2f2f2),
                  textColor: Colors.black,
                  onPressed: () => handleGoogleSignIn(context),
                ),

                const SizedBox(height: 12),

                // KaKao 로그인 버튼
                customSocialButton(
                  assetPath: AppImages.kakaoLogo,
                  text: 'Kakao로 계속하기',
                  backgroundColor: const Color(0xFFFEE500),
                  textColor: Colors.black,
                  onPressed: () => handleKakaoLogin(context),
                ),

                const SizedBox(height: 32),
                const Text(
                  '또는',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 14),

                // 이메일 회원가입 버튼
                ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.signup);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('계정 만들기', style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 30),

                // 이메일 로그인 화면으로 이동
                TextButton(
                  onPressed: () => goToLogin(context),
                  child: const Text(
                    '이메일로 계속하기',
                    style: TextStyle(fontSize: 12),
                  ),
                ),

                // ✅ 임시 버튼
                TextButton(
                  onPressed: () {
                    context.go(AppRoutes.main);
                  },
                  child: const Text(
                    '메인화면으로 이동 →',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 소셜 로그인 버튼 위젯
  Widget customSocialButton({
    required String assetPath,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(assetPath, height: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
