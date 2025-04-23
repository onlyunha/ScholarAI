import 'package:flutter/material.dart';
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
  double? selectedGrade;

  final List<int> yearOptions = List.generate(60, (i) => 1965 + i);
  final List<String> genderOptions = ['남성', '여성'];
  final List<String> regionOptions = [
    '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시', '대전광역시',
    '울산광역시', '세종특별자치시', '경기도', '강원도', '충청북도', '충청남도',
    '전라북도', '전라남도', '경상북도', '경상남도', '제주특별자치도'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),

            // 이름
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 나이 (출생년도)
            const Text('출생년도'),
            DropdownButton<int>(
              isExpanded: true,
              value: selectedYear,
              hint: const Text('출생년도 선택'),
              onChanged: (value) => setState(() => selectedYear = value),
              items: yearOptions
                  .map((year) => DropdownMenuItem(value: year, child: Text('$year년')))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // 성별
            const Text('성별'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedGender,
              hint: const Text('성별 선택'),
              onChanged: (value) => setState(() => selectedGender = value),
              items: genderOptions
                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // 지역
            const Text('지역'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedRegion,
              hint: const Text('지역 선택'),
              onChanged: (value) => setState(() => selectedRegion = value),
              items: regionOptions
                  .map((region) => DropdownMenuItem(value: region, child: Text(region)))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // 성적
            const Text('성적 (0.0 ~ 4.5)'),
            Slider(
              value: selectedGrade ?? 0.0,
              min: 0.0,
              max: 4.5,
              divisions: 45,
              label: selectedGrade?.toStringAsFixed(1) ?? '0.0',
              onChanged: (value) => setState(() => selectedGrade = value),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: 저장 처리
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
