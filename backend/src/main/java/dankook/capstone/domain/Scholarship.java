package dankook.capstone.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import java.time.LocalDate;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Scholarship {

    @Id @GeneratedValue
    @Column(name = "scholarship_id")
    private Long id;

    @Column(length = 100)
    private String organizationName; //운영기관명

    @Column(length = 100)
    private String productName; //상품명

    @Column(length = 100)
    private String organizationType; //운영기관구분

    @Column(length = 20)
    private String productType; //상품구분

    @Column(length = 100)
    private String financialAidType; //학자금유형구분

    private String universityType; //대학구분
    private String gradeSemester; //학년(학기)구분
    private String majorField; //학과구분

    @Lob
    @Column(columnDefinition = "TEXT")
    private String academicRequirement; //성적기준

    @Lob
    @Column(columnDefinition = "TEXT")
    private String incomeRequirement; //소득기준

    @Lob
    @Column(columnDefinition = "TEXT")
    private String fundingAmount; //지원금액

    @Lob
    @Column(columnDefinition = "TEXT")
    private String specificEligibility; //특정자격

    @Lob
    @Column(columnDefinition = "TEXT")
    private String regionalRequirement; //지역거주여부

    @Lob
    @Column(columnDefinition = "TEXT")
    private String selectionMethod; //선발방법

    @Lob
    @Column(columnDefinition = "TEXT")
    private String selectionCount; //선발인원

    @Lob
    @Column(columnDefinition = "TEXT")
    private String eligibilityRestriction; //자격제한

    @Lob
    @Column(columnDefinition = "TEXT")
    private String recommendationRequired; //추천필요여부

    @Lob
    @Column(columnDefinition = "TEXT")
    private String requiredDocuments; //제출서류

    private String websiteUrl; //홈페이지주소

    private LocalDate applicationStartDate; //모집시작일
    private LocalDate applicationEndDate; //모집종료일

    @Builder
    public Scholarship(String organizationName, String productName, String organizationType, String productType, String financialAidType, String universityType, String gradeSemester, String majorField, String academicRequirement, String incomeRequirement, String fundingAmount, String specificEligibility, String regionalRequirement, String selectionMethod, String selectionCount, String eligibilityRestriction, String recommendationRequired, String requiredDocuments, String websiteUrl, LocalDate applicationStartDate, LocalDate applicationEndDate) {
        this.organizationName = organizationName;
        this.productName = productName;
        this.organizationType = organizationType;
        this.productType = productType;
        this.financialAidType = financialAidType;
        this.universityType = universityType;
        this.gradeSemester = gradeSemester;
        this.majorField = majorField;
        this.academicRequirement = academicRequirement;
        this.incomeRequirement = incomeRequirement;
        this.fundingAmount = fundingAmount;
        this.specificEligibility = specificEligibility;
        this.regionalRequirement = regionalRequirement;
        this.selectionMethod = selectionMethod;
        this.selectionCount = selectionCount;
        this.eligibilityRestriction = eligibilityRestriction;
        this.recommendationRequired = recommendationRequired;
        this.requiredDocuments = requiredDocuments;
        this.websiteUrl = websiteUrl;
        this.applicationStartDate = applicationStartDate;
        this.applicationEndDate = applicationEndDate;
    }
}
