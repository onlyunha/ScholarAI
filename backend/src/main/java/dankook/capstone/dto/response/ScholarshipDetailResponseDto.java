package dankook.capstone.dto.response;

import dankook.capstone.domain.Scholarship;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Builder
@Getter
//장학금 상세 페이지용 DTO
public class ScholarshipDetailResponseDto {

    private Long id;
    private String organizationName; //운영기관명
    private String productName; //상품명
    private String organizationType; //운영기관구분
    private String productType; //상품구분
    private String financialAidType; //학자금유형구분
    private String universityType; //대학구분
    private String gradeSemester; //학년(학기)구분
    private String majorField; //학과구분
    private List<String> academicRequirement; //성적기준
    private List<String> incomeRequirement; //소득기준
    private List<String> fundingAmount; //지원금액
    private List<String> specificEligibility; //특정자격
    private List<String> regionalRequirement; //지역거주여부
    private List<String> selectionMethod; //선발방법
    private List<String> selectionCount; //선발인원
    private List<String> eligibilityRestriction; //자격제한
    private List<String> recommendationRequired; //추천필요여부
    private List<String> requiredDocuments; //제출서류
    private String websiteUrl; //홈페이지주소
    private LocalDate applicationStartDate; //모집시작일
    private LocalDate applicationEndDate; //모집종료일

    public static ScholarshipDetailResponseDto from(Scholarship s) {
        return ScholarshipDetailResponseDto.builder()
                .id(s.getId())
                .organizationName(s.getOrganizationName())
                .productName(s.getProductName())
                .organizationType(s.getOrganizationType())
                .productType(s.getProductType())
                .financialAidType(s.getFinancialAidType())
                .universityType(s.getUniversityType())
                .gradeSemester(s.getGradeSemester())
                .majorField(s.getMajorField())
                .academicRequirement(splitByBullet(s.getAcademicRequirement()))
                .incomeRequirement(splitByBullet(s.getIncomeRequirement()))
                .fundingAmount(splitByBullet(s.getFundingAmount()))
                .specificEligibility(splitByBullet(s.getSpecificEligibility()))
                .regionalRequirement(splitByBullet(s.getRegionalRequirement()))
                .selectionMethod(splitByBullet(s.getSelectionMethod()))
                .selectionCount(splitByBullet(s.getSelectionCount()))
                .eligibilityRestriction(splitByBullet(s.getEligibilityRestriction()))
                .recommendationRequired(splitByBullet(s.getRecommendationRequired()))
                .requiredDocuments(splitByBullet(s.getRequiredDocuments()))
                .websiteUrl(s.getWebsiteUrl())
                .applicationStartDate(s.getApplicationStartDate())
                .applicationEndDate(s.getApplicationEndDate())
                .build();
    }
    //○ 로 나뉘어진 여러 항목들을 List<String>으로 파싱
    private static List<String> splitByBullet(String raw) {
        if (raw == null || raw.isBlank()) return List.of(); //null이나 빈 문자열이면 빈 리스트 반환
        return Arrays.stream(raw.split("○")) //○ 기준으로 split
                .map(String::trim)                 //앞뒤 공백 제거
                .filter(s -> !s.isEmpty())         //빈 항목 제거
                .collect(Collectors.toList());
    }
}
