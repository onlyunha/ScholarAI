package dankook.capstone.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Builder
@Getter
@AllArgsConstructor
public class ScholarshipLikeResponseDto {
    private Long scholarshipId;      //장학금 ID
    private String organizationName; //운영기관명
    private String productName;      //상품명(장학금 이름)
    private String financialAidType; //학자금유형구분
    private LocalDate applicationStartDate; //모집시작일
    private LocalDate applicationEndDate; //모집종료일
    private LocalDateTime likedAt;   //찜한 시각

}
