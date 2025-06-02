package dankook.capstone.dto;


import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ChatbotAnswer { //FastAPI 응답을 받는 DTO
    private Long id;
    private String matchedQuestion;
    private String answer;
}
