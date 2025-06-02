/// =============================================================
/// File : post_detail_screen.dart
/// Desc : 커뮤니티 게시판 - 글 조회
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-03
/// Updt : 2025-06-03
/// =============================================================

import 'package:flutter/material.dart';
import 'package:scholarai/constants/app_colors.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  final Map<String, dynamic> post = {
    'title': '장학금 관련 질문입니다',
    'content': '이거 n살도 지원 가능한가요?',
    'createdAt': '2025.06.03 00:02',
  };

  List<Map<String, dynamic>> comments = [
    {
      'content': '가능해요 저도 작년에 지원했어요',
      'createdAt': '2025.06.03 00:04',
    },
    {
      'content': '아 감사합니다',
      'createdAt': '2025.06.03 00:05',
    },
    {
      'content': '네 좋은 하루되세요~',
      'createdAt': '2025.06.03 00:12',
    },
  ];

  void _handleSubmitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      comments.add({
        'content': text,
        'createdAt': '2025.06.03 13:00',
      });
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                // 게시글 카드
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post['createdAt'],
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        post['content'],
                        style: const TextStyle(fontSize: 15, height: 1.6),
                      ),
                    ],
                  ),
                ),
                Text(
                  ' ${comments.length}개의 댓글',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ...comments.map((comment) => _buildCommentCard(comment)).toList(),
              ],
            ),
          ),
          _buildCommentInputField(),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('익명', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(
                comment['createdAt'],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment['content']),
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _handleSubmitComment,
              icon: const Icon(Icons.send, color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
