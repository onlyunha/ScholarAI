package dankook.capstone.dto.response;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ChatbotAnswer { //FastAPI 응답을 받는 DTO
    private Long id;

    @JsonProperty("matched_question")
    private String matchedQuestion;

    private String answer;
}
