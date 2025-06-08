/// =============================================================
/// File : scholarship_card.dart
/// Desc : 장학금 카드
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-05-20
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:scholarai/constants/app_colors.dart';

class ScholarshipCard extends StatelessWidget {
  final String productName;
  final String organization;
  final List<String> types;
  final String start;
  final String end;

  final VoidCallback? onTap;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const ScholarshipCard({
    super.key,
    required this.productName,
    required this.organization,
    required this.types,
    required this.start,
    required this.end,
    this.onTap,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  organization,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      types.map((t) => '#$t').join(' '),
                      style: const TextStyle(
                        fontSize: 13,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      '$start ~ $end',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 하트 아이콘
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isBookmarked ? Icons.favorite : Icons.favorite_border,
                color: isBookmarked ? Colors.red : Colors.grey,
              ),
              onPressed: onBookmarkToggle,
            ),
          ),
        ],
      ),
    );
  }
}
