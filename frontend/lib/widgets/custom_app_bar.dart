/// =============================================================
/// File : custom_app_bar.dart
/// Desc : 앱 상단바
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-04-23
/// =============================================================

import 'package:flutter/material.dart';
import 'package:scholarai/screens/settings/profile_view_screen.dart';
import '../../constants.dart';
import '../../screens/settings/profile_edit_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          'assets/main_logo.png',
          color: kPrimaryColor,
        ),
      ),
actions: [
  Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Row(
      children: [
        IconButton(
          icon: Image.asset(
            'assets/AI_logo.png',
            height: 30,
            width: 30,
            color:kPrimaryColor
          ),
          onPressed: () {
            // TODO: AI 챗봇 연결
          },
        ),
        const SizedBox(width: 0), // 아이콘 사이 간격 조절
        IconButton(
          iconSize: 30,
          icon: const Icon(Icons.person, color: kPrimaryColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileViewScreen(),
              ),
            );
          },
        ),
      ],
    ),
  ),
],
    );
  }
}
