/// =============================================================
/// File : home_tab.dart
/// Desc : 기본 메인 탭
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-04-21
/// =============================================================

import 'package:flutter/material.dart';
import '../../../widgets/custom_app_bar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Center(
        child: Text('🏠 개발중'),
      ),
    );
  }
}