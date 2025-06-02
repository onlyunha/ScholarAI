/// =============================================================
/// File : community_tab.dart
/// Desc : 커뮤니티 게시판
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-06-01
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/widgets/custom_app_bar.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 12, bottom: 80),
        itemCount: 11, // 공지 + 10개 게시글
        separatorBuilder:
            (_, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: Colors.black12),
            ),
        itemBuilder: (context, index) {
          if (index == 0) {
            // 공지사항
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.communityRules),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check, size: 18, color: kPrimaryColor),
                          SizedBox(width: 6),
                          Text(
                            '커뮤니티 이용규칙',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '건강한 커뮤니티를 위한 기본 규칙을 확인해 주세요 ',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final postIndex = index - 1; // 실제 게시글 인덱스

          return GestureDetector(
            onTap: () => context.push('/post/detail/$postIndex'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '익명${postIndex + 1}의 글 제목입니다',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '5',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '2025.06.${postIndex + 1}'.padLeft(2, '0'),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '익명${postIndex + 1}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.postWrite),
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
