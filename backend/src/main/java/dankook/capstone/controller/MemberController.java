package dankook.capstone.controller;

import dankook.capstone.auth.JwtTokenDto;
import dankook.capstone.dto.EmailRequestDto;
import dankook.capstone.dto.EmailVerificationDto;
import dankook.capstone.dto.MemberJoinDto;
import dankook.capstone.dto.SocialLoginDto;
import dankook.capstone.service.EmailService;
import dankook.capstone.service.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class MemberController {

    private final MemberService memberService;
    private final EmailService emailService;

    /*
     * 회원가입 API
     * - 클라이언트가 JSON 형식으로 데이터를 보내면 해당 데이터를 MemberJoinDto 객체로 변환.
     */
    @PostMapping("/signup")
    public ResponseEntity<?> signUp(@RequestBody @Valid MemberJoinDto memberJoinDto){
        Long memberId = memberService.join(memberJoinDto); // 회원가입 로직 실행
        return ResponseEntity.ok(memberId);
    }

    //이메일 인증 코드 발송 API
    @PostMapping("/sendEmail")
    public ResponseEntity<String> sendVerificationEmail(@RequestBody @Valid EmailRequestDto emailRequestDto){
        emailService.sendAuthCode(emailRequestDto.getEmail());
        return ResponseEntity.ok("인증 코드가 이메일로 전송되었습니다.");
    }

    //이메일 인증 코드 확인 API
    @PostMapping("/verifyEmail")
    public ResponseEntity<String> verifyAuthCode(@RequestBody @Valid EmailVerificationDto emailVerificationDto) {
        boolean isValid = emailService.verifyAuthCode(emailVerificationDto.getEmail(), emailVerificationDto.getCode());
        if (isValid) {
            return ResponseEntity.ok("인증 성공!");
        } else {
            return ResponseEntity.badRequest().body("인증 코드가 유효하지 않거나 만료되었습니다.");
        }
    }


    /*
     * 소셜 로그인 API
     * - 클라이언트가 JSON 형식으로 보낸 소셜 로그인 정보를 SocialLoginDto 객체로 변환.
     * - 소셜 로그인 로직을 처리하고, JWT를 JwtTokenDto 객체로 감싸서 클라이언트에게 JSON 형태로 응답.
     */
    //카카오 로그인
    @PostMapping("/login/kakao")
    public ResponseEntity<JwtTokenDto> kakaoLogin(@RequestBody SocialLoginDto socialLoginDto){
        JwtTokenDto jwtTokenDto = memberService.kakaoLogin(socialLoginDto);
        return ResponseEntity.ok(jwtTokenDto);
    }

//    //구글 로그인
//    @PostMapping("/login/google")
//    public ResponseEntity<JwtTokenDto> googleLogin(@RequestBody SocialLoginDto socialLoginDto){
//
//    }

}
