package dankook.capstone.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import java.io.IOException;

@Slf4j
@Configuration
public class FirebaseConfig {
    @Value("${firebase.service-account.path}")
    private String SERVICE_ACCOUNT_PATH;

    @Bean
    public FirebaseApp firebaseApp() {
        try {
            //서비스 계정 키(.json)을 읽어서 Firebase 인증 객체 생성
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(
                            GoogleCredentials.fromStream(new ClassPathResource(SERVICE_ACCOUNT_PATH).getInputStream())
                    )
                    .build();

            log.info("Successfully initialized firebase app");
            //초기화된 FirebaseApp 객체를 반환하고 Spring Bean으로 등록
            return FirebaseApp.initializeApp(options);

        } catch (IOException exception) { //예외 발생 시 로그 남기고 null 반환
            log.error("Fail to initialize firebase app{}", exception.getMessage());
            return null;
        }
    }

    @Bean
    public FirebaseMessaging firebaseMessaging(FirebaseApp firebaseApp) {
        return FirebaseMessaging.getInstance(firebaseApp);
    }
}
