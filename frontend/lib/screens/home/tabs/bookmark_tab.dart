/// =============================================================
/// File : bookmark_tab.dart
/// Desc : 찜한 장학금 + 캘린더
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-04-21
/// =============================================================

import 'package:flutter/material.dart';
import '../../../widgets/custom_app_bar.dart';

class BookmarkTab extends StatelessWidget {
  const BookmarkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Center(
        child: Text('🔖 찜한 항목 탭 내용'),
      ),
    );
  }
}
