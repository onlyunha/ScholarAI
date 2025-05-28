/// =============================================================
/// File : bookmark_tab.dart
/// Desc : 찜한 장학금 + 캘린더
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-05-11
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
    memberId ??=
        Provider.of<UserProfileProvider>(context, listen: false).getUserId();
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
    final parts = dateStr.split('.');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  Map<DateTime, List<Map<String, dynamic>>> getCalendarEvents(
    List<Map<String, dynamic>> data,
  ) {
    final Map<DateTime, List<Map<String, dynamic>>> events = {};
    for (var item in data) {
      final end = item['end'];
      if (end != null && end is String && end.contains('.')) {
        final date = normalizeDate(end);
        if (!events.containsKey(date)) {
          events[date] = [];
        }
        events[date]!.add(item);
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
            '#${item['type'] ?? convertToKorean(item['financialAidType'] ?? 'OTHER')}',
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
    final memberId = context.read<UserProfileProvider>().getUserId();

    final events = getCalendarEvents(bookmarkedData);

    List<Map<String, dynamic>> getEventsForDay(DateTime day) {
      return events[DateTime.utc(day.year, day.month, day.day)] ?? [];
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
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                eventLoader: getEventsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDay = selectedDay;
                    focusedDay = focusedDay;
                  });
                },
                onHeaderTapped: (_) async {
                  final selectedDate = await showMonthYearPicker(
                    context: context,
                    initialDate: focusedDay,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: const Locale('ko'),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          highlightColor: kPrimaryColor,
                          colorScheme: ColorScheme.light(
                            primary: kPrimaryColor.withOpacity(
                              0.8,
                            ), // 헤더, 선택 포커스 컬러
                            onPrimary: Colors.white, // 헤더 텍스트
                            surface: Colors.white, // 배경색
                            onSurface: Colors.black87, // 일반 텍스트
                            secondary: kPrimaryColor.withOpacity(0.8), // 강조 색
                          ),

                          textTheme: const TextTheme(
                            titleLarge: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            titleMedium: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                              textStyle: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          dialogTheme: DialogTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: TextScaler.linear(0.95)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: child!,
                          ),
                        ),
                      );
                    },
                  );

                  if (selectedDate != null) {
                    setState(() {
                      focusedDay = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        1,
                      );
                      selectedDay = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        1,
                      );
                    });
                  }
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
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
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
                (item) => GestureDetector(
                  onTap:
                      () => ScholarshipDetailSheet.show(
                        context,
                        item['scholarshipId'],
                      ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['productName'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['organization'] ??
                              item['organizationName'] ??
                              '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${item['type'] ?? '기타'}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: kPrimaryColor,
                              ),
                            ),
                            Text(
                              '${item['start'] ?? item['applicationStartDate'] ?? ''} ~ ${item['end'] ?? item['applicationEndDate'] ?? ''}',
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
                ),
              ),
          ],
        );
      },
    );
  }
}
