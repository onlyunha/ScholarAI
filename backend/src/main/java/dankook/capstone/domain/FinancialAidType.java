package dankook.capstone.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum FinancialAidType {
    REGIONAL("지역연고"),
    SPECIAL("특기자"),
    MERIT("성적우수"),
    INCOME("소득구분"),
    DISABILITY("장애인"),
    OTHER("기타"),
    NONE("해당없음");

    private final String label;

}
