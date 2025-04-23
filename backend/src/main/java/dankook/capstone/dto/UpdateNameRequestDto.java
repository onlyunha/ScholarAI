package dankook.capstone.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UpdateNameRequestDto {

    @NotBlank
    String email;
    @NotBlank
    String name;
}
