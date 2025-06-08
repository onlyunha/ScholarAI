/// =============================================================
/// File : auth_provider.dart
/// Desc : 인증 관련 토큰
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-05-30
/// Updt : 2025-06-03
/// =============================================================

library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _memberId;
  String? _email;
  String? _name;
  String? _profileId;

  String? get token => _token;
  String? get memberId => _memberId;
  String? get email => _email;
  String? get name => _name;
  String? get profileId => _profileId;

  /// SharedPreferences에서 토큰과 멤버ID 로드
  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawToken = prefs.getString('auth_token');
    _token = rawToken != null ? rawToken.replaceAll('Bearer ', '') : null;
    _memberId = prefs.getString('auth_memberId');
    _email = prefs.getString('auth_email');
    _name = prefs.getString('auth_name');
    _profileId = prefs.getString('profileId');
    notifyListeners();
  }

  /// 로그인 시 토큰과 멤버ID 저장
  Future<void> saveAuthData(
    String token,
    String memberId,
    String email,
    String name,
    String profileId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final pureToken = token.replaceAll('Bearer ', '');
    await prefs.setString('auth_token', pureToken);
    await prefs.setString('auth_memberId', memberId);
    await prefs.setString('auth_email', email);
    await prefs.setString('auth_name', name);
    await prefs.setString('profileId', profileId);
    _token = token;
    _memberId = memberId;
    _email = email;
    _name = name;
    _profileId = profileId;
    notifyListeners();
  }

  /// 로그아웃 시 모든 인증 정보 초기화
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_memberId');
    await prefs.remove('auth_email');
    await prefs.remove('auth_name');
    await prefs.remove('profileId');
    _token = null;
    _memberId = null;
    _email = null;
    _name = null;
    _profileId = null;
    notifyListeners();
  }

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void setMemberId(String? id) {
    _memberId = id;
    notifyListeners();
  }

  void setName(String name) async {
    _name = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_name', name);
    debugPrint('🧠 저장된 이름: $name');
    notifyListeners();
  }
}
