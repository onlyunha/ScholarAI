package dankook.capstone.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JWTUtil { //JWT를 생성하고 검증

    private final Key key;

    //application.yml에서 secret 값을 가져와 key에 저장
    //JWT 서명용 키 초기화
    public JWTUtil(@Value("${jwt.secret}") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey); // Base64 디코딩
        this.key = Keys.hmacShaKeyFor(keyBytes); // HMAC SHA 알고리즘에 사용할 Key 객체 생성
    }


    //JWT에서 이메일(아이디) 가져오기
    public String getEmail(String token) {

        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody().get("email", String.class);
    }

    //JWT에서 권한(role) 가져오기
    public String getRole(String token) {

        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody().get("role", String.class);
    }

    //JWT 만료 여부 확인
    public Boolean isExpired(String token) {

        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getExpiration()
                .before(new Date()); //현재 시간보다 만료 시간이 이전이면 토큰이 만료됨(true 반환).
    }

    //JWT 생성(토큰 발급)
    public String generateJwt(String email, String role, Long expiredMs){
        Claims claims = Jwts.claims();
        claims.put("email", email); //이메일 저장
        claims.put("role", role); //역할 저장

        return Jwts.builder()
                .setClaims(claims) //사용자 정보(클레임 = JWT의 Payload 부분에 들어가는 데이터) 추가
                .setIssuedAt(new Date(System.currentTimeMillis())) //발급 시간
                .setExpiration(new Date(System.currentTimeMillis() + expiredMs * 1000L)) //만료 시간 설정
                .signWith(key, SignatureAlgorithm.HS256) //서명(변조 방지)
                .compact(); //JWT 문자열 반환
    }
}
