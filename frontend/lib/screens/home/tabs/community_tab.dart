/// =============================================================
/// File : community_tab.dart
/// Desc : 커뮤니티 게시판
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-04-21
/// =============================================================
library;

import 'package:flutter/material.dart';
import '../../../widgets/custom_app_bar.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Center(
        child: Text('💬 커뮤니티 탭 내용'),
      ),
    );
  }
}
