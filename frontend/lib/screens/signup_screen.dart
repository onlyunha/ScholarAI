/// =============================================================
/// File : signup_screen.dart
/// Desc : 이메일 인증 회원가입 화면
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-02
/// Updt : 2025-04-07
/// =============================================================

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'password_screen.dart';

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

  final emailRegex = RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'); // 이메일 정규식

  // 인증코드 요청
  Future<void> handleSendCode() async {
    final email = emailController.text.trim().toLowerCase();
    if (!emailRegex.hasMatch(email)) {
      setState(() => errorMessage = '올바른 이메일 형식을 입력해주세요.');
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/send-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        errorMessage = '';
        codeStep = true;
      });
    } else {
      setState(() => errorMessage = '인증코드 전송에 실패했습니다.');
    }
  }

  // 인증코드 검증
  Future<void> handleVerifyCode() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'authCode': code}),
    );

    // 인증 성공 시 다음 화면으로 이동
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('인증 성공'),
          content: const Text('인증되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PasswordScreen(
                      email: email,
                      authCode: code,
                    ),
                  ),
                );
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );

    // 인증 실패 시 알림
    } else {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('인증 실패'),
          content: Text('인증코드를 다시 확인해주세요.'),
        ),
      );
    }
  }

  // 인증코드 재전송 팝업
  void showResendPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('코드 재전송'),
        content: const Text('코드를 재전송하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              handleSendCode(); // 재전송
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // ✅ 임시 코드 : 디버깅용 (인증단계 강제 진입)
  void handleSkipToCode() {
    setState(() {
      codeStep = true;
      errorMessage = '';
    });
  }

  // ✅ 임시 코드 : 디버깅용 (다음 단계-비밀번호 설정으로 이동)
  void handleSkipToPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PasswordScreen(
          email: emailController.text.trim(),
          authCode: 'dummy',
        ),
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // 어플 로고
                Image.asset('assets/main_logo.png', height: 100, color: kPrimaryColor),
                const SizedBox(height: 16),

                // 타이틀
                const Text('이메일로 회원가입',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: kPrimaryColor)),
                const SizedBox(height: 24),
                
                // 이메일 형식 오류 메시지
                if (errorMessage.isNotEmpty && !codeStep)
                  Text(errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 13)),

                // 이메일 입력 필드
                TextField(
                  controller: emailController,
                  enabled: !codeStep, // 인증 단계 이후에는 비활성화
                  decoration: InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                // 인증코드 전송 버튼
                if (!codeStep) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: handleSendCode,
                    child: const Text('인증코드 전송'),
                  ),

                  // ✅ 임시 버튼
                  TextButton(
                    onPressed: handleSkipToCode,
                    child: const Text('스킵 →', style: TextStyle(fontSize: 12)),
                  ),
                ],

                // 인증코드 입력 및 검증
                if (codeStep) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: '인증코드',
                      hintText: '6자리 인증코드 입력',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                          child: const Text('코드 재전송'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: handleVerifyCode,
                          child: const Text('인증하기'),
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
                      child: const Text('이메일 재입력',
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.black54)),
                    ),
                  ),

                  // ✅ 임시버튼
                  TextButton(
                    onPressed: handleSkipToPassword,
                    child: const Text('스킵 →', style: TextStyle(fontSize: 12)),
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