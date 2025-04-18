package dankook.capstone.service;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.ScholarshipSearchCondition;
import dankook.capstone.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScholarshipService {

    private final ScholarshipRepository scholarshipRepository;

//    //운영기관명 또는 상품명을 키워드로
//    public List<Scholarship> searchScholarshipsByKeyword(String keyword){
//        return scholarshipRepository.searchScholarshipsByKeyword(keyword);
//    }
//
//    //학자금유형구분 & 모집중 필터
//    public List<Scholarship> searchScholarshipsByFilters(List<FinancialAidType> types, boolean onlyRecruiting){
//        return scholarshipRepository.searchScholarshipsByFilters(types, onlyRecruiting);
//    }

    //통합
    public Page<Scholarship> searchScholarships(ScholarshipSearchCondition condition, Pageable pageable){
        return scholarshipRepository.searchScholarships(condition, pageable);
    }
}
