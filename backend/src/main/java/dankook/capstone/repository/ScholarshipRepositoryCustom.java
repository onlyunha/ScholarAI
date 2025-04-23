package dankook.capstone.repository;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.ScholarshipSearchCondition;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ScholarshipRepositoryCustom {
    public Page<Scholarship> searchScholarships(ScholarshipSearchCondition condition, Pageable pageable);
}
