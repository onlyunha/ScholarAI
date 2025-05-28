/// =============================================================
/// File : scholarship_detail_sheet.dart
/// Desc : 장학금 상세 정보 시트
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-05-20
/// Updt : 2025-05-21
/// =============================================================
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/config.dart';
import 'package:http/http.dart' as http;
import 'package:scholarai/providers/bookmarked_provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScholarshipDetailSheet {
  static Future<void> show(BuildContext context, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/scholarships/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookmarkedProvider = Provider.of<BookmarkedProvider>(
          context,
          listen: false,
        );
        final memberId =
            Provider.of<UserProfileProvider>(
              context,
              listen: false,
            ).getUserId();
        final isInitiallyBookmarked = bookmarkedProvider.isBookmarked(id);
        bool isBookmarked = isInitiallyBookmarked;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Text(
                        data['productName'] ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['organizationName'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${data['applicationStartDate']} ~ ${data['applicationEndDate']}',
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '#${_convertToKorean(data['financialAidType'])}',
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.favorite : Icons.favorite_border,
                          color: isBookmarked ? kPrimaryColor : Colors.grey,
                        ),
                        onPressed: () {
                          if (memberId != null) {
                            bookmarkedProvider.toggleBookmark(memberId, id);
                            isBookmarked = !isBookmarked;
                            // 하트 아이콘 갱신
                            (context as Element).markNeedsBuild();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('로그인이 필요합니다.')),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 32),
                      const SizedBox(height: 20),
                      const Text(
                        '상세 정보',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('기관유형', data['organizationType']),
                      _buildDetailRow('장학금유형', data['productType']),
                      _buildDetailRow('대학 유형', data['universityType']),
                      _buildDetailRow('대상 학기', data['gradeSemester']),
                      _buildDetailRow('지원 계열', data['majorField']),
                      _buildDetailRow(
                        '학업 요건',
                        (data['academicRequirement'] as List).join('\n'),
                      ),
                      _buildDetailRow(
                        '소득 요건',
                        (data['incomeRequirement'] as List).join('\n'),
                      ),
                      _buildDetailRow(
                        '지원 금액',
                        (data['fundingAmount'] as List).join('\n'),
                      ),
                      _buildDetailRow(
                        '특별 요건',
                        (data['specificEligibility'] as List).join('\n'),
                      ),
                      _buildDetailRow(
                        '선발 인원',
                        (data['selectionCount'] as List).join('\n'),
                      ),
                      _buildDetailRow(
                        '심사 방법',
                        (data['selectionMethod'] as List).join('\n'),
                      ),
                      _buildDetailRow(
                        '필요 서류',
                        (data['requiredDocuments'] as List).join('\n'),
                      ),
                      _buildLinkRow('지원 사이트', data['websiteUrl']),
                    ],
                  ),
                );
              },
            );
          },
        );
      } else {
        debugPrint('서버 응답 실패: \${response.statusCode}');
      }
    } catch (e) {
      debugPrint('상세 정보 요청 실패: \$e');
    }
  }

  static Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  static String _convertToKorean(String? code) {
    switch (code) {
      case 'MERIT':
        return '성적우수';
      case 'INCOME':
        return '소득구분';
      case 'REGIONAL':
        return '지역연고';
      case 'DISABILITY':
        return '장애인';
      case 'SPECIAL':
        return '특기자';
      case 'OTHER':
        return '기타';
      default:
        return '기타';
    }
  }

  static Widget _buildLinkRow(String title, String? url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () async {
              if (url != null && await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: Text(
              url ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
