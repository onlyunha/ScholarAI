package dankook.capstone.config;

import dankook.capstone.auth.*;
import dankook.capstone.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@RequiredArgsConstructor
@EnableWebSecurity
@Configuration
public class SecurityConfig {

    private final AuthenticationConfiguration authenticationConfiguration;
    private final JWTUtil jwtUtil;
    private final JWTFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws  Exception{

        LoginFilter loginFilter = new LoginFilter(authenticationManager(authenticationConfiguration), jwtUtil);
        loginFilter.setFilterProcessesUrl("/api/auth/login");

        http
                .csrf(csrf -> csrf.disable()) //CSRF 보호 비활성화
                .formLogin(formLogin -> formLogin.disable()) // JWT 사용 시 Form 로그인 비활성화
                .httpBasic(httpBasic -> httpBasic.disable()) // HTTP Basic 인증 비활성화
                .authorizeHttpRequests((authorize) -> authorize
                        .requestMatchers("/api/auth/**", "/", "/api/scholarships/**", "/api/likes/**",
                                "/api/profile/**","/api/fcm-token/**","/api/recommend/**").permitAll() //인증 없이 허용
                        .requestMatchers("/admin").hasRole("ADMIN")
                        .anyRequest().authenticated()) //그 외는 인증 필요
                .logout(logout -> logout.disable()) // JWT에서는 별도의 로그아웃 로직 필요
                .addFilterBefore(jwtFilter, LoginFilter.class)
                .addFilterAt(loginFilter, UsernamePasswordAuthenticationFilter.class) //LoginFilter 추가
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .cors(cors -> cors.configurationSource(corsConfigurationSource())); // CORS 설정; //세션 비활성화
        
        return http.build();
    }

    @Bean //패스워드 인코더 Bean 등록
    public BCryptPasswordEncoder bCryptPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean //AuthenticationManager Bean 등록
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {

        return configuration.getAuthenticationManager();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource(){
        CorsConfiguration corsConfiguration = new CorsConfiguration();

        corsConfiguration.addAllowedOriginPattern("*"); // 개발 시 모든 Origin 허용
        corsConfiguration.setAllowedOrigins(List.of("http://10.0.2.2:8080")); // 허용할 출처(클라이언트의 주소)
        corsConfiguration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE")); // 허용할 메서드
        corsConfiguration.setAllowedHeaders(List.of("Content-Type", "Authorization")); // 허용할 헤더
        corsConfiguration.setExposedHeaders(List.of("Authorization")); //브라우저 환경일 경우
        corsConfiguration.setAllowCredentials(true); // 자격 증명 허용
        corsConfiguration.setMaxAge(3600L); // 캐시 시간 설정

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfiguration); // 모든 요청에 CORS 설정 적용
        return source;
    }

}
