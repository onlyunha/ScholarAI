package dankook.capstone.controller;

import dankook.capstone.dto.ProfileRequestDto;
import dankook.capstone.dto.ResponseDto;
import dankook.capstone.service.ProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;

    //회원 프로필 저장 API
    @PostMapping
    public ResponseEntity<ResponseDto<Long>> createProfile(@RequestParam Long memberId,
                                                           @RequestBody ProfileRequestDto profileRequestDto){
        Long profileId = profileService.saveProfile(memberId, profileRequestDto); // 회원 프로필 저장
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ResponseDto<>("회원 프로필이 저장되었습니다.", profileId));
    }

    //회원 프로필 수정 API

}
