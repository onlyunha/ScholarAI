/// =============================================================
/// File : profile_edit_screen.dart
/// Desc : 프로필 수정
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-04-28
/// =============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants.dart';

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

  final List<int> yearOptions = List.generate(60, (i) => DateTime.now().year - i);
  final List<String> genderOptions = ['선택 안 함', '남자', '여자'];
  final List<String> regionOptions = [
    '선택 안 함',
    '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시',
    '대전광역시', '울산광역시', '세종특별자치시', '경기도', '강원도',
    '충청북도', '충청남도', '전라북도', '전라남도', '경상북도',
    '경상남도', '제주특별자치도'
  ];
  final List<String> universityTypes = ['4년제', '전문대', '기타'];
  final List<String> academicStatuses = ['ENROLLED', 'LEAVE_OF_ABSENCE', 'EXPECTED_GRADUATION', 'GRADUATED'];
  final List<String> majorFields = ['공학계열', '자연계열', '인문계열', '사회계열', '예체능계열', '의약계열', '교육계열', '기타'];
  final List<int> semesterOptions = List.generate(12, (i) => i + 1);
  final List<int> incomeLevels = List.generate(9, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Text('<', style: TextStyle(fontSize: 24, color: kPrimaryColor, fontWeight: FontWeight.bold)),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text('NAME', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('기본정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration.collapsed(hintText: '나이'),
                          value: selectedYear,
                          onChanged: (value) => setState(() => selectedYear = value),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('선택 안 함')),
                            ...yearOptions.map((year) => DropdownMenuItem(value: year, child: Text('$year년생'))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedYear == null ? '' : '만 ${DateTime.now().year - selectedYear!}세',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: kPrimaryColor),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration.collapsed(hintText: '성별'),
                          value: selectedGender,
                          onChanged: (value) => setState(() => selectedGender = value),
                          items: genderOptions.map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration.collapsed(hintText: '거주지'),
                    value: selectedRegion,
                    onChanged: (value) => setState(() => selectedRegion = value),
                    items: regionOptions.map((region) => DropdownMenuItem(value: region, child: Text(region))).toList(),
                  ),

                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration.collapsed(hintText: '대학 구분'),
                    value: selectedUniversityType,
                    onChanged: (value) => setState(() => selectedUniversityType = value),
                    items: universityTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration.collapsed(hintText: '학적 상태'),
                    value: selectedAcademicStatus,
                    onChanged: (value) => setState(() => selectedAcademicStatus = value),
                    items: academicStatuses.map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration.collapsed(hintText: '학기'),
                    value: selectedSemester,
                    onChanged: (value) => setState(() => selectedSemester = value),
                    items: semesterOptions.map((s) => DropdownMenuItem(value: s, child: Text('$s학기'))).toList(),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration.collapsed(hintText: '학과 구분'),
                    value: selectedMajorField,
                    onChanged: (value) => setState(() => selectedMajorField = value),
                    items: majorFields.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    decoration: const InputDecoration(
                      labelText: '전공명',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => selectedMajor = value,
                  ),
                  const SizedBox(height: 20),

                  const Text('성적 (0.0 ~ 4.5)', style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: selectedGpa,
                    min: 0.0,
                    max: 4.5,
                    divisions: 45,
                    label: selectedGpa.toStringAsFixed(1),
                    onChanged: (value) => setState(() => selectedGpa = value),
                  ),

                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration.collapsed(hintText: '소득 분위 (1~9구간)'),
                    value: selectedIncomeLevel,
                    onChanged: (value) => setState(() => selectedIncomeLevel = value),
                    items: incomeLevels.map((l) => DropdownMenuItem(value: l, child: Text('$l분위'))).toList(),
                  ),

                  const SizedBox(height: 24),

                  CheckboxListTile(
                    value: isDisabled,
                    onChanged: (value) => setState(() => isDisabled = value ?? false),
                    title: const Text('장애 여부'),
                  ),
                  CheckboxListTile(
                    value: isMultiChild,
                    onChanged: (value) => setState(() => isMultiChild = value ?? false),
                    title: const Text('다자녀 가구 여부'),
                  ),
                  CheckboxListTile(
                    value: isBasicLiving,
                    onChanged: (value) => setState(() => isBasicLiving = value ?? false),
                    title: const Text('기초생활 수급자 여부'),
                  ),
                  CheckboxListTile(
                    value: isSecondLowest,
                    onChanged: (value) => setState(() => isSecondLowest = value ?? false),
                    title: const Text('차상위 계층 여부'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                // 저장 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('저장', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}