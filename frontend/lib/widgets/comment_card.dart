/// =============================================================
/// File : comment_card.dart
/// Desc : 댓글 카드
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-03
/// Updt : 2025-06-08
/// =============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/services/community_board.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> comment;
  final VoidCallback onChanged;
  final void Function(int commentId, String content) onEdit;
  final void Function(int commentId) onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myMemberId = context.read<AuthProvider>().memberId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.comment['authorName'] ?? '익명',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                widget.comment['createdAt']?.substring(0, 10) ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              if (widget.comment['memberId'].toString() == myMemberId)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      widget.onEdit(
                        widget.comment['commentId'],
                        widget.comment['content'],
                      );
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              content: const Text(
                                '정말 삭제할까요?',
                                style: TextStyle(fontSize: 14),
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('삭제'),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        await CommunityBoardService.deleteComment(
                          widget.comment['commentId'],
                        );
                        widget.onDelete(widget.comment['commentId']);
                      }
                    }
                  },
                  itemBuilder:
                      (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('수정')),
                        PopupMenuItem(value: 'delete', child: Text('삭제')),
                      ],
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.comment['content'] ?? ''),
        ],
      ),
    );
  }
}
