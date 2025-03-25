//package dankook.capstone.auth;
//
//import dankook.capstone.dto.CustomOAuth2User;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.Cookie;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import lombok.RequiredArgsConstructor;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
//import org.springframework.stereotype.Component;
//
//import java.io.IOException;
//import java.util.Collection;
//import java.util.Iterator;
//
//@Component
//@RequiredArgsConstructor
//public class CustomSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
//
//    private final JWTUtil jwtUtil;
//
//    @Override
//    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
//        CustomOAuth2User customUserDetails = (CustomOAuth2User) authentication.getPrincipal();
//
//        //이메일 가져오기
//        String email = customUserDetails.getEmail();
//
//        //role 가져오기
//        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
//        Iterator<? extends GrantedAuthority> iterator = authorities.iterator();
//        GrantedAuthority auth = iterator.next();
//        String role = auth.getAuthority();
//
//        //jwt 토큰
//        String token = jwtUtil.generateJwt(email, role, 60 * 60 * 60L);
//
//        //쿠키
//        response.addCookie(createCookie("Authorization", token));
//        response.sendRedirect(""); //프론트쪽으로
//
//    }
//
//    private Cookie createCookie(String key, String value){
//
//        Cookie cookie = new Cookie(key, value);
//        cookie.setMaxAge(60*60*60);
//        //cookie.setSecure(true);
//        cookie.setPath("/");
//        cookie.setHttpOnly(true);
//
//        return cookie;
//    }
//}
