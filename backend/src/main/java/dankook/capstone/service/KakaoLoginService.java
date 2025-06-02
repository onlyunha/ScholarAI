package dankook.capstone.service;

import dankook.capstone.auth.JWTUtil;
import dankook.capstone.dto.JwtTokenDto;
import dankook.capstone.domain.Member;
import dankook.capstone.dto.CustomUserDetails;
import dankook.capstone.dto.KakaoLoginRequestDto;
import dankook.capstone.dto.KakaoLoginResponse;
import dankook.capstone.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class KakaoLoginService {
    /*
     * 카카오 로그인 처리
     * - 프론트엔드에서 받은 유저 정보 사용
     */

    private final MemberRepository memberRepository;
    private final JWTUtil jwtUtil;

    @Transactional
    public KakaoLoginResponse kakaoLogin(KakaoLoginRequestDto kakaoLoginRequestDto){

        //이메일을 기준으로 기존 회원 조회
        Member member = memberRepository.findByEmail(kakaoLoginRequestDto.getEmail()).orElse(null);

        //신규 회원일 경우 회원가입 처리
        if(member == null){
            member = Member.builder()
                    .name(kakaoLoginRequestDto.getName())
                    .email(kakaoLoginRequestDto.getEmail())
                    .password("")
                    .role("ROLE_USER")
                    .provider(kakaoLoginRequestDto.getProvider())
                    .build();
            memberRepository.save(member); //DB에 회원 저장
        }

        //이미 존재하는 회원일 경우 조회된 Member 객체 사용
        //신규 회원일 경우 새로 생성한 Member 객체 사용

        //JWT 생성
        CustomUserDetails userDetails = new CustomUserDetails(member);
        String token = jwtUtil.generateJwt(member.getEmail(), member.getRole(), 60*60*10L);

        Long profileId = null;
        if (member.getProfile() != null) {
            profileId = member.getProfile().getId();
        }

        return new KakaoLoginResponse(new JwtTokenDto(token), member.getId(), profileId);
    }
}
