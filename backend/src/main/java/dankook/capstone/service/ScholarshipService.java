package dankook.capstone.service;

import dankook.capstone.domain.Scholarship;
import dankook.capstone.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScholarshipService {

    private final ScholarshipRepository scholarshipRepository;

    //운영기관명 또는 상품명을 키워드로
    public List<Scholarship> searchScholarships(String keyword){
        return scholarshipRepository.searchScholarships(keyword);
    }
}
