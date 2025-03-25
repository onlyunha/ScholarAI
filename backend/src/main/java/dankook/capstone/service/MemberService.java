package dankook.capstone.service;

import dankook.capstone.auth.JWTUtil;
import dankook.capstone.auth.JwtTokenDto;
import dankook.capstone.domain.Member;
import dankook.capstone.dto.CustomUserDetails;
import dankook.capstone.dto.MemberJoinDto;
import dankook.capstone.dto.SocialLoginDto;
import dankook.capstone.repository.MemberRepository;

import jakarta.validation.constraints.Email;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final JWTUtil jwtUtil;
    private final EmailService emailService;

    //회원가입
    @Transactional
    public Long join(MemberJoinDto memberJoinDto){
        validateDuplicateMember(memberJoinDto); //중복 회원 검증

        //비밀번호와 비밀번호확인이 동일한지 검증
        if (!memberJoinDto.getPassword().equals(memberJoinDto.getPasswordCheck())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        //비밀번호 암호화
        String encodedPassword = bCryptPasswordEncoder.encode(memberJoinDto.getPassword());

        //빌더 패턴을 이용해 Member 객체 생성
        Member member = Member.builder()
                .name(memberJoinDto.getName())
                .email(memberJoinDto.getEmail())
                .password(encodedPassword) //암호화된 비밀번호
                .profile(null) //회원가입 시 프로필은 생성하지 않음
                .role("ROLE_USER") //회원가입시 USER 권한 부여
                .provider("local")
                .build();

        //DB에 회원 저장
        return memberRepository.save(member).getId();
    }

    /*
     * 소셜 로그인 처리
     * - 프론트엔드에서 받은 유저 정보 사용
     */
    @Transactional
    public JwtTokenDto kakaoLogin(SocialLoginDto socialLoginDto){

        //이메일을 기준으로 기존 회원 조회
        Member member = memberRepository.findByEmail(socialLoginDto.getEmail()).orElse(null);

        //새로운 회원일 경우 회원가입 처리
        if(member == null){
            member = Member.builder()
                    .email(socialLoginDto.getEmail())
                    .password("")
                    .role("ROLE_USER")
                    .provider(socialLoginDto.getProvider())
                    .build();
            memberRepository.save(member); //DB에 회원 저장
        }

        //이미 존재하는 회원일 경우 조회된 Member 객체 사용
        //신규 회원일 경우 새로 생성한 Member 객체 사용

        //JWT 생성
        CustomUserDetails userDetails = new CustomUserDetails(member);
        String token = jwtUtil.generateJwt(member.getEmail(), member.getRole(), 60*60*10L);

        return new JwtTokenDto(token);
    }

    //아직 커스텀 예외 클래스 사용 안함.
    private void validateDuplicateMember(MemberJoinDto memberJoinDto) {
        if (memberRepository.findByEmail(memberJoinDto.getEmail()).isPresent()) {
            throw new IllegalStateException("이미 가입된 이메일입니다.");
        }
    }


}
