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

    //주요 설명 필드 포함
    //organizationType, productType, universityType, gradeSemester,
    // majorField, selectionMethod, selectionCount, recommendationRequired 제외
    private Long id;
    private String organizationName; //운영기관명
    private String productName;   //상품명
    private String financialAidType;  //학자금유형구분

    private String academicRequirement; //성적기준
    private String incomeRequirement; //소득기준
    private String specificEligibility; //특정자격
    private String regionalRequirement; //지역거주여부
    private String eligibilityRestriction; //자격제한

    private String requiredDocuments; //제출서류
    private String fundingAmount; //지원금액

    private String websiteUrl; //홈페이지주소

    private LocalDate applicationStartDate; //모집시작일
    private LocalDate applicationEndDate; //모집종료일

    public static ScholarshipDetailResponseDto from(Scholarship s) {
        return ScholarshipDetailResponseDto.builder()
                .id(s.getId())
                .organizationName(s.getOrganizationName())
                .productName(s.getProductName())
                .financialAidType(s.getFinancialAidType())
                .academicRequirement(s.getAcademicRequirement())
                .incomeRequirement(s.getIncomeRequirement())
                .specificEligibility(s.getSpecificEligibility())
                .regionalRequirement(s.getRegionalRequirement())
                .eligibilityRestriction(s.getEligibilityRestriction())
                .requiredDocuments(s.getRequiredDocuments())
                .fundingAmount(s.getFundingAmount())
                .applicationStartDate(s.getApplicationStartDate())
                .applicationEndDate(s.getApplicationEndDate())
                .websiteUrl(s.getWebsiteUrl())
                .build();
    }
}
