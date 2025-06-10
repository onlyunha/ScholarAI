package dankook.capstone.repository;

import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.request.ScholarshipSearchCondition;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ScholarshipRepositoryCustom {
    public Page<Scholarship> searchScholarships(ScholarshipSearchCondition condition, Pageable pageable);
}
