/// =============================================================
/// File : profile_edit_screen.dart
/// Desc : 프로필 수정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-06-03
/// =============================================================
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/config.dart';
import 'package:scholarai/providers/auth_provider.dart';
import 'package:scholarai/providers/user_profile_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController uniController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  int? selectedYear;
  String? selectedGender;
  String? selectedRegion;
  String? selectedUniversityType;
  String? selectedAcademicStatus;
  String? selectedUniversity;
  String? selectedMajorField;
  String? selectedMajor;
  int? selectedSemester;
  int? selectedIncomeLevel;
  double selectedGpa = 0.0;
  bool isDisabled = false;
  bool isMultiChild = false;
  bool isBasicLiving = false;
  bool isSecondLowest = false;
  String errorMessage = '';
  int? profileId;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    debugPrint('✅ _loadProfileData() 진입');
    try {
      final profileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final memberId = authProvider.memberId;
      final token = authProvider.token;
      final currentProfileId = profileProvider.profileId;

      debugPrint('🔍 provider.profileId: $currentProfileId');
      debugPrint(
        '🔍 provider.isProfileRegistered: ${profileProvider.isProfileRegistered}',
      );
      debugPrint('🔍 auth.token: $token');
      debugPrint('🔍 auth.memberId: $memberId');

      debugPrint('🟡 현재 Provider에 저장된 profileId: $currentProfileId');
      debugPrint(
        '🟡 현재 isProfileRegistered: ${profileProvider.isProfileRegistered}',
      );

      if (currentProfileId == null || token == null) {
        debugPrint('❌ profileId 또는 token이 null입니다');
        setState(() {
          errorMessage = '프로필 정보를 불러올 수 없습니다 (ID 또는 토큰 누락)';
        });
        return;
      }
  debugPrint('📤 GET /api/profile/$currentProfileId 호출 준비');
      final response = await http.get(
        Uri.parse('$baseUrl/api/profile/$currentProfileId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final profileData = jsonDecode(response.body)['data'];
        final int? loadedProfileId = profileData['profileId'];
        if (loadedProfileId != null) {
          profileProvider.setProfileId(loadedProfileId);
        } else {
          debugPrint('⚠️ profileId가 null이라 SharedPreferences에 저장하지 않음');
        }

        setState(() {
          selectedYear = profileData['birthYear'];
          selectedGender = profileData['gender'];
          selectedRegion = profileData['residence'];
          selectedUniversity = profileData['university'];
          selectedUniversityType = profileData['universityType'];
          selectedAcademicStatus = profileData['academicStatus'];
          selectedSemester =
              profileData['semester'] is int ? profileData['semester'] : null;
          selectedMajorField = profileData['majorField'];
          selectedMajor = profileData['major'];
          selectedGpa = profileData['gpa']?.toDouble() ?? 0.0;
          selectedIncomeLevel = profileData['incomeLevel'];
          isDisabled = profileData['disabled'] ?? false;
          isMultiChild = profileData['multiChild'] ?? false;
          isBasicLiving = profileData['basicLivingRecipient'] ?? false;
          isSecondLowest = profileData['secondLowestIncome'] ?? false;
          uniController.text = selectedUniversity ?? '';
          majorController.text = selectedMajor ?? '';

          profileProvider.setProfileRegistered(true);
        });
      } else {
        debugPrint('⚠️ 프로필 조회 실패: ${response.statusCode}');
        setState(() {
          errorMessage = '프로필 불러오기에 실패했습니다 (${response.statusCode})';
        });
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      setState(() {
        errorMessage = '네트워크 오류: 연결을 확인해주세요';
      });
    }
  }

  // 저장
  Future<void> _saveProfileData() async {
    print('🟡 [DEBUG] 저장 함수 호출됨');

    final profileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileId = profileProvider.profileId;
    final rawToken = authProvider.token;

    print('🟡 rawtoken: $rawToken');
    print('🟡 profileId: $profileId');

    if (profileId == null || rawToken == null) {
      print('❌ profileId 또는 token이 null입니다');
      setState(() {
        errorMessage = '프로필 정보가 없습니다';
      });
      return;
    }
    final token =
        rawToken.startsWith('Bearer ') ? rawToken : 'Bearer $rawToken';

    try {
      debugPrint(
        '📤 저장 요청 직전 체크박스 상태: '
        'isDisabled=$isDisabled, '
        'isMultiChild=$isMultiChild, '
        'isBasicLiving=$isBasicLiving, '
        'isSecondLowest=$isSecondLowest',
      );
      final Map<String, dynamic> body = {
        'birthYear': selectedYear,
        'gender': selectedGender,
        'residence': selectedRegion,
        'universityType': selectedUniversityType,
        'university': selectedUniversity,
        'academicStatus': selectedAcademicStatus,
        'semester': selectedSemester,
        'majorField': selectedMajorField,
        'major': selectedMajor,
        'gpa': selectedGpa,
        'incomeLevel': selectedIncomeLevel,
        'disabled': isDisabled,
        'multiChild': isMultiChild,
        'basicLivingRecipient': isBasicLiving,
        'secondLowestIncome': isSecondLowest,
      };

      final response = await http.patch(
        Uri.parse('$baseUrl/api/profile/$profileId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': rawToken,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        profileProvider.updateProfile(
          birthYear: selectedYear,
          gender: selectedGender,
          region: selectedRegion,
          university: selectedUniversity,
          universityType: selectedUniversityType,
          academicStatus: selectedAcademicStatus,
          majorField: selectedMajorField,
          major: selectedMajor,
          gpa: selectedGpa,
          semester: selectedSemester,
          incomeLevel: selectedIncomeLevel,
          disabled: isDisabled,
          multiChild: isMultiChild,
          basicLivingRecipient: isBasicLiving,
          secondLowestIncome: isSecondLowest,
        );
        context.pop();
      } else {
        print('⚠️ 응답 본문: ${response.body}');
        setState(() {
          errorMessage = '프로필 저장에 실패했습니다';
        });
      }
    } catch (e, stackTrace) {
      print('❌ 예외 발생: $e');
      print('📍 Stack Trace: $stackTrace');

      setState(() {
        errorMessage = '네트워크 오류: 연결을 확인해주세요';
      });
    }
  }

  final List<int> yearOptions = List.generate(
    60,
    (i) => DateTime.now().year - i,
  );
  final List<Map<String, String>> genderOptions = [
    {'value': 'MALE', 'label': '남자'},
    {'value': 'FEMALE', 'label': '여자'},
  ];

  final List<String> regionOptions = [
    '서울특별시',
    '부산광역시',
    '대구광역시',
    '인천광역시',
    '광주광역시',
    '대전광역시',
    '울산광역시',
    '세종특별자치시',
    '경기도',
    '강원도',
    '충청북도',
    '충청남도',
    '전라북도',
    '전라남도',
    '경상북도',
    '경상남도',
    '제주특별자치도',
  ];
  final List<String> universityTypes = ['4년제', '전문대', '기타'];
  final List<Map<String, String>> academicStatuses = [
    {'code': 'ENROLLED', 'label': '재학'},
    {'code': 'LEAVE_OF_ABSENCE', 'label': '휴학'},
    {'code': 'EXPECTED_GRADUATION', 'label': '졸업예정'},
    {'code': 'GRADUATED', 'label': '졸업'},
  ];
  final List<String> majorFields = [
    '공학계열',
    '자연계열',
    '인문계열',
    '사회계열',
    '예체능계열',
    '의약계열',
    '교육계열',
    '기타',
  ];
  final List<int> semesterOptions = List.generate(12, (i) => i + 1);
  final List<int> incomeLevels = List.generate(9, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Column(children: [const SizedBox(height: 24)])),
            _buildDropdownRow(
              '출생년도',
              selectedYear,
              yearOptions,
              (val) => setState(() => selectedYear = val),
              isInt: true,
            ),
            _buildDropdownRow(
              '성별',
              selectedGender,
              genderOptions,
              (val) => setState(() => selectedGender = val),
              isMap: true,
            ),
            _buildDropdownRow(
              '소득 분위',
              selectedIncomeLevel,
              incomeLevels,
              (val) => setState(() => selectedIncomeLevel = val),
              isInt: true,
            ),
            _buildDropdownRow(
              '거주지',
              selectedRegion,
              regionOptions,
              (val) => setState(() => selectedRegion = val),
            ),
            _buildDropdownRow(
              '대학구분',
              selectedUniversityType,
              universityTypes,
              (val) => setState(() => selectedUniversityType = val),
            ),
            _buildDropdownRow(
              '학적 상태',
              selectedAcademicStatus,
              academicStatuses,
              (val) => setState(() => selectedAcademicStatus = val),
              isMap: true,
            ),
            _buildDropdownRow(
              '학기',
              selectedSemester,
              semesterOptions,
              (val) => setState(() => selectedSemester = val),
              isInt: true,
            ),
            _buildDropdownRow(
              '학과 구분',
              selectedMajorField,
              majorFields,
              (val) => setState(() => selectedMajorField = val),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    '대학명',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: uniController,
                    onChanged: (value) => selectedUniversity = value,
                    decoration: const InputDecoration(
                      hintText: '입력 안 함',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    '전공명',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: majorController,
                    onChanged: (value) => selectedMajor = value,
                    decoration: const InputDecoration(
                      hintText: '입력 안 함',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    '성적',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${selectedGpa.toStringAsFixed(2)} / 4.50',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Slider(
                        value: selectedGpa,
                        min: 0.0,
                        max: 4.5,
                        divisions: 90,
                        label: selectedGpa.toStringAsFixed(2),
                        onChanged:
                            (value) => setState(() => selectedGpa = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('장애 유무', style: TextStyle(fontSize: 15)),
                    value: isDisabled,
                    onChanged:
                        (bool? value) =>
                            setState(() => isDisabled = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('다자녀 가구', style: TextStyle(fontSize: 15)),
                    value: isMultiChild,
                    onChanged:
                        (bool? value) =>
                            setState(() => isMultiChild = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text(
                      '기초생활\n수급자',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: isBasicLiving,
                    onChanged:
                        (bool? value) =>
                            setState(() => isBasicLiving = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('차상위계층', style: TextStyle(fontSize: 15)),
                    value: isSecondLowest,
                    onChanged:
                        (bool? value) =>
                            setState(() => isSecondLowest = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _saveProfileData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('저장', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow(
    String title,
    dynamic selectedValue,
    List options,
    Function(dynamic) onChanged, {
    bool isInt = false,
    bool isMap = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField(
              value:
                  isMap
                      ? (options.any(
                            (opt) =>
                                (opt['value'] ?? opt['code']) == selectedValue,
                          )
                          ? selectedValue
                          : null)
                      : (options.contains(selectedValue)
                          ? selectedValue
                          : null),
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('선택 안 함')),
                ...options.map((option) {
                  if (isMap) {
                    return DropdownMenuItem(
                      value: option['value'] ?? option['code'],
                      child: Text(option['label']!),
                    );
                  } else {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(isInt ? '$option' : option.toString()),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (val) => onChanged(val ?? false),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
