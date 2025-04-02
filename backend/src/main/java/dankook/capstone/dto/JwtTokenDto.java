package dankook.capstone.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class JwtTokenDto { //소셜 로그인시 JWT를 클라이언트에 반환하기 위한 DTO
    private String accessToken;
    //private String refreshToken;
}