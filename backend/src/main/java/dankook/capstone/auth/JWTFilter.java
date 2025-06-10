package dankook.capstone.auth;

import dankook.capstone.domain.Member;
import dankook.capstone.dto.response.CustomUserDetails;
import dankook.capstone.repository.MemberRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JWTFilter extends OncePerRequestFilter { //JWT 검증

    private final JWTUtil jwtUtil;
    private final MemberRepository memberRepository;

    /*
     * JWT 검증 로직(doFilterInternal)
     * - Spring Security 필터 체인에서 실행
     * - HTTP 요청이 올 때마다 JWT 검증 수행
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        //request에서 Authorization 헤더를 찾음
        String authorization = request.getHeader("Authorization");

        //Authorization 헤더 검증
        //토큰이 없거나 "Bearer "로 시작하지 않는 경우
        if(authorization == null || !authorization.startsWith("Bearer ")){
            System.out.println("token null");
            filterChain.doFilter(request, response); //다음 필터로 넘김

            //조건이 해당되면 메소드 종료
            return;
        }

        //"Bearer " 부분 제거 후 순수 JWT 토큰만 획득
        String token = authorization.split(" ")[1];

        //토큰 소멸 시간 검증
        if(jwtUtil.isExpired(token)){
            System.out.println("token expired");
            filterChain.doFilter(request, response);

            //조건이 해당되면 메소드 종료
            return;
        }

        //JWT 토큰에서 email과 role 획득
        String email = jwtUtil.getEmail(token);
        String role = jwtUtil.getRole(token);

        //Member 객체를 생성하여 값 set -> jwt 인증에서는 비밀번호 필요 없음.
//        Member member = Member.builder()
//                .email(email)
//                .password("") //빈 문자열
//                .role(role)
//                .build();

        Member member = memberRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("회원 정보를 찾을 수 없습니다."));

        //UserDetails에 회원 정보 객체 담기
        CustomUserDetails customUserDetails = new CustomUserDetails(member);

        //스프링 시큐리티 인증 토큰 생성
        Authentication authToken = new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities());

        //세션에 사용자 등록(SecurityContextHolder에 인증 정보 저장)
        SecurityContextHolder.getContext().setAuthentication(authToken);

        //JWT 검증이 끝난 후 요청을 다음 필터로 넘김
        filterChain.doFilter(request, response);
    }
}
