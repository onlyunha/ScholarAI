/// =============================================================
/// File : seetings_tab.dart
/// Desc : 환경설정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-
/// Updt : 2025-04-
/// =============================================================
library;

import 'package:flutter/material.dart';
import '../../../widgets/custom_app_bar.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Center(
        child: Text('⚙️ 설정 탭 내용'),
      ),
    );
  }
}
