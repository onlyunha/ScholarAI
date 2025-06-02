/// =============================================================
/// File : comment_card.dart
/// Desc : 댓글 카드
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-03
/// Updt : 2025-06-03
/// =============================================================

import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('익명${comment['authorId']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(comment['content']),
          const SizedBox(height: 4),
          Text(comment['createdAt'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
