/// =============================================================
/// File : profile_create_screen.dart
/// Desc : 프로필 생성
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-05-30
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

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
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

  Future<void> _submitProfile() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final memberId = authProvider.memberId;
      final token = authProvider.token;
      final cleanToken = (token ?? '').replaceFirst('Bearer ', '');

      if (memberId == null) {
        setState(() {
          errorMessage = '로그인 정보가 없습니다.';
        });
        return;
      }

      final body = {
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
      print('🟢 프로필 제출 시작');
      print('🟡 memberId: $memberId');
      print('🟡 token: $token');
      print('🟢 요청 바디: ${jsonEncode(body)}');
      print('🟡 최종 Authorization 헤더: Bearer $cleanToken');

      final response = await http.post(
        Uri.parse('$baseUrl/api/profile?memberId=$memberId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $cleanToken',
        },
        body: jsonEncode(body),
      );

      print('🟡 서버 응답 코드: ${response.statusCode}');
      print('🟡 서버 응답 본문: ${response.body}');

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final profileId = json['data']; // profileId 추출

        final profileProvider = Provider.of<UserProfileProvider>(
          context,
          listen: false,
        );
        profileProvider.setProfileId(profileId); // 👈 profileId 저장

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
        Provider.of<UserProfileProvider>(
          context,
          listen: false,
        ).setProfileRegistered(true);
        await Future.microtask(() {});

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('프로필 등록이 완료되었습니다!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
          context.go(AppRoutes.profileView);
        }
      } else {
        setState(() {
          errorMessage = '저장 실패: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '네트워크 오류: $e';
      });
    }
  }

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
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
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
            _buildInputField(
              '대학명',
              selectedUniversity,
              (val) => setState(() => selectedUniversity = val),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              '전공명',
              selectedMajor,
              (val) => setState(() => selectedMajor = val),
            ),
            const SizedBox(height: 24),
            _buildGpaSlider(),
            const SizedBox(height: 24),
            _buildCheckboxGroup(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('제출', style: TextStyle(fontSize: 16)),
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
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField(
              value: selectedValue,
              onChanged: onChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
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

  Widget _buildInputField(
    String title,
    String? initialValue,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: onChanged,
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
    );
  }

  Widget _buildGpaSlider() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Text(
            '성적',
            style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
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
                onChanged: (value) => setState(() => selectedGpa = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxGroup() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('장애 여부'),
                value: isDisabled,
                onChanged: (val) => setState(() => isDisabled = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('다자녀 가구 여부'),
                value: isMultiChild,
                onChanged: (val) => setState(() => isMultiChild = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('기초생활수급자 여부'),
                value: isBasicLiving,
                onChanged:
                    (val) => setState(() => isBasicLiving = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('차상위계층 여부'),
                value: isSecondLowest,
                onChanged:
                    (val) => setState(() => isSecondLowest = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 상수들
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
}
