/// =============================================================
/// File : profile_view_screen.dart
/// Desc : 프로필 보기 화면
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-04-28
/// =============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import '../../../providers/user_profile_provider.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProfileProvider>();
    final age =
        user.birthYear == null
            ? ''
            : '만 ${DateTime.now().year - user.birthYear!}세';

            

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Text(
            '<',
            style: TextStyle(
              fontSize: 24,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
    onPressed: () {
      if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();  // 이전 화면으로 pop
    } else {
      context.go('/main'); 
    }

    }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              user.name ?? '이름 미입력',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '기본정보',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            if (user.birthYear != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${user.birthYear}년생, $age'),
              ),
            if (user.gender != null || user.region != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${user.gender ?? ''}${user.gender != null && user.region != null ? ', ' : ''}${user.region ?? ''} 거주',
                ),
              ),
            const SizedBox(height: 24),
            if (user.university != null ||
                user.universityType != null ||
                user.academicStatus != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${user.university ?? ''}${user.universityType != null ? '(${user.universityType})' : ''} ${user.academicStatus ?? ''}',
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.go('/profile-view/profile-edit');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('편집하기', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
