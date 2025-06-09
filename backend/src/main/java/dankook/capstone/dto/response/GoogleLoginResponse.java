package dankook.capstone.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GoogleLoginResponse {
    private JwtTokenDto jwtTokenDto;
    private Long memberId;
    private Long profileId;
}
