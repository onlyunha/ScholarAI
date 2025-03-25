package dankook.capstone.auth;

import dankook.capstone.domain.Member;
import dankook.capstone.dto.CustomUserDetails;
import dankook.capstone.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberRepository memberRepository;

    /*
     * 사용자 정보 조회 및 변환
     */
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        //이메일(아이디)을 기반으로 회원 정보 조회
        Member member = memberRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("회원을 찾을 수 없습니다."));

        //조회된 회원 정보를 CustomUserDetails 객체로 변환하여 반환
        return new CustomUserDetails(member);

    }
}
