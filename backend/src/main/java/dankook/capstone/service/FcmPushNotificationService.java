package dankook.capstone.service;

import com.google.firebase.messaging.FirebaseMessaging;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FcmPushNotificationService {

    private final FirebaseMessaging firebaseMessaging;

    //FCM 푸시 알림 전송
}
