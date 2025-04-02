package dankook.capstone.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class KakaoLoginRequestDto {

    /*
     * 프론트로부터 사용자 정보 받기
     */
    @NotBlank
    private String name; //이름
    @NotBlank
    private String email; //이메일
    @NotBlank
    private String provider; //카카오
}
