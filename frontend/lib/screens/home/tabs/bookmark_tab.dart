/// =============================================================
/// File : bookmark_tab.dart
/// Desc : 찜한 장학금 + 캘린더
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-06-01
/// =============================================================
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/providers/bookmarked_provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:scholarai/widgets/scholarship_card.dart';
import 'package:scholarai/widgets/scholarship_detail_sheet.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../constants/app_colors.dart';

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({super.key});

  @override
  State<BookmarkTab> createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> {
  bool isBookmarkMode = true;
  String? memberId;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

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

  @override
  void initState() {
    super.initState();
    selectedDay = focusedDay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    memberId ??= context.read<AuthProvider>().memberId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 9),
            // 상단 탭 전환 (장학금 탭과 동일한 스타일)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => setState(() => isBookmarkMode = true),
                  child: Text(
                    '리스트',
                    style: TextStyle(
                      color: isBookmarkMode ? kPrimaryColor : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () => setState(() => isBookmarkMode = false),
                  child: Text(
                    '캘린더',
                    style: TextStyle(
                      color: !isBookmarkMode ? kPrimaryColor : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 22),
                children: [
                  TextSpan(
                    text: '나의 장학금 ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: isBookmarkMode ? '리스트' : '캘린더',
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
            Expanded(
              child: isBookmarkMode ? _buildBookmarkList() : _buildCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  DateTime normalizeDate(String dateStr) {
    if (dateStr.contains('.')) {
      final parts = dateStr.split('.');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } else if (dateStr.contains('-')) {
      return DateTime.parse(dateStr);
    } else {
      throw FormatException("Unknown date format: $dateStr");
    }
  }

  Map<DateTime, List<Map<String, dynamic>>> getCalendarEvents(
    List<Map<String, dynamic>> data,
  ) {
    final Map<DateTime, List<Map<String, dynamic>>> events = {};
    for (var item in data) {
      final end = item['end'] ?? item['applicationEndDate'];

      if (end != null && end is String) {
        try {
          final date = normalizeDate(end);
          print('✅ Parsed date: $date');
          if (!events.containsKey(date)) {
            events[date] = [];
          }
          events[date]!.add(item);
        } catch (e) {
          print('❌ Failed to parse date: $end');
        }
      }
    }

    return events;
  }

  Widget _buildBookmarkList() {
    final bookmarkedProvider = context.watch<BookmarkedProvider>();
    final bookmarkedData = bookmarkedProvider.bookmarkedData;

    if (bookmarkedData.isEmpty) {
      return const Center(
        child: Text(
          '찜한 장학금이 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: bookmarkedData.length,
      itemBuilder: (context, index) {
        final item = bookmarkedData[index];

        final sid = item['scholarshipId'];
        if (sid == null) return const SizedBox.shrink();
        final int id = sid is int ? sid : int.tryParse(sid.toString()) ?? -1;

        return ScholarshipCard(
          productName: item['productName'],
          organization: item['organizationName'],
          types: [
            '${item['type'] ?? convertToKorean(item['financialAidType'] ?? 'OTHER')}',
          ],
          start: item['start'] ?? item['applicationStartDate'] ?? '',
          end: item['end'] ?? item['applicationEndDate'] ?? '',

          isBookmarked: bookmarkedProvider.isBookmarked(item['scholarshipId']),
          onBookmarkToggle: () {
            if (memberId != null) {
              print('🧪 memberId: $memberId'); // 디버깅
              bookmarkedProvider.toggleBookmark(
                memberId!,
                item['scholarshipId'],
              );
            }
          },
          onTap:
              () => ScholarshipDetailSheet.show(context, item['scholarshipId']),
        );
      },
    );
  }

  Widget _buildCalendar() {
    final bookmarkedProvider = context.watch<BookmarkedProvider>();
    final bookmarkedData = bookmarkedProvider.bookmarkedData;
    final memberId = context.read<AuthProvider>().memberId;

    final events = getCalendarEvents(bookmarkedData);

    List<Map<String, dynamic>> getEventsForDay(DateTime day) {
      final key = DateTime(day.year, day.month, day.day); // 🔥 UTC로 통일
      return events[key] ?? [];
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TableCalendar(
                locale: 'ko_KR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2040, 12, 31),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                eventLoader: (day) {
                  final key = DateTime(day.year, day.month, day.day); // 시간 제거
                  return getEventsForDay(key);
                },
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },

                onHeaderTapped: (_) async {
                  int tempYear = focusedDay.year;
                  int tempMonth = focusedDay.month;

                  await showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    isScrollControlled: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                const Text(
                                  '날짜 선택',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // 연도 선택
                                      SizedBox(
                                        width: 120,
                                        child: CupertinoPicker(
                                          scrollController:
                                              FixedExtentScrollController(
                                                initialItem: (tempYear - 2020)
                                                    .clamp(0, 19),
                                              ),
                                          itemExtent: 32.0,
                                          onSelectedItemChanged: (index) {
                                            setModalState(() {
                                              tempYear = 2020 + index;
                                            });
                                          },
                                          children: List.generate(20, (index) {
                                            return Center(
                                              child: Text(
                                                '${2020 + index}년',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // 월 선택
                                      SizedBox(
                                        width: 100,
                                        child: CupertinoPicker(
                                          scrollController:
                                              FixedExtentScrollController(
                                                initialItem: (tempMonth - 1)
                                                    .clamp(0, 11),
                                              ),
                                          itemExtent: 32.0,
                                          onSelectedItemChanged: (index) {
                                            setModalState(() {
                                              tempMonth = index + 1;
                                            });
                                          },
                                          children: List.generate(12, (index) {
                                            return Center(
                                              child: Text(
                                                '${index + 1}월',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      minimumSize: const Size.fromHeight(48),
                                    ),
                                    onPressed: () {
                                      // 방어 코드: 날짜 유효성 검사
                                      if (tempYear >= 2020 &&
                                          tempYear <= 2039 &&
                                          tempMonth >= 1 &&
                                          tempMonth <= 12) {
                                        final pickedDate = DateTime(
                                          tempYear,
                                          tempMonth,
                                          1,
                                        );
                                        setState(() {
                                          focusedDay = pickedDate;
                                          selectedDay = pickedDate;
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },

                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(fontSize: 12),
                  weekendTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  outsideTextStyle: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter:
                      (date, locale) => DateFormat.yMMMM('ko_KR').format(date),
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );
                    final dayEvents = getEventsForDay(normalizedDay);

                    if (dayEvents.isNotEmpty) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                          ),
                        ),
                      );
                    }

                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedDay != null && getEventsForDay(selectedDay!).isNotEmpty)
              ...getEventsForDay(selectedDay!).map(
                (item) => ScholarshipCard(
                  productName: item['productName'],
                  organization:
                      item['organization'] ?? item['organizationName'] ?? '',
                  types: [
                    item['type'] ??
                        convertToKorean(item['financialAidType'] ?? 'OTHER'),
                  ],
                  start: item['start'] ?? item['applicationStartDate'] ?? '',
                  end: item['end'] ?? item['applicationEndDate'] ?? '',
                  isBookmarked: bookmarkedProvider.isBookmarked(
                    item['scholarshipId'],
                  ),
                  onBookmarkToggle: () {
                    if (memberId != null) {
                      bookmarkedProvider.toggleBookmark(
                        memberId!,
                        item['scholarshipId'],
                      );
                    }
                  },
                  onTap:
                      () => ScholarshipDetailSheet.show(
                        context,
                        item['scholarshipId'],
                      ),
                ),
              ),
          ],
        );
      },
    );
  }
}
