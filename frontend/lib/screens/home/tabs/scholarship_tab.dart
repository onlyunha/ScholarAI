/// =============================================================
/// File : schoarlship_tab.dart
/// Desc : 장학금 검색 + 추천
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-06-01
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_strings.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/providers/bookmarked_provider.dart'
    show BookmarkedProvider;
import 'package:scholarai/providers/user_profile_provider.dart';
import 'package:scholarai/widgets/scholarship_card.dart';
import '../../../widgets/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scholarai/constants/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scholarai/widgets/scholarship_detail_sheet.dart';

class ScholarshipTab extends StatefulWidget {
  const ScholarshipTab({super.key});

  @override
  State<ScholarshipTab> createState() => _ScholarshipTabState();
}

class _ScholarshipTabState extends State<ScholarshipTab> {
  final TextEditingController keywordController = TextEditingController();
  bool isSearchMode = true;
  bool isRecommendationStarted = true; // default false

  final List<String> aidTypes = ['성적우수', '소득구분', '지역연고', '장애인', '특기자', '기타'];
  late List<String> selectedTypes;
  String selectedPeriod = '전체';
  bool isAllSelected = true;

  List<Map<String, dynamic>> filteredScholarships = [];
  List<Map<String, dynamic>> recommendedScholarships = [];

  int currentPage = 0;
  int totalPages = 1;
  String selectedSort = 'latest';

  @override
  void initState() {
    super.initState();
    selectedTypes = List.from(aidTypes);
    selectedPeriod = '모집중';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final memberId = context.read<AuthProvider>().memberId;
      if (memberId != null) {
        await context.read<BookmarkedProvider>().loadBookmarks(memberId);
      }
      handleSearch(); // 북마크 로딩 완료 후 장학금 검색
    });
  }

  Future<void> handleSearch({int page = 0}) async {
    final keyword = keywordController.text.trim();

    // 기본 쿼리
    final queryParams = <String, String>{
      if (keyword.isNotEmpty) 'keyword': keyword,
      if (selectedPeriod == '모집중') 'onlyRecruiting': 'true',
      if (selectedPeriod == '모집예정') 'onlyUpcoming': 'true',

      'page': page.toString(),
      'size': '20',
      'sort':
          selectedSort == 'latest'
              ? 'applicationStartDate,asc'
              : 'applicationEndDate,asc',
    };

    // 복수 필터를 따로 문자열로 조합
    final financialAidParams = selectedTypes
        .where((t) => !isAllSelected) // 전체 선택이면 생략
        .map((t) => 'financialAidType=${_convertToCode(t)}')
        .join('&');

    // 최종 URL 직접 조립
    final base = Uri.parse(baseUrl);
    final queryString = Uri(queryParameters: queryParams).query;
    final url =
        '${base.origin}/api/scholarships/search?$queryString&$financialAidParams';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> content = json['content'];
        setState(() {
          filteredScholarships = content.cast<Map<String, dynamic>>();
          totalPages = json['totalPages'] ?? 1;
          currentPage = page;
        });
      } else {
        debugPrint('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('요청 실패: $e');
    }
  }

  String _convertToCode(String type) {
    switch (type) {
      case '성적우수':
        return 'MERIT';
      case '소득구분':
        return 'INCOME';
      case '지역연고':
        return 'REGIONAL';
      case '장애인':
        return 'DISABILITY';
      case '특기자':
        return 'SPECIAL';
      case '기타':
        return 'OTHER';
      default:
        return 'NONE';
    }
  }

  String convertToKorean(String code) {
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
      case 'NONE':
        return '해당없음';
      default:
        return code;
    }
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
                        }),
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
                          ['전체', '모집중', '모집예정'].map((period) {
                            final isSelected =
                                selectedPeriod == period ||
                                (selectedPeriod == '전체' &&
                                    (period == '모집중' || period == '모집예정'));
                            return GestureDetector(
                              onTap: () {
                                setStateDialog(() {
                                  if (period == '전체') {
                                    selectedPeriod =
                                        selectedPeriod == '전체'
                                            ? '모집중'
                                            : '전체'; // 토글 기능
                                  } else {
                                    selectedPeriod = period;
                                  }
                                });
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
                              Navigator.pop(context);
                              handleSearch();
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
    final bookmarkedProvider = context.watch<BookmarkedProvider>();
    final memberId = context.read<AuthProvider>().memberId;
    final name = context.watch<AuthProvider>().name ?? '회원';
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
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            handleSearch();
                          },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔽 정렬 드롭다운 버튼
                  Visibility(
                    visible: false,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedSort = value;
                                handleSearch(); // 정렬 반영
                              });
                            }
                          },
                          icon: const SizedBox.shrink(), // 기본 아이콘 제거
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                          alignment:
                              AlignmentDirectional.centerStart, // 아래로만 펼침
                          selectedItemBuilder: (context) {
                            return ['latest', 'deadline'].map((value) {
                              final text = value == 'latest' ? '최신순' : '마감순';
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: kPrimaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(text),
                                ],
                              );
                            }).toList();
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'latest',
                              child: Text('최신순'),
                            ),
                            DropdownMenuItem(
                              value: 'deadline',
                              child: Text('마감순'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 🔧 검색 필터 버튼
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: showFilterPopup,
                      borderRadius: BorderRadius.circular(20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.tune,
                            color: kPrimaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '검색 필터',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            Expanded(
              child:
                  isSearchMode
                      ? (filteredScholarships.isEmpty
                          ? const Center(
                            child: Text(
                              '검색 결과가 없습니다.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: filteredScholarships.length,
                            itemBuilder: (context, index) {
                              final item = filteredScholarships[index];
                              return ScholarshipCard(
                                productName: item['productName'],
                                organization: item['organizationName'],
                                types: [
                                  convertToKorean(item['financialAidType']),
                                ],
                                start: item['applicationStartDate'],
                                end: item['applicationEndDate'],
                                onTap:
                                    () => ScholarshipDetailSheet.show(
                                      context,
                                      item['id'],
                                    ),
                                isBookmarked: context
                                    .watch<BookmarkedProvider>()
                                    .isBookmarked(item['id']),
                                onBookmarkToggle: () {
                                  if (memberId != null) {
                                    bookmarkedProvider.toggleBookmark(
                                      memberId,
                                      item['id'],
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('로그인이 필요합니다.'),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ))
                      : isRecommendationStarted
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.emoji_objects,
                            size: 48,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(height: 16),

                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Pretendard',
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                const TextSpan(
                                  text: '님을 위한\n',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                const TextSpan(
                                  text: '추천 장학금',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: '이에요!',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(thickness: 1, color: Colors.grey),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: recommendedScholarships.length,
                              itemBuilder: (context, index) {
                                final item = recommendedScholarships[index];
                                return ScholarshipCard(
                                  productName: item['productName'],
                                  organization: item['organizationName'],
                                  types: [
                                    convertToKorean(item['financialAidType']),
                                  ],
                                  start: item['applicationStartDate'],
                                  end: item['applicationEndDate'],
                                  isBookmarked: context
                                      .watch<BookmarkedProvider>()
                                      .isBookmarked(item['id']),
                                  onTap: () {
                                    ScholarshipDetailSheet.show(
                                      context,
                                      item['id'],
                                    );
                                  },
                                  onBookmarkToggle: () {
                                    final memberId =
                                        context.read<AuthProvider>().memberId;
                                    if (memberId != null) {
                                      context
                                          .read<BookmarkedProvider>()
                                          .toggleBookmark(memberId, item['id']);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('로그인이 필요합니다.'),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.search,
                            size: 48,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Pretendard',
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: '나에게 딱 맞는\n',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                TextSpan(
                                  text: '장학금',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 찾기!',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(thickness: 1, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text(
                            '입력된 프로필을 기반으로\nAI가 적합한 장학금을 추천해드려요!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                final profileProvider =
                                    context.read<UserProfileProvider>();
                                if (!profileProvider.isProfileRegistered) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text(
                                            '프로필 생성이 필요해요!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text('확인'),
                                            ),
                                          ],
                                        ),
                                  );
                                } else {
                                  await fetchRecommendations();
                                  setState(() {
                                    isRecommendationStarted = true;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                '시작하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
            ),

            if (isSearchMode)
              SizedBox(
                height: 48,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_double_arrow_left),
                          color: kPrimaryColor,
                          onPressed:
                              currentPage >= 10
                                  ? () => handleSearch(page: currentPage - 10)
                                  : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          color: kPrimaryColor,
                          onPressed:
                              currentPage > 0
                                  ? () => handleSearch(page: currentPage - 1)
                                  : null,
                        ),
                        ..._buildPageButtons(),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          color: kPrimaryColor,
                          onPressed:
                              currentPage < totalPages - 1
                                  ? () => handleSearch(page: currentPage + 1)
                                  : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_double_arrow_right),
                          color: kPrimaryColor,
                          onPressed:
                              currentPage + 10 < totalPages
                                  ? () => handleSearch(page: currentPage + 10)
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageButtons() {
    int start = (currentPage ~/ 10) * 10;
    int end = (start + 5).clamp(0, totalPages);

    return List.generate(end - start, (i) {
      final pageNum = start + i;
      final isCurrent = pageNum == currentPage;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: GestureDetector(
          onTap: () => handleSearch(page: pageNum),
          child: Text(
            '${pageNum + 1}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? kPrimaryColor : Colors.black,
            ),
          ),
        ),
      );
    });
  }

  Future<void> fetchRecommendations() async {
    final profileId = context.read<UserProfileProvider>().profileId;
    if (profileId == null) return;

    final url = '$baseUrl/api/recommend?profileId=$profileId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          recommendedScholarships = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint('❌ 추천 API 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ 추천 API 예외: $e');
    }
  }
}
