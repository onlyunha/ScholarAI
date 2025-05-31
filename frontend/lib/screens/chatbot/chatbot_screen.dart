/// =============================================================
/// File : chatbot_screen.dart
/// Desc : 챗봇 (UI만)
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-01
/// Updt : 2025-06-01
/// =============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_routes.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': '카테고리1', 'icon': Icons.school},
      {'label': '카테고리2', 'icon': Icons.search},
      {'label': '카테고리3', 'icon': Icons.groups},
      {'label': '카테고리4', 'icon': Icons.account_balance},
      {'label': '카테고리5', 'icon': Icons.sync_alt},
      {'label': '카테고리6', 'icon': Icons.report_problem},
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // 자동 뒤로가기 비활성화
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.main); // 또는 원하는 기본 경로로
            }
          },
        ),
        title: null,
      ),
      body: Column(
        children: [
          // 챗봇 메시지 영역
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 챗봇 아이콘
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: kPrimaryColor,
                      child: Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 챗봇 말풍선
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '안녕하세요. ScholarAI 챗봇입니다.\n궁금한 내용을 자유롭게 물어보세요!',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 카테고리 버튼들 (3x2 구성, 정사각형)
                // 카테고리 버튼들 (챗봇 아이콘 침범 안 하게 왼쪽 여백 확보)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 48,
                    top: 8,
                  ), // ← 아이콘 공간 확보!
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children:
                        categories.map((item) {
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                // TODO: 버튼 눌렀을 때 동작
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item['icon'] as IconData, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['label'] as String,
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // 하단 입력창 자리 (비활성화)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: '추후 입력 가능',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.send, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
