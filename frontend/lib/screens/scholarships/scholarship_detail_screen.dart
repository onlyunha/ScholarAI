import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../services/scholarship_service.dart';

class ScholarshipDetailScreen extends StatefulWidget {
  final int scholarshipId;

  const ScholarshipDetailScreen({super.key, required this.scholarshipId});

  @override
  State<ScholarshipDetailScreen> createState() => _ScholarshipDetailScreenState();
}

class _ScholarshipDetailScreenState extends State<ScholarshipDetailScreen> {
  ScholarshipDetail? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final data = await getScholarshipDetail(widget.scholarshipId);
      setState(() {
        detail = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('상세 조회 실패: $e');
      setState(() => isLoading = false);
    }
  }

  Widget buildDetailItem(String title, String value) {
    if (value.isEmpty || value == '해당없음') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장학금 상세정보', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
              ? const Center(child: Text('정보를 불러올 수 없습니다.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(detail!.productName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text(detail!.organizationName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          )),
                      const SizedBox(height: 16),

                      // 상세 항목들
                      buildDetailItem('학자금 유형', detail!.financialAidType),
                      buildDetailItem('운영기관 구분', detail!.organizationType),
                      buildDetailItem('상품 구분', detail!.productType),
                      buildDetailItem('지원대학 유형', detail!.universityType),
                      buildDetailItem('지원 학기', detail!.gradeSemester),
                      buildDetailItem('지원 학과', detail!.majorField),
                      buildDetailItem('성적 기준', detail!.academicRequirement),
                      buildDetailItem('소득 기준', detail!.incomeRequirement),
                      buildDetailItem('지원 금액', detail!.fundingAmount),
                      buildDetailItem('특정 자격', detail!.specificEligibility),
                      buildDetailItem('지역 요건', detail!.regionalRequirement),
                      buildDetailItem('선발 방법', detail!.selectionMethod),
                      buildDetailItem('선발 인원', detail!.selectionCount),
                      buildDetailItem('자격 제한', detail!.eligibilityRestriction),
                      buildDetailItem('제출 서류', detail!.requiredDocuments),
                      buildDetailItem('모집 기간',
                          '${detail!.applicationStartDate} ~ ${detail!.applicationEndDate}'),
                      buildDetailItem('홈페이지', detail!.websiteUrl),
                    ],
                  ),
                ),
    );
  }
}
