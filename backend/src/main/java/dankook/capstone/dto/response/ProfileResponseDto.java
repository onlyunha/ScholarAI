package dankook.capstone.dto.response;

import dankook.capstone.domain.AcademicStatus;
import dankook.capstone.domain.Gender;
import dankook.capstone.domain.Profile;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;

@Builder
@Getter
public class ProfileResponseDto {
    private Long profileId; //프로필 id
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

    public static ProfileResponseDto from(Profile profile) {
        return ProfileResponseDto.builder()
                .profileId(profile.getId())
                .birthYear(profile.getBirthYear())
                .gender(profile.getGender())  // enum이면 .name() 붙여도 됨
                .residence(profile.getResidence())
                .universityType(profile.getUniversityType())
                .university(profile.getUniversity())
                .academicStatus(profile.getAcademicStatus())
                .semester(profile.getSemester())
                .majorField(profile.getMajorField())
                .major(profile.getMajor())
                .gpa(profile.getGpa())
                .incomeLevel(profile.getIncomeLevel())
                .disabled(profile.isDisabled())
                .multiChild(profile.isMultiChild())
                .basicLivingRecipient(profile.isBasicLivingRecipient())
                .secondLowestIncome(profile.isSecondLowestIncome())
                .build();
    }
}
