/// =============================================================
/// File : community_rules_screen.dart
/// Desc : 커뮤니티 이용규칙
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-03
/// Updt : 2025-06-03
/// =============================================================

import 'package:flutter/material.dart';

class CommunityRulesScreen extends StatelessWidget {
  const CommunityRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '커뮤니티 이용규칙 안내',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '건강한 커뮤니티 이용 문화를 위해 마련된 가이드라인입니다. 원활한 서비스 이용을 위해 아래 규칙을 꼭 지켜주세요. 이용규칙에 명시된 사항 외에도 커뮤니티의 본질과 분위기를 해치는 글, 댓글 등은 임의 조치될 수 있음을 알려드립니다.\n\n이용 규칙을 준수하지 않아 생기는 불이익은 책임지지 않습니다.',
              style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '커뮤니티 금지사항',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _RuleItem(index: 1, content: '비방, 욕설, 혐오 표현 등 타인을 불쾌하게 만드는 언행'),
            _RuleItem(index: 2, content: '허위 사실 유포 및 근거 없는 정보 공유'),
            _RuleItem(index: 3, content: '광고성 게시물 또는 무단 홍보 행위'),
            _RuleItem(index: 4, content: '개인정보 노출 및 타인의 사생활 침해'),
            _RuleItem(index: 5, content: '기타 커뮤니티 목적과 맞지 않는 부적절한 활동'),
          ],
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final int index;
  final String content;

  const _RuleItem({required this.index, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index.', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}