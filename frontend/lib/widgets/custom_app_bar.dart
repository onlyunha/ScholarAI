/// =============================================================
/// File : custom_app_bar.dart
/// Desc : 앱 상단바
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-04-28
/// =============================================================

import 'package:flutter/material.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_images.dart';
import 'package:scholarai/screens/settings/profile_edit_screen.dart';

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
        child: Image.asset(AppImages.mainLogo, color: kPrimaryColor),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  AppImages.aiLogo,
                  height: 30,
                  width: 30,
                  color: kPrimaryColor,
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
                      builder: (_) => const ProfileEditScreen(),
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