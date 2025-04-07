/// =============================================================
/// File : welcome_screen.dart
/// Desc : <<개발중>>
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-02
/// Updt : 2025-04-07
/// =============================================================

import 'package:flutter/material.dart';
import '../constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset('assets/main_logo.png', color: kPrimaryColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: '🎓 추천 장학금',
              content: 'AI가 추천한 맞춤형 장학금 리스트를 확인하세요!',
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: '⏰ 마감 임박 장학금',
              content: '신청 마감이 얼마 남지 않은 장학금을 모아봤어요!',
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: '✅ 신청 현황',
              content: '신청한 장학금의 진행 상황을 한눈에 확인하세요.',
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: '💡 장학금 꿀팁',
              content: '장학금 신청에 도움이 되는 꿀팁을 모았습니다!',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '일정'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSubColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
