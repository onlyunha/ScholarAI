package dankook.capstone.controller;

import dankook.capstone.dto.ChatbotRequestDto;
import dankook.capstone.dto.ChatbotResponseDto;
import dankook.capstone.dto.ResponseDto;
import dankook.capstone.service.ChatbotService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/chatbot")
@RequiredArgsConstructor
@ConditionalOnProperty(name = "feature.ai.enabled", havingValue = "true") //EC2에서 FastAPI 임시 제외
public class ChatbotController {

    private final ChatbotService chatbotService;

    @PostMapping("/ask")
    public ResponseEntity<ResponseDto<ChatbotResponseDto>> askChatbot(@RequestBody ChatbotRequestDto chatbotRequestDto){
        ChatbotResponseDto chatbotResponseDto = chatbotService.askChatbot(chatbotRequestDto);

        if (chatbotResponseDto == null) {
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseDto<>("챗봇 응답을 받지 못했습니다.", null));
        }
        return ResponseEntity.ok(new ResponseDto<>("챗봇 응답 성공", chatbotResponseDto));
    }

}
