/// =============================================================
/// File : comment_input_filed.dart
/// Desc : 댓글 입력창
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-03
/// Updt : 2025-06-03
/// =============================================================


import 'package:flutter/material.dart';
import 'package:scholarai/constants/app_colors.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
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
                controller: controller,
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
              onPressed: onSubmit,
              icon: const Icon(Icons.send, color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
