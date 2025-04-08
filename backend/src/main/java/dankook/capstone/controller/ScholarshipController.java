package dankook.capstone.controller;

import dankook.capstone.dto.ScholarshipResponseDto;
import dankook.capstone.service.ScholarshipService;
import lombok.RequiredArgsConstructor;
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

    /*
     * 장학금 검색 API
     * - 클라이언트가 운영기관명 또는 상품명으로 검색 시 장학금 리스트 반환
     * - URL 쿼리 파라미터에서 keyword 값을 받음
     */
    @GetMapping("/search")
    public List<ScholarshipResponseDto> search(@RequestParam String keyword){
        return scholarshipService.searchScholarships(keyword).stream()
                .map(ScholarshipResponseDto::from)
                .toList();
    }
}
