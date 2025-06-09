package dankook.capstone.service;

import dankook.capstone.dto.response.ChatbotAnswer;
import dankook.capstone.dto.request.ChatbotRequestDto;
import dankook.capstone.dto.response.ChatbotResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
@ConditionalOnProperty(name = "feature.ai.enabled", havingValue = "true") //EC2에서 FastAPI 임시 제외
public class ChatbotService {
    @Value("${ai.api.url}")
    private String fastApiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public ChatbotResponseDto askChatbot(ChatbotRequestDto chatbotRequestDto){
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON); //Content-Type: application/json 헤더 설정

        HttpEntity<ChatbotRequestDto> entity = new HttpEntity<>(chatbotRequestDto, headers);

        try {
            ResponseEntity<ChatbotAnswer> response = restTemplate.postForEntity(
                    fastApiUrl + "/faq-answer",
                    entity,
                    ChatbotAnswer.class
            );

            if (response.getStatusCode().is2xxSuccessful()) {
                return ChatbotResponseDto.from(response.getBody());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }
}
