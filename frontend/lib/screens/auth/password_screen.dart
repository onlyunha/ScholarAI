/// =============================================================
/// File : password_screen.dart
/// Desc : 회원가입 - 비밀번호 설정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-04
/// Updt : 2025-06-04
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

// 회원가입 - 비밀번호 설정 화면
class PasswordScreen extends StatefulWidget {
  final String email; // 이전 화면(signup_screen.dart)에서 전달된 이메일
  final String authCode; // 인증 코드

  const PasswordScreen({
    super.key,
    required this.email,
    required this.authCode,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen>
    with SingleTickerProviderStateMixin {
  final pwController = TextEditingController(); // 비밀번호 입력
  final confirmController = TextEditingController(); // 비밀번호 확인

  bool showPassword = false; // 비밀번호 보기 여부
  bool showConfirm = false; // 비밀번호 확인 보기 여부
  String errorMessage = ''; // 에러 메시지 변수

  // shake 애니메이션
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // 비밀번호 조건 검사: 10자 이상, 영문+숫자 조합
  bool isPasswordValid(String pw) {
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(pw);
    final hasNumbers = RegExp(r'\d').hasMatch(pw);
    return pw.length >= 10 && (hasLetters && hasNumbers);
  }

  // 비밀번호 확인 값 일치 여부 판단
  bool isConfirmMatched() {
    return pwController.text.trim() == confirmController.text.trim() &&
        pwController.text.isNotEmpty;
  }

  // 비밀번호 제출 시 회원가입 API 호출
  Future<void> handleSubmit() async {
    final pw = pwController.text.trim();
    final confirm = confirmController.text.trim();

    // 비밀번호 조건 미달 시 에러 + shake 애니메이션
    if (!isPasswordValid(pw) || !isConfirmMatched()) {
      _shakeController.forward(from: 0);
      setState(() {
        errorMessage = AppStrings.passwordErrorCondition;
      });
      return;
    }

    try {
      // 서버로 POST 요청 (회원가입)
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": "unknown", // 이름은 다음 화면에서 PATCH로 따로 전송
          "email": widget.email,
          "authCode": widget.authCode,
          "password": pw,
          "passwordCheck": confirm,
        }),
      );

      // 회원가입 성공: 이름 설정 화면으로 이동
      if (response.statusCode == 201) {

        final authProvider = context.read<AuthProvider>();
        final userProfileProvider = context.read<UserProfileProvider>();

        // ✅ 모든 정보 초기화
        authProvider.clearAuthData();
        userProfileProvider.clearProfile(); // provider 상태 초기화
       
        final resBody = jsonDecode(response.body);
        final memberId = resBody['data'].toString();
        await authProvider.saveAuthData(
          '',
          memberId,
          widget.email,
          'unknown',
          '',
        );
         context.go(AppRoutes.welcomeName, extra: {'email': widget.email});

        // 회원가입 실패: 에러 메시지
      } else {
        setState(() {
          errorMessage = AppStrings.signupFailed;
        });
      }
      // 네트워크 예외 처리
    } catch (e) {
      setState(() {
        errorMessage = AppStrings.networkError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pw = pwController.text;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 어플 로고
                Image.asset(
                  AppImages.mainLogo,
                  height: kLogoHeight,
                  color: kPrimaryColor,
                ),
                const SizedBox(height: 20),

                // 타이틀
                const Text(
                  AppStrings.passwordSettingTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 32),

                // 비밀번호 입력 필드
                TextField(
                  controller: pwController,
                  obscureText: !showPassword,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => showPassword = !showPassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 비밀번호 확인 입력 필드
                TextField(
                  controller: confirmController,
                  obscureText: !showConfirm,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: AppStrings.passwordConfirmLabel,
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirm ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => showConfirm = !showConfirm);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 조건 충족 여부 (애니메이션 적용)
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    final offset =
                        6 *
                        (1 - _shakeController.value) *
                        (_shakeController.value % 0.2 == 0 ? -1 : 1);
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: Column(
                        children: [
                          // 비밀번호 입력창 조건1
                          Row(
                            children: [
                              Icon(
                                isPasswordValid(pw)
                                    ? Icons.check_circle
                                    : Icons.error_outline,
                                color:
                                    isPasswordValid(pw)
                                        ? Colors.green
                                        : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                AppStrings.passwordCondition,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // 비밀번호 입력창 조건1
                          Row(
                            children: [
                              Icon(
                                isConfirmMatched()
                                    ? Icons.check_circle
                                    : Icons.error_outline,
                                color:
                                    isConfirmMatched()
                                        ? Colors.green
                                        : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                AppStrings.passwordConfirmMatch,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 에러 메시지
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: kErrorColor),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 24),

                // 다음 버튼
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: const Text(AppStrings.nextButton),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
