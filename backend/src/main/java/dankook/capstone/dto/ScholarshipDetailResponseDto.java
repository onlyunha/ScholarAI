package dankook.capstone.dto;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;

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
    private String academicRequirement; //성적기준
    private String incomeRequirement; //소득기준
    private String fundingAmount; //지원금액
    private String specificEligibility; //특정자격
    private String regionalRequirement; //지역거주여부
    private String selectionMethod; //선발방법
    private String selectionCount; //선발인원
    private String eligibilityRestriction; //자격제한
    private String recommendationRequired; //추천필요여부
    private String requiredDocuments; //제출서류
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
                .academicRequirement(s.getAcademicRequirement())
                .incomeRequirement(s.getIncomeRequirement())
                .fundingAmount(s.getFundingAmount())
                .specificEligibility(s.getSpecificEligibility())
                .regionalRequirement(s.getRegionalRequirement())
                .selectionMethod(s.getSelectionMethod())
                .selectionCount(s.getSelectionCount())
                .eligibilityRestriction(s.getEligibilityRestriction())
                .recommendationRequired(s.getRecommendationRequired())
                .requiredDocuments(s.getRequiredDocuments())
                .websiteUrl(s.getWebsiteUrl())
                .applicationStartDate(s.getApplicationStartDate())
                .applicationEndDate(s.getApplicationEndDate())
                .build();
    }
}
