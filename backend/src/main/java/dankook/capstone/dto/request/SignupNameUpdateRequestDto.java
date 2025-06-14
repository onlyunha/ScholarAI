package dankook.capstone.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class SignupNameUpdateRequestDto {

    @NotBlank
    String email;
    @NotBlank
    String name;
}
