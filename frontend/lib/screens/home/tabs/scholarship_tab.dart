/// =============================================================
/// File : schoarlship_tab.dart
/// Desc : 장학금 검색 + 추천
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-04-28
/// =============================================================

import 'package:flutter/material.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_strings.dart';
import '../../../widgets/custom_app_bar.dart';

class ScholarshipTab extends StatefulWidget {
  const ScholarshipTab({super.key});

  @override
  State<ScholarshipTab> createState() => _ScholarshipTabState();
}

class _ScholarshipTabState extends State<ScholarshipTab> {
  final TextEditingController keywordController = TextEditingController();
  bool isSearchMode = true;

  final List<Map<String, dynamic>> mockScholarships = [
    {
      'organization': '인천인재평생교육진흥원',
      'productName': '인천시 청년 해외배낭연수 장학',
      'type': ['성적우수', '지연연고'],
      'start': '2025.03.01',
      'end': '2025.04.30',
    },
    {
      'organization': 'MG새마을금고 지역희망나눔재단',
      'productName': '청년누리 장학생',
      'type': ['소득구분'],
      'start': '2025.03.15',
      'end': '2025.04.15',
    },
    {
      'organization': '이영주한중인재양성장학재단',
      'productName': '한중 미래리더 장학',
      'type': ['소득구분', '특기자'],
      'start': '2025.04.15',
      'end': '2025.05.15',
    },
    {
      'organization': '보건복지부',
      'productName': '보건복지부 공주보건장학',
      'type': ['성적우수'],
      'start': '2025.04.15',
      'end': '2025.04.25',
    },
  ];

  final List<String> aidTypes = ['성적우수', '소득구분', '지역연고', '장애인', '특기자', '기타'];
  late List<String> selectedTypes;
  String selectedPeriod = '전체';
  bool isAllSelected = true;
  List<Map<String, dynamic>> filteredScholarships = [];

  @override
  void initState() {
    super.initState();
    selectedTypes = List.from(aidTypes);
    filteredScholarships = List.from(mockScholarships);
  }

  void handleSearch() {
    final keyword = keywordController.text.toLowerCase();
    final now = DateTime.now();

    final filtered =
        mockScholarships.where((item) {
          // 키워드 검색 조건 (비어 있으면 무시)
          final matchesKeyword =
              keyword.isEmpty ||
              item['productName'].toLowerCase().contains(keyword) ||
              item['organization'].toLowerCase().contains(keyword);

          // 타입 필터 (하나라도 포함되어야 함)
          final matchesType = (item['type'] as List<String>).any(
            (t) => selectedTypes.contains(t),
          );

          // 기간 필터
          final endDate = DateTime.tryParse(item['end'].replaceAll('.', '-'));
          final matchesPeriod =
              selectedPeriod == '전체' ||
              (endDate != null && endDate.isAfter(now));

          return matchesKeyword && matchesType && matchesPeriod;
        }).toList();

    setState(() {
      filteredScholarships = filtered;
    });
  }

  void toggleAllTypes(
    bool selectAll,
    void Function(void Function()) setStateDialog,
  ) {
    setStateDialog(() {
      isAllSelected = selectAll;
      selectedTypes = selectAll ? List.from(aidTypes) : [];
    });
  }

  void toggleType(String type, void Function(void Function()) setStateDialog) {
    setStateDialog(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
      isAllSelected = selectedTypes.length == aidTypes.length;
    });
  }

  void showFilterPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        '종류',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ...['전체', ...aidTypes].map((type) {
                          final isSelected =
                              type == '전체'
                                  ? isAllSelected
                                  : selectedTypes.contains(type);
                          return GestureDetector(
                            onTap:
                                () =>
                                    type == '전체'
                                        ? toggleAllTypes(
                                          !isAllSelected,
                                          setStateDialog,
                                        )
                                        : toggleType(type, setStateDialog),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? kPrimaryColor : Colors.white,
                                border: Border.all(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : kPrimaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        '기간',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.center,
                      children:
                          ['전체', '모집중'].map((period) {
                            final isSelected = selectedPeriod == period;
                            return GestureDetector(
                              onTap: () {
                                setStateDialog(() => selectedPeriod = period);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? kPrimaryColor : Colors.white,
                                  border: Border.all(color: kPrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : kPrimaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              setStateDialog(() {
                                selectedTypes = List.from(aidTypes);
                                isAllSelected = true;
                                selectedPeriod = '전체';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: kPrimaryColor),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: Text(
                              '초기화',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              handleSearch();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: const Text(
                              '적용',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showScholarshipDetail(BuildContext context, Map<String, dynamic> item) {
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
                    item['productName'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['organization'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    '${item['start']} ~ ${item['end']}',
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    (item['type'] as List<String>).map((t) => '#$t').join(' '),
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 32),
                  const SizedBox(height: 20),

                  // 아래는 예쁜 목업 형태로 간단 출력
                  const Text(
                    '상세 정보',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('기관유형', '지자체(출자출연기관)'),
                      _buildDetailRow('장학금유형', '장학금'),
                      _buildDetailRow('대학 유형', '4년제(5~6년제포함)'),
                      _buildDetailRow('대상 학기', '대학2~8학기 이상'),
                      _buildDetailRow(
                        '지원 계열',
                        '공학, 교육, 사회, 예체능, 의약, 인문, 자연, 제한없음',
                      ),
                      _buildDetailRow('학업 요건', '직전학기 12학점 이상 + 평균 2.75 이상'),
                      _buildDetailRow('소득 요건', '중위소득 150% 이하'),
                      _buildDetailRow('지원 금액', '1인당 100만원 (생활비 지원 포함)'),
                      _buildDetailRow('특별 요건', '광주광역시 남구 주민등록 1년 이상 + 조건 충족'),
                      _buildDetailRow('선발 인원', '11명'),
                      _buildDetailRow('심사 방법', '서류심사 + 심사위원회 의결'),
                      _buildDetailRow('필요 서류', '신청서, 주민등록등본 등 10종'),
                      _buildDetailRow(
                        '지원 사이트',
                        'https://itle.or.kr/user/main.do',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () {
                    setState(() => isSearchMode = true);
                  },
                  child: Text(
                    AppStrings.scholarshipSearchTab,
                    style: TextStyle(
                      color: isSearchMode ? kPrimaryColor : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    setState(() => isSearchMode = false);
                  },
                  child: Text(
                    AppStrings.scholarshipRecommendTab,
                    style: TextStyle(
                      color: !isSearchMode ? kPrimaryColor : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 22),
                children: [
                  TextSpan(
                    text: '장학금 ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: isSearchMode ? '검색하기' : '추천받기',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),
            if (isSearchMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      controller: keywordController,
                      decoration: InputDecoration(
                        hintText: AppStrings.keywordHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: kPrimaryColor),
                          onPressed: handleSearch,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            if (isSearchMode)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: showFilterPopup,
                  icon: Icon(Icons.tune, color: kPrimaryColor, size: 18),
                  label: Text(
                    '검색 필터',
                    style: TextStyle(color: kPrimaryColor, fontSize: 13),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            Expanded(
              child:
                  isSearchMode
                      ? ListView.builder(
                        itemCount: filteredScholarships.length,
                        itemBuilder: (context, index) {
                          final item = filteredScholarships[index];
                          return GestureDetector(
                            onTap: () => showScholarshipDetail(context, item),
                            child: Container(
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
                                  const SizedBox(height: 4),
                                  Text(
                                    item['productName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['organization'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (item['type'] as List<String>)
                                            .map((t) => '#$t')
                                            .join(' '),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        '${item['start']} ~ ${item['end']}',
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
                          );
                        },
                      )
                      : Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 추천 로직 구현
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '장학금 추천받기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
