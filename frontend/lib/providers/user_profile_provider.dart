/// =============================================================
/// File : user_profile_provider.dart
/// Desc : 유저 정보 관리
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-04-23
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

  void updateProfile({
    String? name,
    int? birthYear,
    String? gender,
    String? region,
    String? university,
    String? universityType,
    String? academicStatus,
  }) {
    this.name = name;
    this.birthYear = birthYear;
    this.gender = gender;
    this.region = region;
    this.university = university;
    this.universityType = universityType;
    this.academicStatus = academicStatus;
    notifyListeners();
  }
}