package dankook.capstone.dto;

import dankook.capstone.domain.Comment;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class ChatbotResponseDto {
    private Long id;
    private String matchedQuestion;
    private String answer;

    public static ChatbotResponseDto from(ChatbotAnswer chatbotAnswer) {
        return ChatbotResponseDto.builder()
                .id(chatbotAnswer.getId())
                .matchedQuestion(chatbotAnswer.getMatchedQuestion())
                .answer(chatbotAnswer.getAnswer())
                .build();
    }
}
