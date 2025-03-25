//package dankook.capstone.auth;
//
//import io.jsonwebtoken.Jwts;
//import io.jsonwebtoken.SignatureAlgorithm;
//import io.jsonwebtoken.io.Decoders;
//import io.jsonwebtoken.security.Keys;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.security.core.Authentication;
//import org.springframework.stereotype.Component;
//
//import java.security.Key;
//import java.util.Date;
//
//@Slf4j
//@Component
//public class JwtTokenProvider {
//
//    private final Key key;
//
//    //application.yml에서 secret 값을 가져와 key에 저장
//    //JWT 서명용 키 초기화
//    public JwtTokenProvider(@Value("${jwt.secret}") String secretKey) {
//        byte[] keyBytes = Decoders.BASE64.decode(secretKey); // Base64 디코딩
//        this.key = Keys.hmacShaKeyFor(keyBytes); // HMAC SHA 알고리즘에 사용할 Key 객체 생성
//    }
//
//    public String getEmail(String token) {
//
//        return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody().get("email", String.class);
//    }
//
//    public String getRole(String token) {
//
//        return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody().get("role", String.class);
//    }
//
//    public Boolean isExpired(String token) {
//
//        return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody().getExpiration().before(new Date());
//    }
//
//    //사용자 정보를 이용하여 AccessToken & RefreshToken 생성
//    public JwtTokenDto generateToken(Authentication authentication){
//
//        //권한은 나중에 추가
//
//        long now = (new Date().getTime()); //현재 시간
//
//        //Access Token 생성
//        Date accessTokenExpiresIn = new Date(now + 86400000); //현재시간+1일 후
//        String accessToken = Jwts.builder() //JWT를 생성하는 빌더 객체
//                .setSubject(authentication.getName()) //이메일(아이디)
//                .setExpiration(accessTokenExpiresIn) //만료 시간 설정
//                .signWith(key, SignatureAlgorithm.HS256) //비밀 키와 서명 알고리즘을 받아서 토큰에 서명 추가
//                .compact(); //JWT 토큰을 문자열로 압축 후 반환
//
//
//        //Refresh Token 생성
//        String refreshToken = Jwts.builder()
//                .setExpiration(new Date(now + 86400000 * 7)) //7일(만료 시간 설정)
//                .signWith(key, SignatureAlgorithm.HS256) //서명(변조 방지 & 인증)
//                .compact();
//
//        return new JwtTokenDto(accessToken, refreshToken);
//
//    }
//}
