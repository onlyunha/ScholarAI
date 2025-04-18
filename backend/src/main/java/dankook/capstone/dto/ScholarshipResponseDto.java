package dankook.capstone.dto;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;

@Builder
@Getter
//장학금 검색 결과용 DTO
public class ScholarshipResponseDto {

    //리스트 화면에서는 요약 정보만 제공
    private Long id;                        //상세 페이지 요청 시 필요
    private String organizationName;        // 운영기관
    private String productName;             // 상품명
    private String financialAidType;        // 학자금유형
    private LocalDate applicationStartDate; //모집시작일
    private LocalDate applicationEndDate;   //모집종료일

    public static ScholarshipResponseDto from(Scholarship s){
        return ScholarshipResponseDto.builder()
                .id(s.getId())
                .organizationName(s.getOrganizationName())
                .productName(s.getProductName())
                .financialAidType(s.getFinancialAidType())
                .applicationStartDate(s.getApplicationStartDate())
                .applicationEndDate(s.getApplicationEndDate())
                .build();
    }
}
