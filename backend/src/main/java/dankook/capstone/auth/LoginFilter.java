package dankook.capstone.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import dankook.capstone.dto.CustomUserDetails;
import dankook.capstone.dto.LoginRequestDto;
import dankook.capstone.dto.ResponseDto;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletInputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.util.StreamUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.Iterator;

@AllArgsConstructor
public class LoginFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JWTUtil jwtUtil;

    /*
     * 클라이언트가 로그인 요청을 보내면 인증(Authentication)을 처리
     * - 로그인 요청을 JSON 형식으로 받아서 처리함.
     * - 로그인 경로는 SecurityConfig에서 "/login" -> "/api/auth/login"으로 수정
     * - Authentication 객체 반환
     */
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {

        //JSON 데이터를 LoginRequestDto로 변환
        LoginRequestDto loginDTO = new LoginRequestDto();

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            ServletInputStream inputStream = request.getInputStream(); //요청 Body 읽기
            String messageBody = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8); //문자열로 변환
            loginDTO = objectMapper.readValue(messageBody, LoginRequestDto.class); //JSON -> LoginRequestDto 매핑

        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        //로그인 요청 정보(사용자 입력값)
        String email = loginDTO.getEmail(); //이메일
        String password = loginDTO.getPassword(); //비밀번호

        //ID/PW를 검증하기 위해 token에 담기
        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(email, password, null);

        //AuthenticationManager로 전달
        //내부적으로 UserDetailsService를 이용 -> DB에서 사용자 이메일 존재 여부 확인 & 비밀번호 검증
        return authenticationManager.authenticate(authToken);
    }

    //로그인 성공시 jwt 발급
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) {
        CustomUserDetails customUserDetails = (CustomUserDetails) authentication.getPrincipal();

        String email = customUserDetails.getUsername(); //이메일(아이디)
        Long memberId = customUserDetails.getMemberId(); //memberId 추출

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        Iterator<? extends GrantedAuthority> iterator = authorities.iterator();
        GrantedAuthority auth = iterator.next();

        String role = auth.getAuthority(); //역할

        //jwt 생성
        String token = jwtUtil.generateJwt(email, role, 60*60*10L);

        //생성한 jwt를 response에 담아서 응답
        response.addHeader("Authorization", "Bearer " + token);

        // 응답 메시지 작성
        ResponseDto<Long> responseDto = new ResponseDto<>("로그인에 성공하였습니다.", memberId);

        // 응답 본문 작성
        try {
            response.setStatus(HttpServletResponse.SC_OK); // 200 OK 상태
            response.setContentType("application/json;charset=UTF-8"); // 문자 인코딩을 UTF-8로 설정
            response.getWriter().write(new ObjectMapper().writeValueAsString(responseDto)); // ResponseDto를 JSON 형식으로 변환
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //로그인 실패시 실행
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) {
        // 로그인 실패 시 401 응답 코드 반환
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

        // 실패 메시지 작성
        ResponseDto<String> responseDto = new ResponseDto<>("로그인 실패: 이메일 또는 비밀번호가 잘못되었습니다.", null);

        try {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(new ObjectMapper().writeValueAsString(responseDto)); // ResponseDto를 JSON 형식으로 변환하여 본문에 작성
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
