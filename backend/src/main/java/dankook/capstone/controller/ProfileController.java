package dankook.capstone.controller;

import dankook.capstone.dto.request.ProfileRequestDto;
import dankook.capstone.dto.response.ProfileResponseDto;
import dankook.capstone.dto.response.ResponseDto;
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

    //회원 프로필 조회 API
    @GetMapping("/{profileId}")
    public ResponseEntity<ResponseDto<ProfileResponseDto>> getProfile(@PathVariable Long profileId){
        ProfileResponseDto profile = profileService.getProfileResponseById(profileId);
        return ResponseEntity.ok(new ResponseDto<>("회원 프로필 조회에 성공하셨습니다", profile));
    }


    //회원 프로필 수정 API
    @PatchMapping("/{profileId}")
    public ResponseEntity<ResponseDto<Void>> updateProfile(@PathVariable Long profileId,
                                                           @RequestBody ProfileRequestDto profileRequestDto){
        profileService.updateProfile(profileId, profileRequestDto);
        return ResponseEntity.ok(new ResponseDto<>("회원 프로필이 수정되었습니다.", null));
    }

}
