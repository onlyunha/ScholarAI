/// =============================================================
/// File : welcome_name_screen.dart
/// Desc : 회원가입 - 이름 설정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-04
/// Updt : 2025-04-28
/// =============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_images.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/constants/app_strings.dart';
import 'package:scholarai/constants/config.dart';
import '../../constants/constants.dart';

// 회원가입 - 이름 설정 화면
class WelcomeNameScreen extends StatefulWidget {
  final String email; // 이전 단계에서 전달된 이메일

  const WelcomeNameScreen({super.key, required this.email});

  @override
  State<WelcomeNameScreen> createState() => _WelcomeNameScreenState();
}

class _WelcomeNameScreenState extends State<WelcomeNameScreen> {
  final nameController = TextEditingController(); // 이름 입력 컨트롤러
  String errorMessage = ''; // 오류 메시지
  bool isLoading = false; // 로딩 상태

  // 한글, 영문 이름만 가능 (최대 20자)
  final nameRegex = RegExp(r'^[가-힣a-zA-Z\s]{1,20}$');

  // 이름 입력 완료 시 서버에 PATCH 요청
  Future<void> handleComplete() async {
    final name = nameController.text.trim();

    // 이름 유효성 검사
    if (!nameRegex.hasMatch(name)) {
      setState(() {
        errorMessage = AppStrings.nameFormatError;
      });
      return;
    }

    // 로딩 시작
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // 서버에 이름 등록 요청
      final response = await http.patch(
        Uri.parse('$baseUrl/api/auth/name'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": widget.email, "name": name}),
      );

      // 성공: 메인화면으로 이동
      if (response.statusCode == 200) {
        context.go(AppRoutes.main);

        // 실패: 오류 메시지
      } else {
        setState(() {
          errorMessage = AppStrings.nameFailed;
        });
      }

      // 네트워크 오류처리
    } catch (e) {
      setState(() {
        errorMessage = AppStrings.networkError;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              vertical: 32,
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
                const SizedBox(height: 20),

                // 타이틀
                const Text(
                  AppStrings.welcomeTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // 안내 문구
                const Text(
                  AppStrings.welcomeSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Pretendard',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // 이름 입력 필드
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: AppStrings.name,
                    hintText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // 오류 메시지 표시
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                // 완료 버튼 (로딩 중이면 비활성화)
                ElevatedButton(
                  onPressed: isLoading ? null : handleComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(AppStrings.completeButton),
                ),

                const SizedBox(height: 12),

                // ✅ 임시 버튼
                // TextButton(
                //   onPressed: handleSkip,
                //   child: const Text('스킵 →', style: TextStyle(fontSize: 12)),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
