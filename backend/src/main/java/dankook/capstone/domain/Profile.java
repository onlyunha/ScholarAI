package dankook.capstone.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.AccessLevel;
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

    private int age; //나이

    private String gender; //성별

    private String residence; //거주지

    private String university; //대학

    private String major; //전공

    private int semester; //학기

    @Column(precision = 4, scale = 2) // 총 4자리 중 소수점 2자리
    private BigDecimal gpa; //성적

    private int incomeLevel; //소득분위
}
