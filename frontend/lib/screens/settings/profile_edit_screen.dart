/// =============================================================
/// File : profile_edit_screen.dart
/// Desc : 프로필 수정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-04-28
/// =============================================================
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholarai/constants/app_colors.dart';
import 'package:scholarai/constants/app_routes.dart';
import 'package:scholarai/constants/constants.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final nameController = TextEditingController();

  int? selectedYear;
  String? selectedGender;
  String? selectedRegion;
  String? selectedUniversityType;
  String? selectedAcademicStatus;
  String? selectedMajorField;
  String? selectedMajor;
  int? selectedSemester;
  int? selectedIncomeLevel;
  double selectedGpa = 0.0;
  bool isDisabled = false;
  bool isMultiChild = false;
  bool isBasicLiving = false;
  bool isSecondLowest = false;

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
          icon: const Text(
            '<',
            style: TextStyle(
              fontSize: 24,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        
          onPressed: () {
                  GoRouter.of(context).pop(); 
          },
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
                                  : 'NAME',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'NAME',
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
                      child: Text(isInt ? '$option학기' : option.toString()),
                    );
                  }
                }).toList(),
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
