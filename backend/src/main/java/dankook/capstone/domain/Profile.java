package dankook.capstone.domain;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

import java.math.BigDecimal;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@SQLDelete(sql = "UPDATE profile SET deleted = true WHERE profile_id = ?")
@Where(clause = "deleted = false")
public class Profile {

    @Id
    @GeneratedValue
    @Column(name = "profile_id")
    private Long id;

    @Setter
    @OneToOne(mappedBy = "profile", fetch = FetchType.LAZY)
    private Member member;


    @Column(nullable = false)
    private int birthYear; //출생년도

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
    private boolean disabled; //장애 여부

    @Column(nullable = false)
    private boolean multiChild; //다자녀 가구 여부

    @Column(nullable = false)
    private boolean basicLivingRecipient; //기초생활수급자 여부

    @Column(nullable = false)
    private boolean secondLowestIncome; //차상위계층 여부

    @Column(nullable = false)
    private boolean deleted = false;


    @Builder
    public Profile(Member member, int birthYear, Gender gender, String residence, String universityType, String university, AcademicStatus academicStatus, int semester, String majorField, String major, BigDecimal gpa, int incomeLevel, boolean disabled, boolean multiChild, boolean basicLivingRecipient, boolean secondLowestIncome) {
        this.member = member;
        this.birthYear = birthYear;
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
        this.disabled = disabled;
        this.multiChild = multiChild;
        this.basicLivingRecipient = basicLivingRecipient;
        this.secondLowestIncome = secondLowestIncome;
    }

    //회원 프로필 수정
    public void update(int birthYear, Gender gender, String residence, String universityType,
                       String university, AcademicStatus academicStatus, int semester,
                       String majorField, String major, BigDecimal gpa, int incomeLevel,
                       boolean disabled, boolean multiChild, boolean basicLivingRecipient, boolean secondLowestIncome) {
        this.birthYear = birthYear;
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
        this.disabled = disabled;
        this.multiChild = multiChild;
        this.basicLivingRecipient = basicLivingRecipient;
        this.secondLowestIncome = secondLowestIncome;
    }

    //회원 탈퇴 시 프로필 soft delete
    public void markAsDeleted() {
        this.deleted = true;
    }
}
