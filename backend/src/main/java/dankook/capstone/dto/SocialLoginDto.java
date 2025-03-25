package dankook.capstone.dto;

import lombok.Getter;

@Getter
public class SocialLoginDto {

    private String email;
    private String provider; //구글, 카카오
}
