/// =============================================================
/// File : user_bookmarked_provider.dart
/// Desc : 유저 정보 관리
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-05-20
/// Updt : 2025-05-20
/// =============================================================


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/config.dart';

class BookmarkedProvider extends ChangeNotifier {
  final Set<int> _bookmarkedIds = {};
  final List<Map<String, dynamic>> _bookmarkedData = [];

  Set<int> get bookmarkedIds => _bookmarkedIds;
  List<Map<String, dynamic>> get bookmarkedData => _bookmarkedData;

  /// 서버에서 찜 목록 불러오기
  Future<void> loadBookmarks(String memberId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/likes/$memberId'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];

        _bookmarkedIds.clear();
        _bookmarkedData.clear();

        for (var item in data) {
          _bookmarkedIds.add(item['scholarshipId']);
          _bookmarkedData.add(item as Map<String, dynamic>);
        }

        notifyListeners();
      } else {
        debugPrint('찜 목록 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('찜 목록 로딩 에러: $e');
    }
  }

  /// 찜/찜 취소 토글
  Future<void> toggleBookmark(String memberId, int scholarshipId) async {
    final isLiked = _bookmarkedIds.contains(scholarshipId);

    final url = Uri.parse('$baseUrl/api/likes?memberId=$memberId&scholarshipId=$scholarshipId');
    final response = isLiked
        ? await http.delete(url)
        : await http.post(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (isLiked) {
        _bookmarkedIds.remove(scholarshipId);
        _bookmarkedData.removeWhere((item) => item['scholarshipId'] == scholarshipId);
      } else {
        _bookmarkedIds.add(scholarshipId);
        final detail = await fetchScholarshipDetail(scholarshipId);
        _bookmarkedData.add(detail);
      }
      notifyListeners();
    } else {
      debugPrint('찜 요청 실패: ${response.statusCode}');
    }
  }

  /// 개별 장학금 상세 불러오기 (찜 직후 데이터 확보용)
  Future<Map<String, dynamic>> fetchScholarshipDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/scholarships/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('상세 불러오기 실패: $e');
    }
    return {};
  }

  /// 특정 ID가 찜됐는지 확인
  bool isBookmarked(int id) => _bookmarkedIds.contains(id);
}