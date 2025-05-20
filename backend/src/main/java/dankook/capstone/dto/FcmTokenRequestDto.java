package dankook.capstone.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class FcmTokenRequestDto {
    private Long memberId;
    private String fcmToken;
}
