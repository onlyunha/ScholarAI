package dankook.capstone.service;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import dankook.capstone.auth.JWTUtil;
import dankook.capstone.dto.response.GoogleLoginResponse;
import dankook.capstone.dto.response.JwtTokenDto;
import dankook.capstone.domain.Member;
import dankook.capstone.dto.response.CustomUserDetails;
import dankook.capstone.repository.MemberRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
@RequiredArgsConstructor
@Slf4j
public class GoogleLoginService {
    private final MemberRepository memberRepository;
    private final JWTUtil jwtUtil;
    private static final JacksonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance(); //JSON 처리
    private static final NetHttpTransport TRANSPORT = new NetHttpTransport(); //HTTP 통신(Google 서버와의 통신)

    @Value("${google.client.id}")
    private String googleClientId;

    /*
     * Google ID 토큰의 무결성을 검증하는 메서드
     * - GoogleIdTokenVerifer 객체를 사용하여 ID 토큰을 검증
     * - 토큰이 유효하다면 사용자 정보 추출
     */
    public GoogleIdToken.Payload verifyIdToken(String idTokenString) throws Exception{
        // Google ID 토큰 검증을 위한 GoogleIdTokenVerifier 생성
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(TRANSPORT, JSON_FACTORY)
                .setAudience(Collections.singletonList(googleClientId))  // 내 애플리케이션의 CLIENT_ID 설정
                .build();

        //받은 ID 토큰을 검증
        GoogleIdToken idToken = verifier.verify(idTokenString);

        if (idToken != null) {
            return idToken.getPayload();  // 검증된 토큰의 Payload 반환 (사용자 정보 포함)
        } else {
            throw new IllegalArgumentException("유효하지 않은 ID 토큰입니다.");  // 예외 발생
        }
    }

    @Transactional
    public GoogleLoginResponse googleLogin(String idTokenString) throws Exception {
        // ID 토큰 검증
        GoogleIdToken.Payload payload = verifyIdToken(idTokenString);

        //사용자 정보 추출
        String name = (String) payload.get("name");
        String email = payload.getEmail();

        // 이메일을 기준으로 기존 회원 조회
        Member member = memberRepository.findByEmail(email).orElse(null);

        // 신규 회원일 경우 회원가입 처리
        if (member == null) {
            member = Member.builder()
                    .name(name)
                    .email(email)
                    .password("")
                    .role("ROLE_USER")
                    .provider("google")
                    .build();
            memberRepository.save(member);
        }

        // JWT 생성
        CustomUserDetails userDetails = new CustomUserDetails(member);
        String token = jwtUtil.generateJwt(member.getEmail(), member.getRole(), 60*60*10L);

        Long profileId = null;
        if (member.getProfile() != null) {
            profileId = member.getProfile().getId();
        }

        return new GoogleLoginResponse(new JwtTokenDto(token), member.getId(), profileId);
    }
}
