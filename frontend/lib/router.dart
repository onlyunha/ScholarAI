import 'package:go_router/go_router.dart';
import 'package:scholarai/screens/settings/profile_view_screen.dart';

// 화면 import
import 'screens/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/password_screen.dart';
import 'screens/auth/welcome_name_screen.dart';
import 'screens/home/main_screen.dart';
import 'screens/settings/profile_edit_screen.dart';

// GoRouter 인스턴스
final GoRouter router = GoRouter(
  routes: [
    /// Welcome
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),

    /// Login
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    /// Signup
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),

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
          path: '/profile-edit', // 상대 경로를 이용해 하위 경로로 설정
          builder: (context, state) => const ProfileEditScreen(),
        ),
      ],
    ),
  ],
);
