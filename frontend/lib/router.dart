/// =============================================================
/// File : router.dart
/// Desc : 라우터
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-23
/// Updt : 2025-06-08
/// =============================================================

import 'package:go_router/go_router.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/screens/chatbot/chatbot_screen.dart';
import 'package:scholarai/screens/home/tabs/community/community_rules_screen.dart';
import 'package:scholarai/screens/home/tabs/community/community_tab.dart';
import 'package:scholarai/screens/home/tabs/community/post_detail_screen.dart';
import 'package:scholarai/screens/home/tabs/community/post_edit_screen.dart';
import 'package:scholarai/screens/home/tabs/community/post_write_screen.dart';
import 'package:scholarai/screens/onboarding/onboarding_screen.dart';
import 'package:scholarai/screens/onboarding/splash_screen.dart';
import 'package:scholarai/screens/settings/profile_create_screen.dart';
import 'package:scholarai/screens/settings/profile_view_screen.dart';

// 화면 import
import 'screens/onboarding/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/password_screen.dart';
import 'screens/auth/welcome_name_screen.dart';
import 'screens/home/main_screen.dart';
import 'screens/settings/profile_edit_screen.dart';
import 'screens/settings/profile_view_screen.dart';

// GoRouter 인스턴스
GoRouter getRouter(String initialLocation) {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      /// Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      /// Welcome
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      /// Login
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      /// Signup
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      /// PasswordScreen (extra로 email, authCode 받아야 함)
      GoRoute(
        path: '/password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final email = extra['email'] ?? '';
          final authCode = extra['authCode'] ?? '';
          return PasswordScreen(email: email, authCode: authCode);
        },
      ),

      /// WelcomeNameScreen (extra로 email 받아야 함)
      GoRoute(
        path: '/welcome-name',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final email = extra['email'] ?? '';
          return WelcomeNameScreen(email: email);
        },
      ),

      /// Main Screen
      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),

      /// Profile View
      GoRoute(
        path: '/profile-view',
        builder: (context, state) => const ProfileViewScreen(),
        routes: [
          // 프로필 수정 화면이 /profile-view 하위 라우트로 설정
          GoRoute(
            path: 'profile-edit', // 상대 경로를 이용해 하위 경로로 설정
            builder: (context, state) => const ProfileEditScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/profile/create',
        builder: (context, state) => const CreateProfileScreen(),
      ),

      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),

      GoRoute(
        path: '/post/edit/:postId',
        builder: (context, state) {
          final postId = int.parse(state.pathParameters['postId']!);
          final extra = state.extra as Map<String, dynamic>;
          final title = extra['title'] as String? ?? '';
          final content = extra['content'] as String? ?? '';

          return PostEditScreen(
            postId: postId,
            initialTitle: extra['title'] ?? '',
            initialContent: extra['content'] ?? '',
          );
        },
      ),

      GoRoute(
        path: '/post/detail/:postId',
        builder: (context, state) {
          final postId = int.parse(state.pathParameters['postId']!);
          return PostDetailScreen(postId: postId);
        },
      ),

      /// 커뮤니티
      GoRoute(
        path: '/main?tab=community',
        builder: (context, state) => const CommunityTab(),
      ),

      /// 커뮤니티 글쓰기
      GoRoute(
        path: '/post/write',
        builder: (context, state) => const PostWriteScreen(),
      ),

      /// 커뮤니티 이용규칙
      GoRoute(
        path: '/community/rules',
        builder: (context, state) => const CommunityRulesScreen(),
      ),
    ],
  );
}
