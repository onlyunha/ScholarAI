/// =============================================================
/// File : user_profile_provider.dart
/// Desc : 유저 정보 관리
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-06-03
/// =============================================================
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  bool _isProfileRegistered = false;
  bool get isProfileRegistered => _isProfileRegistered;

  void setProfileRegistered(bool value) {
    _isProfileRegistered = value;
    notifyListeners();
  }

  int? _profileId;
  int? get profileId => _profileId;

  void setProfileId(int id) async {
    _profileId = id;
    _isProfileRegistered = (id != null);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profile_id', id);
    debugPrint('✅ SharedPreferences에 profileId 저장됨: $id');
  }

  int? birthYear;
  String? gender;
  String? region;
  String? university;
  String? universityType;
  String? academicStatus;
  String? major;
  String? majorField;
  double? gpa;
  int? semester;
  int? incomeLevel;
  bool? disabled;
  bool? multiChild;
  bool? basicLivingRecipient;
  bool? secondLowestIncome;

  void updateProfile({
    int? birthYear,
    String? gender,
    String? region,
    String? university,
    String? universityType,
    String? academicStatus,
    String? major,
    String? majorField,
    double? gpa,
    int? semester,
    int? incomeLevel,
    bool? disabled,
    bool? multiChild,
    bool? basicLivingRecipient,
    bool? secondLowestIncome,
  }) {
    this.birthYear = birthYear;
    this.gender = gender;
    this.region = region;
    this.university = university;
    this.universityType = universityType;
    this.academicStatus = academicStatus;
    this.major = major;
    this.majorField = majorField;
    this.gpa = gpa;
    this.semester = semester;
    this.incomeLevel = incomeLevel;
    this.disabled = disabled;
    this.multiChild = multiChild;
    this.basicLivingRecipient = basicLivingRecipient;
    this.secondLowestIncome = secondLowestIncome;
    _isProfileRegistered = true;
    notifyListeners();
  }

  void clearProfile() {
    birthYear = null;
    gender = null;
    region = null;
    university = null;
    universityType = null;
    academicStatus = null;
    major = null;
    majorField = null;
    gpa = null;
    semester = null;
    incomeLevel = null;
    disabled = null;
    multiChild = null;
    basicLivingRecipient = null;
    secondLowestIncome = null;
    _isProfileRegistered = false;
    notifyListeners();
  }

  Future<void> fetchProfileIdAndLoad(String memberId, String token) async {
    try {
      // 1단계: 프로필 ID 조회
      debugPrint('✅ 최종 Authorization 헤더: Bearer $token');
      final profileIdResponse = await http.get(
        Uri.parse('$baseUrl/api/profile?memberId=$memberId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (profileIdResponse.statusCode == 200) {
        final profileIdData = jsonDecode(profileIdResponse.body);
        debugPrint('📦 profileId 응답 전체: ${profileIdResponse.body}'); // ✅ 추가
        final profileId = profileIdData['data'];
        debugPrint('✅ 로그인 직후 받은 profileId: $profileId');
        setProfileId(profileId);

        // 2단계: 프로필 상세 조회
        debugPrint('✅ 최종 Authorization 헤더: $token');
        final profileResponse = await http.get(
          Uri.parse('$baseUrl/api/profile/$profileId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': ' $token',
          },
        );

        if (profileResponse.statusCode == 200) {
          final profileData = jsonDecode(profileResponse.body)['data'];
          setProfileId(profileData['profileId']);

          updateProfile(
            birthYear: profileData['birthYear'],
            gender: profileData['gender'],
            region: profileData['residence'],
            university: profileData['university'],
            universityType: profileData['universityType'],
            academicStatus: profileData['academicStatus'],
            gpa:
                profileData['gpa'] != null
                    ? (profileData['gpa'] as num).toDouble()
                    : null,
            major: profileData['major'],
            majorField: profileData['majorField'],
            semester: profileData['semester'],
            incomeLevel: profileData['incomeLevel'],
            disabled: profileData['disabled'],
            multiChild: profileData['multiChild'],
            basicLivingRecipient: profileData['basicLivingRecipient'],
            secondLowestIncome: profileData['secondLowestIncome'],
          );
          setProfileRegistered(true);
          debugPrint('✅ 프로필 정보 로드 완료');
        } else {
          debugPrint('⚠️ 프로필 상세 조회 실패: ${profileResponse.statusCode}');
        }
      } else {
        debugPrint('⚠️ 프로필 ID 조회 실패: ${profileIdResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ fetchProfileIdAndLoad 예외 발생: $e');
    }
  }

  Future<void> loadProfileIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedProfileId = prefs.getInt('profile_id');
    final storedMemberId = prefs.getString('auth_memberId');
    final storedToken = prefs.getString('auth_token');

    if (storedProfileId != null &&
        storedMemberId != null &&
        storedToken != null) {
      _profileId = storedProfileId;
      _isProfileRegistered = true;
      notifyListeners();
      debugPrint('✅ SharedPreferences에서 profileId 로드됨: $storedProfileId');

      await fetchProfileIdAndLoad(storedMemberId, storedToken);
    } else {
      debugPrint('ℹ️ 저장된 profileId 또는 memberId/token 없음');
    }
  }

  void resetOnLogout() {
    _profileId = null;
    _isProfileRegistered = false;
    notifyListeners();
  }
}
