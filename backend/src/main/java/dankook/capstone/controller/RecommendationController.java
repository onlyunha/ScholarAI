package dankook.capstone.controller;

import dankook.capstone.dto.ProfileRequestDto;
import dankook.capstone.dto.ResponseDto;
import dankook.capstone.dto.ScholarshipResponseDto;
import dankook.capstone.service.AiRecommendationService;
import dankook.capstone.service.ProfileService;
import dankook.capstone.service.ScholarshipService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/recommend")
@RequiredArgsConstructor
public class RecommendationController {
    private final AiRecommendationService aiRecommendationService;
    private final ProfileService profileService;
    private final ScholarshipService scholarshipService;

    //맞춤형 장학금 추천받기
    @GetMapping
    public ResponseEntity<ResponseDto<List<ScholarshipResponseDto>>> recommendScholarships(
            @RequestParam Long profileId
    ){
        //회원 프로필 조회
        ProfileRequestDto profileRequestDto = profileService.getProfileDtoById(profileId);

        //FastAPI 추천 요청
        List<Long> recommendsIds = aiRecommendationService.getRecommendedScholarships(profileRequestDto);

        //추천 응답 DTO 변환
        List<ScholarshipResponseDto> result = scholarshipService.getScholarshipDtosByIds(recommendsIds);

        return ResponseEntity.ok(new ResponseDto<>("추천 결과입니다.", result));
    }

}
