package dankook.capstone.controller;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.ScholarshipDetailResponseDto;
import dankook.capstone.dto.ScholarshipResponseDto;
import dankook.capstone.dto.ScholarshipSearchCondition;
import dankook.capstone.service.ScholarshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/scholarships")
public class ScholarshipController {

    private final ScholarshipService scholarshipService;

    //검색 & 필터링 API
    @GetMapping("/search")
    public Page<ScholarshipResponseDto> search(
            @RequestParam(required = false) String keyword,
            @RequestParam(name = "financialAidType", required = false) List<FinancialAidType> types,
            @RequestParam(required = false, defaultValue = "false") boolean onlyRecruiting,
            Pageable pageable
    ){
        ScholarshipSearchCondition condition = ScholarshipSearchCondition.builder()
                .keyword(keyword)
                .types(types)
                .onlyRecruiting(onlyRecruiting)
                .build();

        return scholarshipService.searchScholarships(condition, pageable)
                .map(ScholarshipResponseDto::from);
    }

    //장학금 상세 조회 API
    @GetMapping("/{id}")
    public ResponseEntity<ScholarshipDetailResponseDto> getScholarshipDetail(@PathVariable Long id){
        Scholarship scholarship = scholarshipService.findById(id);
        return ResponseEntity.ok(ScholarshipDetailResponseDto.from(scholarship));
    }
}
