/// =============================================================
/// File : shcholarship_service.dart
/// Desc : 장학금 상세사항 안내
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-21
/// Updt : 2025-04-28
/// =============================================================
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scholarai/constants/config.dart';

// 장학금 요약 모델
class ScholarshipSummary {
  final int id;
  final String organizationName;
  final String productName;
  final String financialAidType;
  final String applicationStartDate;
  final String applicationEndDate;

  ScholarshipSummary({
    required this.id,
    required this.organizationName,
    required this.productName,
    required this.financialAidType,
    required this.applicationStartDate,
    required this.applicationEndDate,
  });

  factory ScholarshipSummary.fromJson(Map<String, dynamic> json) {
    return ScholarshipSummary(
      id: json['id'],
      organizationName: json['organizationName'],
      productName: json['productName'],
      financialAidType: json['financialAidType'],
      applicationStartDate: json['applicationStartDate'],
      applicationEndDate: json['applicationEndDate'],
    );
  }
}

// 장학금 상세 모델
class ScholarshipDetail {
  final int id;
  final String organizationName;
  final String productName;
  final String financialAidType;
  final String applicationStartDate;
  final String applicationEndDate;
  final String organizationType;
  final String productType;
  final String universityType;
  final String gradeSemester;
  final String majorField;
  final String academicRequirement;
  final String incomeRequirement;
  final String fundingAmount;
  final String specificEligibility;
  final String regionalRequirement;
  final String selectionMethod;
  final String selectionCount;
  final String eligibilityRestriction;
  final String recommendationRequired;
  final String requiredDocuments;
  final String websiteUrl;

  ScholarshipDetail({
    required this.id,
    required this.organizationName,
    required this.productName,
    required this.financialAidType,
    required this.applicationStartDate,
    required this.applicationEndDate,
    required this.organizationType,
    required this.productType,
    required this.universityType,
    required this.gradeSemester,
    required this.majorField,
    required this.academicRequirement,
    required this.incomeRequirement,
    required this.fundingAmount,
    required this.specificEligibility,
    required this.regionalRequirement,
    required this.selectionMethod,
    required this.selectionCount,
    required this.eligibilityRestriction,
    required this.recommendationRequired,
    required this.requiredDocuments,
    required this.websiteUrl,
  });

  factory ScholarshipDetail.fromJson(Map<String, dynamic> json) {
    return ScholarshipDetail(
      id: json['id'],
      organizationName: json['organizationName'],
      productName: json['productName'],
      financialAidType: json['financialAidType'],
      applicationStartDate: json['applicationStartDate'],
      applicationEndDate: json['applicationEndDate'],
      organizationType: json['organizationType'],
      productType: json['productType'],
      universityType: json['universityType'],
      gradeSemester: json['gradeSemester'],
      majorField: json['majorField'],
      academicRequirement: json['academicRequirement'],
      incomeRequirement: json['incomeRequirement'],
      fundingAmount: json['fundingAmount'],
      specificEligibility: json['specificEligibility'],
      regionalRequirement: json['regionalRequirement'],
      selectionMethod: json['selectionMethod'],
      selectionCount: json['selectionCount'],
      eligibilityRestriction: json['eligibilityRestriction'],
      recommendationRequired: json['recommendationRequired'],
      requiredDocuments: json['requiredDocuments'],
      websiteUrl: json['websiteUrl'],
    );
  }
}

// 장학금 검색 요청
Future<List<ScholarshipSummary>> searchScholarships({
  String? keyword,
  List<String>? financialAidTypes,
  bool? onlyRecruiting,
  int page = 0,
  int size = 10,
}) async {
  final queryParams = <String, String>{
    'page': page.toString(),
    'size': size.toString(),
  };

  if (keyword != null && keyword.isNotEmpty) {
    queryParams['keyword'] = keyword;
  }

  if (onlyRecruiting == true) {
    queryParams['onlyRecruiting'] = 'true';
  }

  // financialAidType 여러 개 지원
  final queryString = StringBuffer();
  queryParams.forEach((key, value) {
    queryString.write('&$key=$value');
  });

  if (financialAidTypes != null && financialAidTypes.isNotEmpty) {
    for (final type in financialAidTypes) {
      queryString.write('&financialAidType=$type');
    }
  }

  final uri = Uri.parse('$baseUrl/api/scholarships/search?${queryString.toString().substring(1)}');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> content = data['content'];
    return content.map((json) => ScholarshipSummary.fromJson(json)).toList();
  } else {
    throw Exception('장학금 검색 실패: ${response.body}');
  }
}

// 장학금 상세 요청
Future<ScholarshipDetail> getScholarshipDetail(int id) async {
  final uri = Uri.parse('$baseUrl/api/scholarships/$id');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return ScholarshipDetail.fromJson(data);
  } else {
    throw Exception('장학금 상세 조회 실패: ${response.body}');
  }
}
