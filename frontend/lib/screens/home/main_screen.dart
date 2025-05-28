/// =============================================================
/// File : main_screen.dart
/// Desc : 메인 탭
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-04-28
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/scholarship_tab.dart';
import 'tabs/bookmark_tab.dart';
import 'tabs/community_tab.dart';
import 'tabs/settings_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeTab(),
    ScholarshipTab(),
    BookmarkTab(),
    CommunityTab(),
    SettingsTab(),
  ];

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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '장학금',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
