package dankook.capstone.repository;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.ScholarshipSearchCondition;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ScholarshipRepositoryCustom {
    //List<Scholarship> searchScholarshipsByKeyword(String keyword); //키워드 검색
    //List<Scholarship> searchScholarshipsByFilters(List<FinancialAidType> types, boolean onlyRecruiting); //필터 검색

    public Page<Scholarship> searchScholarships(ScholarshipSearchCondition condition, Pageable pageable);
}
