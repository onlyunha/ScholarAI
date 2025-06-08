/// =============================================================
/// File : main_screen.dart
/// Desc : 메인 탭
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-06-01
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'tabs/home_tab.dart';
import 'tabs/scholarship_tab.dart';
import 'tabs/bookmark_tab.dart';
import 'tabs/community/community_tab.dart';
import 'tabs/settings_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _initializedFromQuery = false;

  final List<Widget> _tabs = const [
    HomeTab(),
    ScholarshipTab(),
    BookmarkTab(),
    CommunityTab(),
    SettingsTab(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initializedFromQuery) return; // 이미 초기화했으면 무시
    _initializedFromQuery = true;

    final tabParam = GoRouterState.of(context).uri.queryParameters['tab'];
    if (tabParam != null) {
      // 숫자형으로 전달된 경우 (예: /main?tab=2)
      final parsedIndex = int.tryParse(tabParam);
      if (parsedIndex != null &&
          parsedIndex >= 0 &&
          parsedIndex < _tabs.length) {
        setState(() {
          _currentIndex = parsedIndex;
        });
        return;
      }

      // 문자형으로 전달된 경우 (예: /main?tab=community)
      switch (tabParam) {
        case 'scholarship':
          setState(() => _currentIndex = 1);
          break;
        case 'bookmark':
          setState(() => _currentIndex = 2);
          break;
        case 'community':
          setState(() => _currentIndex = 3);
          break;
        case 'settings':
          setState(() => _currentIndex = 4);
          break;
        default:
          setState(() => _currentIndex = 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '장학금'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
