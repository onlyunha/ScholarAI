package dankook.capstone.dto;

import dankook.capstone.domain.AcademicStatus;
import dankook.capstone.domain.Gender;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ProfileRequestDto {
    private int age;
    private Gender gender;
    private String residence;
    private String universityType;
    private String university;
    private AcademicStatus academicStatus;
    private int semester;
    private String majorField;
    private String major;
    private BigDecimal gpa;
    private int incomeLevel;
    private boolean isDisabled;
    private boolean isMultiChild;
    private boolean isBasicLivingRecipient;
    private boolean isSecondLowestIncome;
}
