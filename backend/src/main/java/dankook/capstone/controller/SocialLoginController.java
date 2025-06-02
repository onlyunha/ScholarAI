package dankook.capstone.controller;

import dankook.capstone.dto.*;
import dankook.capstone.service.GoogleLoginService;
import dankook.capstone.service.KakaoLoginService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class SocialLoginController {

    /*
     * 소셜 로그인 API
     * - 클라이언트가 JSON 형식으로 보낸 소셜 로그인 정보를 SocialLoginDto 객체로 변환.
     * - 소셜 로그인 로직을 처리하고, JWT를 JwtTokenDto 객체로 감싸서 클라이언트에게 JSON 형태로 응답.
     */

    private final KakaoLoginService kakaoLoginService;
    private final GoogleLoginService googleLoginService;

    //카카오 로그인
    @PostMapping("/kakao-login")
    public ResponseEntity<ResponseDto<LoginResponseDto>> kakaoLogin(@RequestBody @Valid KakaoLoginRequestDto kakaoLoginRequestDto){
        try{
            // 카카오 로그인 처리 후 JWT 발급
            KakaoLoginResponse kakaoLoginResponse = kakaoLoginService.kakaoLogin(kakaoLoginRequestDto);

            // 응답 헤더에 JWT 추가
            return ResponseEntity.ok()
                    .header("Authorization", "Bearer " + kakaoLoginResponse.getJwtTokenDto().getAccessToken()) // JWT를 헤더에 추가
                    .body(new ResponseDto<>("카카오 로그인에 성공하였습니다.",
                            new LoginResponseDto(kakaoLoginResponse.getMemberId(), kakaoLoginResponse.getProfileId())));
        } catch (Exception e) {
            return ResponseEntity.status(401).body(new ResponseDto<>("Kakao 로그인에 실패하였습니다.", null));
        }
    }

    //구글 로그인
    @PostMapping("/google-login")
    public ResponseEntity<ResponseDto<LoginResponseDto>> googleLogin(@RequestBody @Valid GoogleLoginRequestDto googleLoginRequestDto){
        try {
            // 구글 로그인 처리 후 JWT 발급
            GoogleLoginResponse googleLoginResponse = googleLoginService.googleLogin(googleLoginRequestDto.getIdToken());

            return ResponseEntity.ok()
                    .header("Authorization", "Bearer " + googleLoginResponse.getJwtTokenDto().getAccessToken())  // JWT를 헤더에 포함
                    .body(new ResponseDto<>("구글 로그인에 성공하였습니다.",
                            new LoginResponseDto(googleLoginResponse.getMemberId(), googleLoginResponse.getProfileId())));
        } catch (Exception e) {
            return ResponseEntity.status(401).body(new ResponseDto<>("구글 로그인에 실패하였습니다.", null));
        }
    }

}
