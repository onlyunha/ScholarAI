import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../services/scholarship_service.dart';
import '../../widgets/scholarship_card.dart';
import 'scholarship_detail_screen.dart';

class ScholarshipListScreen extends StatefulWidget {
  const ScholarshipListScreen({super.key});

  @override
  State<ScholarshipListScreen> createState() => _ScholarshipListScreenState();
}

class _ScholarshipListScreenState extends State<ScholarshipListScreen> {
  final TextEditingController keywordController = TextEditingController();
  List<String> selectedTypes = [];
  bool onlyRecruiting = false;

  int currentPage = 0;
  final int pageSize = 10;
  List<ScholarshipSummary> scholarships = [];
  bool isLoading = false;

  final List<Map<String, String>> financialAidTypeOptions = [
    {'value': 'REGIONAL', 'label': '지역연고'},
    {'value': 'SPECIAL', 'label': '특기자'},
    {'value': 'MERIT', 'label': '성적우수'},
    {'value': 'INCOME', 'label': '소득구분'},
    {'value': 'DISABILITY', 'label': '장애인'},
    {'value': 'OTHER', 'label': '기타'},
    {'value': 'NONE', 'label': '해당없음'},
  ];

  @override
  void initState() {
    super.initState();
    fetchScholarships();
  }

  Future<void> fetchScholarships() async {
    setState(() => isLoading = true);
    try {
      final results = await searchScholarships(
        keyword: keywordController.text,
        financialAidTypes: selectedTypes,
        onlyRecruiting: onlyRecruiting,
        page: currentPage,
        size: pageSize,
      );
      setState(() {
        scholarships = results;
      });
    } catch (e) {
      debugPrint('장학금 조회 실패: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleFilter(String type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
    });
  }

  void goToDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScholarshipDetailScreen(scholarshipId: id),
      ),
    );
  }

  String formatDate(String raw) {
    final date = DateTime.parse(raw);
    return DateFormat('yyyy.MM.dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          '장학금 검색',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: 16),
        child: Column(
          children: [
            // 검색창
            TextField(
              controller: keywordController,
              onSubmitted: (_) {
                currentPage = 0;
                fetchScholarships();
              },
              decoration: InputDecoration(
                hintText: '운영기관 또는 장학금명 검색',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    currentPage = 0;
                    fetchScholarships();
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // 필터 영역
            Wrap(
              spacing: 8,
              children: financialAidTypeOptions.map((option) {
                final selected = selectedTypes.contains(option['value']);
                return FilterChip(
                  label: Text(option['label']!),
                  selected: selected,
                  onSelected: (_) {
                    toggleFilter(option['value']!);
                    fetchScholarships();
                  },
                  selectedColor: kPrimaryColor.withOpacity(0.2),
                  checkmarkColor: kPrimaryColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // 모집중 체크박스
            Row(
              children: [
                Checkbox(
                  value: onlyRecruiting,
                  onChanged: (val) {
                    setState(() {
                      onlyRecruiting = val ?? false;
                      currentPage = 0;
                    });
                    fetchScholarships();
                  },
                ),
                const Text('모집중만 보기'),
              ],
            ),

            const SizedBox(height: 12),

            // 결과 리스트
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : scholarships.isEmpty
                      ? const Center(child: Text('검색 결과가 없습니다.'))
                      : ListView.separated(
                          itemCount: scholarships.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = scholarships[index];
                            return GestureDetector(
                              onTap: () => goToDetail(item.id),
                              child: ScholarshipCard(
                                organization: item.organizationName,
                                name: item.productName,
                                type: item.financialAidType,
                                start: formatDate(item.applicationStartDate),
                                end: formatDate(item.applicationEndDate),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
