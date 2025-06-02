/// =============================================================
/// File : seetings_tab.dart
/// Desc : 환경설정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-06-01
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/providers/auth_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<AuthProvider>(context).email ?? '이메일 없음';

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          const SizedBox(height: 40),
          _buildSectionTitle('회원정보'),
          _buildSimpleItem(icon: Icons.email, label: '이메일', trailing: email),
          _buildSimpleItem(icon: Icons.lock, label: '비밀번호 변경', onTap: () {}),
          _buildSimpleItem(
            icon: Icons.person,
            label: '프로필 조회 및 변경',
            onTap: () => context.push(AppRoutes.profileView),
          ),
          _sectionDivider(),

          _buildSectionTitle('커뮤니티'),
          _buildSimpleItem(
            icon: Icons.article_outlined,
            label: '내가 쓴 글',
            onTap: () {},
          ),
          _buildSimpleItem(
            icon: Icons.chat_bubble_outline,
            label: '내가 쓴 댓글',
            onTap: () {},
          ),
          _buildSimpleItem(icon: Icons.rule, label: '커뮤니티 이용규칙', onTap: () => context.push(AppRoutes.communityRules)),
          _sectionDivider(),

          _buildSectionTitle('앱 설정'),
          _buildSimpleItem(
            icon: Icons.notifications_none,
            label: '알림 설정',
            onTap: () {},
          ),
          _sectionDivider(),

          _buildSectionTitle('이용 안내'),
          _buildSimpleItem(
            icon: Icons.help_outline,
            label: '튜토리얼',
            onTap: () => context.push(AppRoutes.tutorial),
          ),
          _sectionDivider(),

          _buildSectionTitle('기타'),
          _buildSimpleItem(
            icon: Icons.delete_forever,
            label: '회원 탈퇴',
            onTap: () {},
            textColor: Colors.red,
          ),
          _buildSimpleItem(
            icon: Icons.logout,
            label: '로그아웃',
            onTap: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.clearAuthData();

              // 로그인 화면으로 이동 (스택 초기화)
              context.go(AppRoutes.welcome);
            },
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Divider(thickness: 1, color: Colors.black12),
    );
  }

  Widget _buildSimpleItem({
    required IconData icon,
    required String label,
    String? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? kPrimaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor ?? Colors.black,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
