package dankook.capstone.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FcmPushNotificationService {

    private final FirebaseMessaging firebaseMessaging;

    //FCM 푸시 알림 전송
    public void sendPushNotification(String fcmToken, String message) {
        Message pushMessage = Message.builder()
                .setToken(fcmToken)
                .setNotification(Notification.builder()
                        .setTitle("ScholarAI")
                        .setBody(message)
                        .build())
                .build();

        try {
            // Firebase로 메시지 전송
            String response = firebaseMessaging.send(pushMessage);
            System.out.println("Successfully sent message: " + response);
        } catch (FirebaseMessagingException e) {
            System.err.println("Error sending FCM message: " + e.getMessage());
        }
    }
}
