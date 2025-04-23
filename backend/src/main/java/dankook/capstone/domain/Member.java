package dankook.capstone.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Member {

    @Id @GeneratedValue
    @Column(name = "member_id")
    private Long id;

    @Column(nullable = false)
    private String name; //이름

    @Column(nullable = false, unique = true)
    private String email; //이메일

    private String password; //비밀번호

    private String role; //USER, ADMIN

    private String provider; //local, kakao, google

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "profile_id")
    private Profile profile; //회원 프로필

    @Builder //DTO -> 엔티티
    public Member(String name, String email, String password, Profile profile, String role, String provider) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.provider = provider;

        if (profile != null) {
            this.setProfile(profile); // null이면 아무 동작 안함
        }
    }

    //연관관계 편의 메서드
    public void setProfile(Profile profile){
        this.profile = profile;
        if (profile.getMember() != this) {
            profile.setMember(this);
        }
    }

    //회원 이름 수정
    public void updateName(String name){
        this.name = name;
    }
}
