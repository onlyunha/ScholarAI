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
    private String keyword;
    private List<FinancialAidType> types;
    private boolean onlyRecruiting;
}
