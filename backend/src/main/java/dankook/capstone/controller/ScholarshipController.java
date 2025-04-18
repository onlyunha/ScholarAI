package dankook.capstone.controller;

import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.dto.ScholarshipResponseDto;
import dankook.capstone.dto.ScholarshipSearchCondition;
import dankook.capstone.service.ScholarshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/scholarships")
public class ScholarshipController {

    private final ScholarshipService scholarshipService;

//    /*
//     * 장학금 검색 API
//     * - 클라이언트가 운영기관명 또는 상품명으로 검색 시 장학금 리스트 반환
//     * - URL 쿼리 파라미터에서 keyword 값을 받음
//     */
//    @GetMapping("/search")
//    public List<ScholarshipResponseDto> search(@RequestParam String keyword){
//        return scholarshipService.searchScholarshipsByKeyword(keyword).stream()
//                .map(ScholarshipResponseDto::from)
//                .toList();
//    }
//
//    /*
//     * 장학금 필터 API
//     * - 학자금유형구분, 모집중 필터
//     * - /api/scholarships
//     * - /api/scholarships?onlyRecruiting=true
//     * - /api/scholarships?financialAidType=MERIT
//     * - /api/scholarships?financialAidType=DISABILITY&onlyRecruiting=true
//     */
//    @GetMapping
//    public List<ScholarshipResponseDto> filter(
//            @RequestParam(name = "financialAidType", required = false) List<FinancialAidType> types,
//            @RequestParam(required = false, defaultValue = "false") boolean onlyRecruiting
//    ){
//        return scholarshipService.searchScholarshipsByFilters(types, onlyRecruiting).stream()
//                .map(ScholarshipResponseDto::from)
//                .toList();
//    }


    //통합 API
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
}
