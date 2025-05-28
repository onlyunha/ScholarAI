/// =============================================================
/// File : profile_edit_screen.dart
/// Desc : 프로필 수정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-05-20
/// =============================================================
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/config.dart';
import 'package:scholarai/providers/user_profile_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // 프로필 데이터를 로드합니다.
  }

  // 프로필 데이터를 불러오는 함수
  Future<void> _loadProfileData() async {
    try {
      String? userId =
          Provider.of<UserProfileProvider>(context, listen: false).getUserId();

      if (userId == null) {
        // userId가 없으면, 로그인 안된 경우 처리
        setState(() {
          errorMessage = '로그인된 사용자 정보가 없습니다';
        });
        return;
      }
      final response = await http.get(
        Uri.parse('$baseUrl/api/profile?memberId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final profileData = jsonDecode(response.body);
        selectedYear = profileData['birthYear'];
        selectedGender = profileData['gender'];
        selectedRegion = profileData['residence'];
        selectedUniversityType = profileData['universityType'];
        selectedAcademicStatus = profileData['academicStatus'];
        selectedMajorField = profileData['majorField'];
        selectedMajor = profileData['major'];
        selectedGpa = profileData['gpa']?.toDouble() ?? 0.0;
        setState(() {});
      } else {
        setState(() {
          errorMessage = '프로필 데이터를 불러오는 데 실패했습니다';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '네트워크 오류: 연결을 확인해주세요';
      });
    }
  }

  // 수정된 프로필 데이터를 서버로 저장하는 함수
  Future<void> _saveProfileData() async {
    try {
      String? userId =
          Provider.of<UserProfileProvider>(context, listen: false).getUserId();

      if (userId == null) {
        setState(() {
          errorMessage = '로그인된 사용자 정보가 없습니다';
        });
        return;
      }

      final url = Uri.parse('$baseUrl/api/profile?memberId=$userId');
      final body = jsonEncode({
        'birthYear': selectedYear,
        'gender': selectedGender,
        'residence': selectedRegion,
        'universityType': selectedUniversityType,
        'university': selectedUniversity,
        'academicStatus': selectedAcademicStatus,
        'majorField': selectedMajorField,
        'major': selectedMajor,
        'gpa': selectedGpa,
        'disabled': isDisabled,
        'multiChild': isMultiChild,
        'incomeLevel': selectedIncomeLevel,
        'basicLivingRecipient': isBasicLiving,
        'semester': selectedSemester,
        'secondLowestIncome': isSecondLowest,
      });

      print('📡 요청 URL: $url');
      print('📤 전송 내용: $body');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('📩 응답코드: ${response.statusCode}');
      print('📩 응답내용: ${response.body}');

      // 모든 항목이 null이면 저장 안 됨
      if (selectedYear == null ||
          selectedGender == null ||
          selectedRegion == null ||
          selectedUniversityType == null ||
          selectedAcademicStatus == null ||
          selectedSemester == null ||
          selectedMajorField == null ||
          selectedMajor == null ||
          selectedUniversity == null ||
          selectedUniversity!.isEmpty ||
          selectedGpa == 0.0 ||
          selectedIncomeLevel == null) {
        setState(() {
          errorMessage = '모든 항목을 입력해야 저장할 수 있습니다.';
        });
        return;
      }

      if (response.statusCode == 201) {
        Provider.of<UserProfileProvider>(context, listen: false).updateProfile(
          name: nameController.text,
          birthYear: selectedYear,
          gender: selectedGender,
          region: selectedRegion,
          university: selectedUniversity,
          universityType: selectedUniversityType,
          academicStatus: selectedAcademicStatus,
          memberId: userId, // ← 필요하면 포함
        );
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = '프로필 업데이트 실패';
        });
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
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
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller:
                        nameController
                          ..text =
                              nameController.text.isNotEmpty
                                  ? nameController.text
                                  : '이름을 입력하세요',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '이름을 입력하세요',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
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
                    title: const Text('장애 여부'),
                    value: isDisabled,
                    onChanged:
                        (value) => setState(() => isDisabled = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('다자녀 가구 여부'),
                    value: isMultiChild,
                    onChanged:
                        (value) =>
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
                    title: const Text('기초생활수급자 여부'),
                    value: isBasicLiving,
                    onChanged:
                        (value) =>
                            setState(() => isBasicLiving = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('차상위계층 여부'),
                    value: isSecondLowest,
                    onChanged:
                        (value) =>
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
              value: selectedValue,
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
