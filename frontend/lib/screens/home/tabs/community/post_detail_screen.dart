/// =============================================================
/// File : post_detail_screen.dart
/// Desc : 커뮤니티 게시판 - 글 조회
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-03
/// Updt : 2025-06-08
/// =============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/services/community_board.dart';
import 'package:scholarai/widgets/comment_card.dart';
import 'package:scholarai/widgets/comment_input_field.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isDeleting = false;

  Map<String, dynamic>? post;
  List<Map<String, dynamic>> comments = [];
  bool _isLoading = true;
  int? editingCommentId;
  String? editingOriginalContent;

  @override
  void initState() {
    super.initState();
    _loadPostAndComments();
  }

  Future<void> _loadPostAndComments() async {
    try {
      final postData = await CommunityBoardService.fetchPost(widget.postId);
      final commentData = await CommunityBoardService.fetchComments(
        widget.postId,
      );
      if (!mounted) return;

      setState(() {
        post = postData;
        comments = commentData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ 오류 발생: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      await CommunityBoardService.createComment(widget.postId, text);
      _commentController.clear();
      final newComments = await CommunityBoardService.fetchComments(
        widget.postId,
      );
      setState(() {
        comments = newComments;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('댓글 작성에 실패했습니다')));
    }
  }

  void _removeCommentById(int commentId) {
    setState(() {
      comments.removeWhere((comment) => comment['commentId'] == commentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (post != null) {
      debugPrint('🧾 post.memberId = ${post?['memberId']}');
      debugPrint('🧾 로그인한 memberId = ${authProvider.memberId}');
    }
    final visibleComments =
        comments.where((comment) => comment['content'] != '삭제된 댓글입니다').toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/main?tab=3');
          },
        ),
        actions: [
          if (post != null &&
              post!['memberId']?.toString() == authProvider.memberId)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await context.push(
                    '/post/edit/${widget.postId}',
                    extra: {
                      'title': post?['title'] ?? '',
                      'content': post?['content'] ?? '',
                    },
                  );

                  if (result == 'updated' && mounted) {
                    context.go('/main?tab=community'); // 리스트로 강제 이동
                  }
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text(
                            '정말 삭제할까요?',
                            style: TextStyle(fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('삭제'),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true && !_isDeleting) {
                    setState(() => _isDeleting = true);
                    try {
                      await CommunityBoardService.deletePost(widget.postId);
                      if (!mounted) return;
                      context.go('/main?tab=3');
                    } catch (e) {
                      debugPrint('❌ 삭제 중 오류 발생: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('삭제 실패: ${e.toString()}')), // 디버깅용
                        // const SnackBar(content: Text('게시글 삭제에 실패했어요')),
                      );
                    } finally {
                      if (mounted) setState(() => _isDeleting = false);
                    }
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : (post == null)
              ? const Center(child: Text('게시글 정보를 불러오지 못했습니다.'))
              : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      children: [
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
                                post?['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                '${post?['authorName'] ?? '익명'} · ${(post?['createdAt'] ?? '').replaceFirst('T', ' ').substring(0, 16)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                post?['content'] ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          ' ${visibleComments.length}개의 댓글',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...visibleComments.map(
                          (comment) => CommentCard(
                            comment: comment,
                            onChanged: _loadPostAndComments,
                            onEdit: (commentId, content) {
                              setState(() {
                                editingCommentId = commentId;
                                _commentController.text = content;
                              });
                            },
                            onDelete: _removeCommentById,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (editingCommentId != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 4,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '✏️ 댓글 수정 중',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                editingCommentId = null;
                                _commentController.clear();
                              });
                            },
                            child: const Text(
                              '취소',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  CommentInputField(
                    controller: _commentController,
                    onSubmit: () async {
                      final text = _commentController.text.trim();
                      if (text.isEmpty) return;

                      try {
                        if (editingCommentId != null) {
                          await CommunityBoardService.updateComment(
                            editingCommentId!,
                            text,
                          );
                          setState(() {
                            editingCommentId = null;
                          });
                        } else {
                          // 새 댓글
                          await CommunityBoardService.createComment(
                            widget.postId,
                            text,
                          );
                        }
                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                        final newComments =
                            await CommunityBoardService.fetchComments(
                              widget.postId,
                            );
                        setState(() => comments = newComments);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('댓글 처리 실패')),
                        );
                      }
                    },
                  ),
                ],
              ),
    );
  }
}
