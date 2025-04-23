package dankook.capstone.service;

import dankook.capstone.auth.JWTUtil;
import dankook.capstone.domain.Member;
import dankook.capstone.dto.MemberJoinDto;
import dankook.capstone.repository.MemberRepository;

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

    //아직 커스텀 예외 클래스 사용 안함.
    private void validateDuplicateMember(MemberJoinDto memberJoinDto) {
        if (memberRepository.findByEmail(memberJoinDto.getEmail()).isPresent()) {
            throw new IllegalStateException("이미 가입된 이메일입니다.");
        }
    }

    //회원 이름 수정
    @Transactional
    public void updateName(String email, String newName){
        Member member = memberRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));

        member.updateName(newName); // 이름 변경
    }



}
