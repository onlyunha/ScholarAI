package dankook.capstone.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ScholarshipLike {

    @Id @GeneratedValue
    @Column(name = "scholarshipLike_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scholarship_id", nullable = false)
    private Scholarship scholarship;

    private LocalDateTime createdAt; //찜한 시간

    @Builder
    public ScholarshipLike(Member member, Scholarship scholarship) {
        this.member = member;
        this.scholarship = scholarship;
        this.createdAt = LocalDateTime.now(); //생성자 안에서 현재 시간 세팅
    }
}
