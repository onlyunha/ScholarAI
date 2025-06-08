/// =============================================================
/// File : chatbot_screen.dart
/// Desc : 챗봇 (UI만)
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-01
/// Updt : 2025-06-07
/// =============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/constants/config.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  String? selectedCategory;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  final categories = [
    {'label': '국가근로장학금', 'icon': Icons.work},
    {'label': '대통령과학장학금', 'icon': Icons.science},
    {'label': '국가우수장학금(이공계)', 'icon': Icons.engineering},
    {'label': '인문100년장학금', 'icon': Icons.menu_book},
    {'label': '전문기술인재장학금', 'icon': Icons.build},
    {'label': '대학원생지원장학금', 'icon': Icons.school},
    {'label': '푸른등대기부장학금', 'icon': Icons.lightbulb},
    {'label': '국가장학금', 'icon': Icons.flag},
  ];

  void resetChat() {
    setState(() {
      selectedCategory = null;
      messages.clear();
    });
  }

  Future<void> sendMessage(String question) async {
    if (question == '종료') {
      resetChat();
      return;
    }

    setState(() {
      messages.add({'sender': 'user', 'text': question});
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chatbot/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'category': selectedCategory, 'question': question}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['data']['answer'];
        setState(() {
          messages.add({'sender': 'bot', 'text': answer});
        });
      } else {
        setState(() {
          messages.add({'sender': 'bot', 'text': '서버 오류가 발생했어요. 다시 시도해보세요.'});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'text': '네트워크 오류가 발생했어요.'});
      });
    }

    _controller.clear();
  }

  Widget buildMessage(Map<String, String> msg) {
    final isBot = msg['sender'] == 'bot';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot)
            const CircleAvatar(
              radius: 18,
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.smart_toy, size: 20, color: Colors.white),
            ),
          if (!isBot) const SizedBox(width: 36),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isBot ? Colors.grey[200] : kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(msg['text'] ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(AppRoutes.main),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (messages.isEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                ...messages.map(buildMessage).toList(),
                const SizedBox(height: 24),
                if (selectedCategory == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 48, top: 8),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children:
                          categories.map((item) {
                            return SizedBox(
                              width: 120,
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
                                  setState(() {
                                    selectedCategory = item['label'] as String;
                                    messages.add({
                                      'sender': 'bot',
                                      'text':
                                          '${selectedCategory!}에 대해 무엇이 궁금한가요?\n(대화를 종료하려면 \"종료\"라고 입력해주세요)',
                                    });
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item['icon'] as IconData, size: 28),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['label'] as String,
                                      style: const TextStyle(fontSize: 9),
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
                    controller: _controller,
                    enabled: selectedCategory != null,
                    decoration: InputDecoration(
                      hintText:
                          selectedCategory == null
                              ? '카테고리를 먼저 선택하세요'
                              : '질문을 입력하세요',
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
                IconButton(
                  icon: const Icon(Icons.send, color: kPrimaryColor),
                  onPressed:
                      selectedCategory == null
                          ? null
                          : () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) {
                              sendMessage(text);
                            }
                          },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
