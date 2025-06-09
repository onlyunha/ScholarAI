package dankook.capstone.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class KakaoLoginResponse {
    private JwtTokenDto jwtTokenDto;
    private Long memberId;
    private Long profileId;
}
