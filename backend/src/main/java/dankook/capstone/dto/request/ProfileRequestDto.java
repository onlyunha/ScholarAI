package dankook.capstone.dto.request;

import dankook.capstone.domain.AcademicStatus;
import dankook.capstone.domain.Gender;
import dankook.capstone.dto.response.ProfileResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProfileRequestDto {
    private int birthYear; //출생년도
    private Gender gender; //성별
    private String residence; //거주지
    private String universityType; //대학구분
    private String university; //대학명
    private AcademicStatus academicStatus; //학적 상태
    private int semester; //학기
    private String majorField; //학과 구분
    private String major; //전공명
    private BigDecimal gpa; //성적
    private int incomeLevel; //소득분위
    private boolean disabled; //장애여부
    private boolean multiChild; //다자녀가구여부
    private boolean basicLivingRecipient; //기초생활수급자여부
    private boolean secondLowestIncome; //차상위계층여부

    public static ProfileRequestDto from(ProfileResponseDto dto) {
        return ProfileRequestDto.builder()
                .birthYear(dto.getBirthYear())
                .gender(dto.getGender())  // enum이면 .name() 붙여도 됨
                .residence(dto.getResidence())
                .universityType(dto.getUniversityType())
                .university(dto.getUniversity())
                .academicStatus(dto.getAcademicStatus())
                .semester(dto.getSemester())
                .majorField(dto.getMajorField())
                .major(dto.getMajor())
                .gpa(dto.getGpa())
                .incomeLevel(dto.getIncomeLevel())
                .disabled(dto.isDisabled())
                .multiChild(dto.isMultiChild())
                .basicLivingRecipient(dto.isBasicLivingRecipient())
                .secondLowestIncome(dto.isSecondLowestIncome())
                .build();
    }
}
