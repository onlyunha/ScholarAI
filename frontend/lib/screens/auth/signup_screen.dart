/// =============================================================
/// File : signup_screen.dart
/// Desc : 이메일 인증 회원가입 화면
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-02
/// Updt : 2025-06-04
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/app_images.dart';

import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';
import '../../constants/config.dart';

// 이메일 인증 회원가입 화면
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController(); // 이메일 입력 컨트롤러
  final codeController = TextEditingController(); // 인증코드 입력 컨트롤러

  bool codeStep = false; // 인증 단계 여부
  String errorMessage = ''; // 에러 메시지
  String authCode = ''; // 인증코드 저장

  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  // 인증코드 요청
  Future<void> handleSendCode() async {
    final email = emailController.text.trim().toLowerCase();
    if (!emailRegex.hasMatch(email)) {
      setState(() => errorMessage = AppStrings.emailFormatError);
      return;
    }

    print('📧 최종 전송 이메일: $email');
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/sendEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        errorMessage = '';
        codeStep = true;
      });
    } else {
      setState(() => errorMessage = AppStrings.sendCodeFailed);
    }
  }

  // 인증코드 검증
  Future<void> handleVerifyCode() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verifyEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'authCode': code}),
    );

    // 인증 성공 시 다음 화면으로 이동
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text(AppStrings.signupSuccessTitle),
              content: const Text(AppStrings.signupSuccessContent),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(
                      AppRoutes.password,
                      extra: {'email': email, 'authCode': code},
                    );
                  },
                  child: const Text(AppStrings.confirm),
                ),
              ],
            ),
      );

      // 인증 실패 시 알림
    } else {
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text(AppStrings.signupFailedTitle),
              content: Text(AppStrings.signupFailedContent),
            ),
      );
    }
  }

  // 인증코드 재전송 팝업
  void showResendPopup() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text(AppStrings.sendCodeResendTitle),
            content: const Text(AppStrings.sendCodeResendContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(AppStrings.cancelButton),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleSendCode(); // 재전송
                },
                child: const Text(AppStrings.confirm),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: kDefaultPaddingVertical,
            ),
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

                // 타이틀
                const Text(
                  AppStrings.signupTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // 이메일 형식 오류 메시지
                if (errorMessage.isNotEmpty && !codeStep)
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kErrorColor, fontSize: 13),
                  ),

                // 이메일 입력 필드
                TextField(
                  controller: emailController,
                  enabled: !codeStep, // 인증 단계 이후에는 비활성화
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    hintText: AppStrings.emailHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // 인증코드 전송 버튼
                if (!codeStep) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: handleSendCode,
                    child: const Text(AppStrings.sendAuthCodeButton),
                  ),
                ],

                // 인증코드 입력 및 검증
                if (codeStep) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: AppStrings.authCode,
                      hintText: AppStrings.authCodeHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 코드 재전송 & 인증하기 버튼
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: showResendPopup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kPrimaryColor,
                            side: BorderSide(color: kPrimaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(AppStrings.sendCodeResendTitle),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: handleVerifyCode,
                          child: const Text(AppStrings.verifyCodeButton),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 이메일 재입력 링크
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          codeStep = false;
                          codeController.clear();
                          errorMessage = '';
                        });
                      },
                      child: const Text(
                        AppStrings.reenterEmailButton,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
