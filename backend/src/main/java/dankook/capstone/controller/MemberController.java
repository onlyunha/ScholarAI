package dankook.capstone.controller;

import dankook.capstone.dto.*;
import dankook.capstone.service.EmailService;
import dankook.capstone.service.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
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
    public ResponseEntity<ResponseDto<Long>> signUp(@RequestBody @Valid MemberJoinDto memberJoinDto){
        Long memberId = memberService.join(memberJoinDto); // 회원가입 로직 실행
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ResponseDto<>("회원가입이 완료되었습니다.", memberId));
    }

    //이메일 인증 코드 발송 API
    @PostMapping("/sendEmail")
    public ResponseEntity<ResponseDto<Void>> sendVerificationEmail(@RequestBody @Valid EmailRequestDto emailRequestDto){
        emailService.sendAuthCode(emailRequestDto.getEmail());
        return ResponseEntity.ok(new ResponseDto<>("인증 코드가 이메일로 전송되었습니다.", null));
    }

    //이메일 인증 코드 확인 API
    @PostMapping("/verifyEmail")
    public ResponseEntity<ResponseDto<Void>> verifyAuthCode(@RequestBody @Valid EmailVerificationDto emailVerificationDto) {
        boolean isValid = emailService.verifyAuthCode(emailVerificationDto.getEmail(), emailVerificationDto.getAuthCode());
        if (isValid) {
            return ResponseEntity.ok(new ResponseDto<>("이메일 인증이 완료되었습니다.", null));
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseDto<>("인증 코드가 유효하지 않거나 만료되었습니다.", null));
        }
    }



}
