package dankook.capstone.controller;

import dankook.capstone.domain.ScholarshipLike;
import dankook.capstone.dto.ResponseDto;
import dankook.capstone.dto.ScholarshipLikeResponseDto;
import dankook.capstone.service.ScholarshipLikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/likes")
public class ScholarshipLikeController {

    private final ScholarshipLikeService scholarshipLikeService;

    //찜하기
    @PostMapping
    public ResponseEntity<ResponseDto<Void>> like(@RequestParam Long memberId, @RequestParam Long scholarshipId){
        scholarshipLikeService.likeScholarship(memberId, scholarshipId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ResponseDto<>("찜 완료되었습니다.",null));
    }

    //찜 취소
    @DeleteMapping
    public ResponseEntity<ResponseDto<Void>> unlike(@RequestParam Long memberId, @RequestParam Long scholarshipId){
        scholarshipLikeService.unlikeScholarship(memberId, scholarshipId);
        return ResponseEntity.ok(new ResponseDto<>("찜이 취소되었습니다.", null));
    }

    //찜 목록
    @GetMapping("/{memberId}")
    public ResponseEntity<ResponseDto<List<ScholarshipLikeResponseDto>>> getLikedScholarships(@PathVariable Long memberId){
        List<ScholarshipLikeResponseDto> likedScholarships = scholarshipLikeService.getLikedScholarships(memberId);
        return ResponseEntity.ok(new ResponseDto<>("찜한 장학금 목록입니다.", likedScholarships));
    }
}
