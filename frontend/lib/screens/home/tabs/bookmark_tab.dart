/// =============================================================
/// File : bookmark_tab.dart
/// Desc : 찜한 장학금 + 캘린더
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-05-11
/// =============================================================

import 'package:flutter/material.dart';
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

  final List<Map<String, String>> bookmarkedScholarships = [
    {
      'organization': '서울장학재단',
      'productName': '서울 미래인재 장학금',
      'type': '성적우수',
      'start': '2025.05.01',
      'end': '2025.05.31',
    },
    {
      'organization': '경기도인재육성재단',
      'productName': '경기 희망장학금',
      'type': '소득구분',
      'start': '2025.04.20',
      'end': '2025.05.20',
    },
    {
      'organization': '한국장학재단',
      'productName': '국가우수장학금(이공계)',
      'type': '특기자',
      'start': '2025.03.01',
      'end': '2025.05.15',
    },
  ];

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

  Widget _buildBookmarkList() {
    return ListView.builder(
      itemCount: bookmarkedScholarships.length,
      itemBuilder: (context, index) {
        final item = bookmarkedScholarships[index];
        return Container(
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
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${item['type']}',
                    style: const TextStyle(fontSize: 13, color: kPrimaryColor),
                  ),
                  Text(
                    '${item['start']} ~ ${item['end']}',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    return StatefulBuilder(
      builder: (context, setState) {

        final Map<DateTime, List<Map<String, String>>> calendarEvents = {
          DateTime.utc(2025, 5, 20): [
            {
              'productName': '경기 희망장학금',
              'organization': '경기도인재육성재단',
              'type': '소득구분',
              'start': '2025.04.20',
              'end': '2025.05.20',
            },
          ],
        };

        List<Map<String, String>> getEventsForDay(DateTime day) {
          return calendarEvents[DateTime.utc(day.year, day.month, day.day)] ??
              [];
        }

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
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate:
                    (day) =>
                        _selectedDay != null && isSameDay(day, _selectedDay),
                eventLoader: getEventsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
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
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 6,
                          height: 6,
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
            if (_selectedDay != null &&
                getEventsForDay(_selectedDay!).isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: getEventsForDay(_selectedDay!).length,
                  itemBuilder: (context, index) {
                    final item = getEventsForDay(_selectedDay!)[index];
                    return Container(
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
                            item['organization'] ?? '',
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
                                '#${item['type']}',
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
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
