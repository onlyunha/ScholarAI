/// =============================================================
/// File : login_screen.dart
/// Desc : 이메일과 비밀번호를 이용한 로그인 화면 UI 및 기능 구현
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-02
/// Updt : 2025-04-07
/// =============================================================

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'main_screen.dart';
import 'signup_screen.dart';

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );

    // 실패: 에러 메시지 + shake 애니메이션 
    } else {
      final resBody = jsonDecode(response.body);
      if (resBody['message'].toString().contains('이메일')) {
        setState(() => errorMessage = '이메일을 다시 확인해주세요.');
      } else {
        setState(() => errorMessage = '비밀번호를 다시 확인해주세요.');
      }
      _shakeController.forward(from: 0);
    }
  }

  // 회원 가입 화면 이동 함수
  void goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // 어플 로고
                Image.asset(
                  'assets/main_logo.png',
                  height: 100,
                  color: kPrimaryColor,
                ),
                const SizedBox(height: 16),

                // 로그인 타이틀
                const Text(
                  '로그인',
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
                    labelText: '이메일',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 비밀번호 입력 필드
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),

                const SizedBox(height: 20),

                // 로그인 버튼
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text('로그인'),
                ),

                const SizedBox(height: 20),

                // 회원가입 링크 버튼
                TextButton(
                  onPressed: goToSignup,
                  child: const Text(
                    '아직 계정이 없다면?',
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
