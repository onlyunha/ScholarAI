//package dankook.capstone.controller;
//
//import dankook.capstone.auth.JwtTokenDto;
//import dankook.capstone.auth.JwtTokenProvider;
//import dankook.capstone.dto.LoginRequestDto;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.authentication.AuthenticationManager;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.util.Collections;
//
//@RestController
//@RequestMapping("/auth")
//@RequiredArgsConstructor
//public class AuthController {
//
//    private final AuthenticationManager authenticationManager;
//    private final JwtTokenProvider jwtTokenProvider;
//
//    // 로그인 요청 처리 (JSON 형태)
//    @PostMapping("/login")
//    public ResponseEntity<?> login(@RequestBody LoginRequestDto loginRequestDto) {
//
//        // 로그인 정보로 인증 시도
//        Authentication authentication = authenticationManager.authenticate(
//                new UsernamePasswordAuthenticationToken(loginRequestDto.getEmail(), loginRequestDto.getPassword())
//        );
//
//        // 인증 성공 후 JWT 생성
//        JwtTokenDto token = jwtTokenProvider.generateToken(authentication);
//
//        // JWT를 포함한 응답 반환
//        return ResponseEntity.ok(Collections.singletonMap("token", token));
//    }
//}
