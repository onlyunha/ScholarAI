package dankook.capstone.service;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.ScholarshipResponseDto;
import dankook.capstone.dto.ScholarshipSearchCondition;
import dankook.capstone.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScholarshipService {

    private final ScholarshipRepository scholarshipRepository;

    //장학금 검색&필터링
    public Page<Scholarship> searchScholarships(ScholarshipSearchCondition condition, Pageable pageable){
        return scholarshipRepository.searchScholarships(condition, pageable);
    }

    //장학금 조회
    public Scholarship findById(Long id){
        return scholarshipRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 장학금입니다. ID: " + id));
    }

    //장학금 ID 리스트를 통해 조회
    public List<ScholarshipResponseDto> getScholarshipDtosByIds(List<Long> ids) {
        return scholarshipRepository.findAllById(ids).stream()
                .map(ScholarshipResponseDto::from)
                .collect(Collectors.toList());
    }
}
