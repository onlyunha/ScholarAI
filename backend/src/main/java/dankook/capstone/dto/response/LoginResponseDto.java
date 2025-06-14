package dankook.capstone.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginResponseDto {
    private Long memberId;
    private Long profileId;
}
