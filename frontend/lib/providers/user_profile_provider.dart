/// =============================================================
/// File : user_profile_provider.dart
/// Desc : 유저 정보 관리
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-05-20
/// =============================================================

import 'package:flutter/foundation.dart';

class UserProfileProvider extends ChangeNotifier {
  String? name;
  int? birthYear;
  String? gender;
  String? region;
  String? university;
  String? universityType;
  String? academicStatus;
  String? memberId;

  // Getter들 추가 (optional)
  String? get getName => name;
  int? get getBirthYear => birthYear;
  String? get getGender => gender;
  String? get getRegion => region;
  String? get getUniversity => university;
  String? get getUniversityType => universityType;
  String? get getAcademicStatus => academicStatus;
  String? get getMemberId => memberId; 

  String? getUserId() {
    return memberId;
  }


  // 데이터 업데이트
  void updateProfile({
    String? name,
    int? birthYear,
    String? gender,
    String? region,
    String? university,
    String? universityType,
    String? academicStatus,
    String? memberId,
  }) {
    this.name = name;
    this.birthYear = birthYear;
    this.gender = gender;
    this.region = region;
    this.university = university;
    this.universityType = universityType;
    this.academicStatus = academicStatus;
    this.memberId = memberId;
    notifyListeners();  // 변경 후 listeners에게 알림
  }

  // 프로필 초기화 (로그아웃시 호출 가능)
  void clearProfile() {
    name = null;
    birthYear = null;
    gender = null;
    region = null;
    university = null;
    universityType = null;
    academicStatus = null;
    memberId = null;
    notifyListeners();  // 모든 정보를 초기화한 후 listeners에게 알림
  }
}

