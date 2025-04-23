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
        String subject = "[ScholarAI] 이메일 인증 코드 안내";
        String content =
                "🎓 ScholarAI - 내 손 안의 기회\n\n" +
                "안녕하세요, ScholarAI입니다.\n" +
                "당신만을 위한 맞춤형 장학금 추천 서비스를 시작하기 위해\n" +
                "아래의 인증 코드를 입력해주세요.\n\n" +
                "✅ 이메일 인증 코드: " + authCode + "\n\n" +
                "본 인증 코드는 발송 시점부터 5분간만 유효하며,\n" +
                "타인에게 노출되지 않도록 주의해주세요.\n\n" +
                "지금 바로 ScholarAI에서 당신에게 꼭 맞는 장학금을 찾아보세요!\n\n" +
                "감사합니다.\n" +
                "ScholarAI 드림";

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
