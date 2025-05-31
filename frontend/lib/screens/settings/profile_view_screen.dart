/// =============================================================
/// File : profile_view_screen.dart
/// Desc : 프로필 보기 화면
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-06-01
/// =============================================================
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/constants/config.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) _loadProfile();
    });
  }

  void _loadProfile() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final profileProvider = context.read<UserProfileProvider>();
      debugPrint('🟡 현재 Provider에 저장된 profileId: ${profileProvider.profileId}');
      debugPrint(
        '🟡 현재 isProfileRegistered: ${profileProvider.isProfileRegistered}',
      );

      final profileId = profileProvider.profileId;
      final token = authProvider.token;
      debugPrint('🔍 profileId: $profileId');

      final response = await http.get(
        Uri.parse('$baseUrl/api/profile/$profileId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = data['data'];
        profileProvider.updateProfile(
          birthYear: profile['birthYear'],
          gender: profile['gender'],
          region: profile['residence'],
          university: profile['university'],
          universityType: profile['universityType'],
          academicStatus: profile['academicStatus'],
          semester: profile['semester'],
          majorField: profile['majorField'],
          major: profile['major'],
          gpa: profile['gpa']?.toDouble(),
          incomeLevel: profile['incomeLevel'],
          secondLowestIncome: profile['secondLowestIncome'],
          basicLivingRecipient: profile['basicLivingRecipient'],
          disabled: profile['disabled'],
          multiChild: profile['multiChild'],
        );
        profileProvider.setProfileRegistered(true);
        if (mounted) setState(() {});
      } else if (response.statusCode == 403 || response.statusCode == 404) {
        debugPrint('🟡 아직 프로필이 등록되지 않았습니다.');
        if (profileId == null) {
          debugPrint('🟡 아직 프로필이 등록되지 않았습니다.');
          profileProvider.clearProfile();
        } else {
          debugPrint('🟡 프로필 ID는 있는데 서버가 아직 데이터를 못 줌 (지연)');
        }
      } else {
        debugPrint('⚠️ 프로필 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ 예외 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<UserProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // 자동 뒤로가기 비활성화
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.main); // 또는 원하는 기본 경로로
            }
          },
        ),
        title: null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 25),
            CircleAvatar(
              radius: 45,
              backgroundColor: kPrimaryColor.withOpacity(0.1),
              child: const Icon(Icons.person, color: kPrimaryColor, size: 40),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  auth.name ?? '이름 없음',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    final profileProvider = context.read<UserProfileProvider>();
                    final nameController = TextEditingController(
                      text: auth.name ?? '',
                    );

                    final newName = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('이름 수정'),
                          content: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: '새 이름 입력',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final enteredName = nameController.text.trim();
                                if (enteredName.isNotEmpty) {
                                  final response = await http.post(
                                    Uri.parse('$baseUrl/api/auth/name'),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'Authorization': 'Bearer ${auth.token}',
                                    },
                                    body: jsonEncode({
                                      'name': enteredName,
                                      'email': auth.email,
                                    }),
                                  );

                                  if (response.statusCode == 200) {
                                    auth.setName(enteredName);
                                    Navigator.pop(context, enteredName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('이름 수정 실패')),
                                    );
                                  }
                                }
                              },
                              child: const Text('저장'),
                            ),
                          ],
                        );
                      },
                    );

                    if (newName != null && newName.isNotEmpty) {
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  profile.isProfileRegistered
                      ? _buildFilledProfileUI(profile)
                      : _buildEmptyProfileUI(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProfileUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: kPrimaryColor),
              const SizedBox(height: 20),
              const Text(
                '아직 프로필이 없어요',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '맞춤형 서비스를 위해\n지금 프로필을 등록해보세요!',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.profileCreate),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.edit_note, size: 22),
                  label: const Text(
                    '프로필 등록하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilledProfileUI(UserProfileProvider profile) {
    return ListView(
      padding: const EdgeInsets.only(top: 20, bottom: 80),
      children: [
        _infoTitle('거주 지역'),
        _infoText(profile.region ?? '-'),
        _infoTitle('학교'),
        _infoText(
          '${profile.university ?? '-'} (${profile.universityType ?? '-'})',
        ),
        _infoTitle('학과'),
        _infoText(
          '${profile.majorField ?? '-'} · ${profile.major ?? '-'} · ${profile.semester ?? '-'}학기',
        ),
        _infoTitle('성적 및 소득 분위'),
        _infoText(
          'GPA ${profile.gpa?.toStringAsFixed(2) ?? '-'} · ${profile.incomeLevel ?? '-'} 분위',
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _boolChip('장애 여부', profile.disabled),
                  const SizedBox(width: 12),
                  _boolChip('다자녀 가구', profile.multiChild),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _boolChip('기초생활 수급자', profile.basicLivingRecipient),
                  const SizedBox(width: 12),
                  _boolChip('차상위 계층', profile.secondLowestIncome),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.profileEdit),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              '프로필 수정하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _infoTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _infoText(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  Widget _boolChip(String label, bool? value) {
    return Chip(
      avatar: Icon(
        value == true ? Icons.check_circle : Icons.cancel,
        color: value == true ? Colors.green : Colors.grey,
        size: 20,
      ),
      label: Text(label),
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
    );
  }
}
