package dankook.capstone.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;
    private final RedisTemplate<String, String> redisTemplate;

    // 랜덤 인증 코드 생성
    private String generateAuthCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000); // 6자리 랜덤 숫자
        return String.valueOf(code);
    }

    //이메일 인증 코드 전송
    @Transactional
    public void sendAuthCode(String email){
        String authCode = generateAuthCode();
        String key = "authCode:" + email;  // 이메일을 키로 사용

        // 기존 인증 코드가 Redis에 있으면 삭제
        redisTemplate.delete(key);

        // 인증 코드 Redis에 저장, 만료 시간 5분 설정
        redisTemplate.opsForValue().set(key, authCode, Duration.ofMinutes(5));

        // 이메일 전송
        String subject = "이메일 인증 코드";
        String content = "인증 코드: " + authCode + "\n5분 안에 입력해주세요.";
        sendEmail(email, subject, content);
    }

    //이메일 전송
    public void sendEmail(String to, String subject, String content) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content, false); //일반 텍스트로 전송

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("이메일 전송 실패", e);
        }
    }

    //인증 코드 검증
    public boolean verifyAuthCode(String email, String authCode){
        String key = "authCode:" + email;
        String storedCode = redisTemplate.opsForValue().get(key);

        // 저장된 코드가 null이거나 만료된 경우 false 반환
        return storedCode != null && storedCode.equals(authCode);
    }
}
