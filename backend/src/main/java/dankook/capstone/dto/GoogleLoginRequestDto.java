package dankook.capstone.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class GoogleLoginRequestDto {
    @NotBlank
    private String idToken;  //Google ID 토큰
    @NotBlank
    private String provider; //구글
}
