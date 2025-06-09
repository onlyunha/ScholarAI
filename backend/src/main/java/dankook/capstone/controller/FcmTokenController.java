package dankook.capstone.controller;

import dankook.capstone.dto.request.FcmTokenRequestDto;
import dankook.capstone.dto.response.ResponseDto;
import dankook.capstone.service.FcmTokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/fcm-token")
public class FcmTokenController {

    private final FcmTokenService fcmTokenService;

    //FCM 토큰 저장 API
    @PostMapping
    public ResponseEntity<ResponseDto<Void>> saveFcmToken(@RequestBody FcmTokenRequestDto fcmTokenRequestDto){
        try {
            fcmTokenService.saveFcmToken(fcmTokenRequestDto);
            return ResponseEntity.ok(new ResponseDto<>("FCM 토큰이 성공적으로 저장되었습니다.", null));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(new ResponseDto<>("FCM 토큰 저장 실패: " + e.getMessage(), null));
        }
    }
}
