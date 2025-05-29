package dankook.capstone.dto;

import dankook.capstone.domain.FinancialAidType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ScholarshipSearchCondition {
    //장학금 검색 조건
    private String keyword; //키워드
    private List<FinancialAidType> types; //학자금유형구분
    private boolean onlyRecruiting; //모집중
    private boolean onlyUpcoming; //모집예정
}
