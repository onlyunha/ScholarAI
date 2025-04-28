/// =============================================================
/// File : main. dart
/// Desc : 메인
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-03-23
/// Updt : 2025-04-23
/// =============================================================

import 'package:flutter/material.dart';
import 'package:scholarai/screens/home/tabs/scholarship_tab.dart';
import 'constants.dart';
import 'screens/welcome_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';



// 앱의 진입점
void main() {
  // 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: 'dec207abce195979ff115068369eae7c');
  
  // Flujtter 오류 처리 설정
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // Provider 포함하여 앱 실행
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScholarAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF222222)),
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4A6CF7),
          secondary: Color(0xFFE5EBFF),
          error: Color(0xFFFF4D4D),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A6CF7),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF4A6CF7),
          ),
        ),
      ),
      // 첫 화면 설정
      home: const WelcomeScreen(),
    );
  }
}