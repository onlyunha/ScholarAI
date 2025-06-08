/// =============================================================
/// File : main. dart
/// Desc : 메인
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-03-23
/// Updt : 2025-06-08
/// =============================================================
library;

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/config.dart';
import 'package:scholarai/firebase_options.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/providers/bookmarked_provider.dart';
import 'package:scholarai/router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:scholarai/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // ID
  'High Importance Notifications', // 이름
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

// 앱의 진입점
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones(); 
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission();
  await NotificationService.requestExactAlarmPermission();
  await initializeDateFormatting('ko_KR', null);

  // FCM 토큰 가져오기
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('✅ Device FCM Token: $fcmToken');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'dec207abce195979ff115068369eae7c',
    loggingEnabled: true,
  );

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token'); // 또는 로그인 여부
  final seenTutorial = prefs.getBool('seenTutorial') ?? false;

  final authProvider = AuthProvider();
  await authProvider.loadAuthData();

  String initialRoute;
  if (token == null) {
    initialRoute = '/'; // Welcome
  } else if (!seenTutorial) {
    initialRoute = '/onboarding';
  } else {
    initialRoute = '/main';
    final memberId = authProvider.memberId;
    if (memberId != null && fcmToken != null) {
      await sendFcmTokenToServer(memberId, fcmToken, token);
    }
  }

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
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🟢 사용자가 알림을 클릭했습니다!');
      // TODO: 특정 화면으로 라우팅하려면 여기에 context.push(...) 추가
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProfile = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      final bookmarkedProvider = Provider.of<BookmarkedProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final profileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      await profileProvider.loadProfileIdFromPrefs();

      final memberId = authProvider.memberId;
      if (memberId != null) {
        bookmarkedProvider.loadBookmarks(memberId);
        await userProfile.fetchProfileIdAndLoad(memberId, authProvider.token!);
      }
    });

    return MaterialApp.router(
      title: 'ScholarAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSubColor,
          error: kErrorColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
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
      routerConfig: getRouter(widget.initialRoute),
    );
  }
}

Future<void> sendFcmTokenToServer(
  String memberId,
  String fcmToken,
  String token,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/fcm-token'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'memberId': memberId, 'fcmToken': fcmToken}),
  );

  if (response.statusCode == 200) {
    print('✅ FCM 토큰 서버 저장 성공');
  } else {
    print('❌ FCM 토큰 서버 저장 실패: ${response.statusCode}');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
