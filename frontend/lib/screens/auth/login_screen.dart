/// =============================================================
/// File : login_screen.dart
/// Desc : 이메일과 비밀번호를 이용한 로그인 화면 UI 및 기능 구현
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-02
/// Updt : 2025-06-01
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_images.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';
import '../../constants/config.dart';

// 로그인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // 이메일, 비밀번호 입력을 위한 컨트롤러
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 에러 메시지 변수
  String errorMessage = '';

  // shake 애니메이션 변수
  late AnimationController _shakeController;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // shake 애니메이션 초기화
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<double>(
      begin: 0,
      end: 12,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    // 리소스 해제
    _shakeController.dispose();
    super.dispose();
  }

  // 로그인 요청 함수
  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // API 요청
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // 성공: 메인 화면으로 이동
    if (response.statusCode == 200) {
      final rawToken =
          response.headers['authorization'] ??
          response.headers['Authorization'];
      final token =
          rawToken != null && !rawToken.startsWith('Bearer ')
              ? 'Bearer $rawToken'
              : rawToken;

      final resBody = jsonDecode(response.body);
      debugPrint('🟢 로그인 응답 전체: $resBody');
      final data = resBody['data'];
      final memberId = data['memberId'].toString();
      final profileId = data['profileId']; // null일 수 있으니 ?. 처리
      final name = data['name'] ?? '';

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.saveAuthData(token!, memberId, email, name);
      debugPrint('✅ authProvider 저장 완료');

      final userProfileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      if (profileId != null) {
        userProfileProvider.setProfileId(profileId);
        debugPrint('✅ 로그인 시 받아온 profileId: $profileId');

        // 🔽 여기 추가
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('profile_id', profileId);
      } else {
        debugPrint('⚠️ 로그인 응답에 profileId 없음');
      }

      await userProfileProvider.fetchProfileIdAndLoad(memberId, token);

      print('🔐 저장된 토큰: $token');
      print('👤 저장된 memberId: $memberId');

      context.go(AppRoutes.main);

      // 실패: 에러 메시지 + shake 애니메이션
    } else {
      final resBody = jsonDecode(response.body);
      if (resBody['message'].toString().contains('이메일')) {
        setState(() => errorMessage = AppStrings.emailError);
      } else {
        setState(() => errorMessage = AppStrings.passwordError);
      }
      _shakeController.forward(from: 0);
    }
    print('🔴 response.headers: ${response.headers}');
  }

  // 회원 가입 화면 이동 함수
  void goToSignup() {
    context.go(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 어플 로고
                Image.asset(
                  AppImages.mainLogo,
                  height: kLogoHeight,
                  color: kPrimaryColor,
                ),
                const SizedBox(height: 16),

                // 로그인 타이틀
                const Text(
                  AppStrings.loginTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // 이메일 입력 필드
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 비밀번호 입력 필드
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 오류 메시지 + shake 애니메이션
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_offsetAnimation.value, 0),
                      child: child,
                    );
                  },
                  child:
                      errorMessage.isNotEmpty
                          ? Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kErrorColor,
                              fontSize: 13,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),

                const SizedBox(height: 20),

                // 로그인 버튼
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text(AppStrings.loginButton),
                ),

                const SizedBox(height: 20),

                // 회원가입 링크 버튼
                TextButton(
                  onPressed: goToSignup,
                  child: const Text(
                    AppStrings.noAccount,
                    style: TextStyle(
                      color: Colors.grey, // 회색 텍스트
                      decoration: TextDecoration.underline, // 밑줄
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
