package dankook.capstone.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class MemberJoinDto { //회원가입 요청 DTO
    @NotBlank
    private String name; //이름

    @Email
    @NotBlank
    private String email; //이메일(이이디)

    @NotBlank
    private String authCode; //이메일 인증 코드

    @NotBlank
    private String password; //비밀번호

    @NotBlank
    private String passwordCheck; //비밀번호 확인(DB에 저장할 필요 없으므로 DTO에서 관리)


}
