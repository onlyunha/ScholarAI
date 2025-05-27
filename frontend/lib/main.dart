/// =============================================================
/// File : main. dart
/// Desc : 메인
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-03-23
/// Updt : 2025-05-20
/// =============================================================

import 'package:flutter/material.dart';
import 'package:scholarai/providers/bookmarked_provider.dart';
import 'package:scholarai/router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';


// 앱의 진입점
void main() async {
  // 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: 'dec207abce195979ff115068369eae7c');

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  // Flujtter 오류 처리 설정
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // Provider 포함하여 앱 실행
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkedProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF4A6CF7)),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en'), // 영어 (기본)
      ],

      // 첫 화면 설정
      routerConfig: router,
    );
  }
}
