package dankook.capstone.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Profile {

    @Id
    @GeneratedValue
    @Column(name = "profile_id")
    private Long id;

    @OneToOne(mappedBy = "profile", fetch = FetchType.LAZY)
    private Member member;

    @Column(nullable = false)
    private int age; //나이

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Gender gender; //성별

    @Column(nullable = false)
    private String residence; //거주지

    @Column(nullable = false)
    private String universityType; //대학구분

    @Column(nullable = false)
    private String university; //대학

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private AcademicStatus academicStatus; // 학적상태

    @Column(nullable = false)
    private int semester; //학기

    @Column(nullable = false)
    private String majorField; //학과구분

    @Column(nullable = false)
    private String major; //전공

    @Column(nullable = false, precision = 4, scale = 2) // 총 4자리 중 소수점 2자리
    private BigDecimal gpa; //성적

    @Column(nullable = false)
    private int incomeLevel; //소득분위

    @Column(nullable = false)
    private boolean isDisabled; //장애 여부

    @Column(nullable = false)
    private boolean isMultiChild; //다자녀 가구 여부

    @Column(nullable = false)
    private boolean isBasicLivingRecipient; //기초생활수급자 여부

    @Column(nullable = false)
    private boolean isSecondLowestIncome; //차상위계층 여부

    public void setMember(Member member) {
        this.member = member;
    }

    @Builder
    public Profile(Member member, int age, Gender gender, String residence, String universityType, String university, AcademicStatus academicStatus, int semester, String majorField, String major, BigDecimal gpa, int incomeLevel, boolean isDisabled, boolean isMultiChild, boolean isBasicLivingRecipient, boolean isSecondLowestIncome) {
        this.member = member;
        this.age = age;
        this.gender = gender;
        this.residence = residence;
        this.universityType = universityType;
        this.university = university;
        this.academicStatus = academicStatus;
        this.semester = semester;
        this.majorField = majorField;
        this.major = major;
        this.gpa = gpa;
        this.incomeLevel = incomeLevel;
        this.isDisabled = isDisabled;
        this.isMultiChild = isMultiChild;
        this.isBasicLivingRecipient = isBasicLivingRecipient;
        this.isSecondLowestIncome = isSecondLowestIncome;
    }
}
