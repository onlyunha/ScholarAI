import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
// import '../../../services/scholarship_service.dart'; // ❌ 주석처리
import '../../../widgets/scholarship_card.dart';
// import '../../scholarships/scholarship_detail_screen.dart'; // ❌ 주석처리

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController keywordController = TextEditingController();
  List<Map<String, String>> searchResults = []; // 임시 Map 구조
  bool isLoading = false;

  Future<void> handleSearch() async {
    final keyword = keywordController.text.trim();
    if (keyword.isEmpty) return;

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // 실제 서버 요청은 주석 처리
      /*
      final results = await searchScholarships(
        keyword: keyword,
        page: 0,
        size: 10,
      );
      */

      // ✅ 임시 mock 데이터로 대체
      final results = [
        {
          'organization': '모의재단',
          'productName': '모의장학금',
          'financialAidType': '성적우수',
          'applicationStartDate': '2025-04-01',
          'applicationEndDate': '2025-04-30',
        },
        {
          'organization': '모의재단2',
          'productName': '모의장학금2',
          'financialAidType': '소득구분',
          'applicationStartDate': '2025-05-01',
          'applicationEndDate': '2025-05-31',
        },
      ];

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      debugPrint('❌ 검색 실패: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String formatDate(String? raw) {
    try {
      if (raw == null || raw.isEmpty) return '-';
      final date = DateTime.parse(raw);
      return DateFormat('yyyy.MM.dd').format(date);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔍 장학금 검색',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: keywordController,
                    onSubmitted: (_) => handleSearch(),
                    decoration: InputDecoration(
                      hintText: '운영기관명 또는 상품명 검색',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: handleSearch,
                  child: const Text('검색'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (searchResults.isEmpty)
              const Center(child: Text('검색 결과가 없습니다.'))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      // 상세 페이지 이동은 현재 주석 처리
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => ScholarshipDetailScreen(scholarshipId: 1)));
                    },
                    child: ScholarshipCard(
                      organization: item['organization'] ?? '',
                      name: item['productName'] ?? '',
                      type: item['financialAidType'] ?? '',
                      start: formatDate(item['applicationStartDate']),
                      end: formatDate(item['applicationEndDate']),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
