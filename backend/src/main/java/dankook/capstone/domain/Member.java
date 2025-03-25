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

    private String name; //이름

    @Column(nullable = false, unique = true)
    private String email; //이메일

    private String password; //비밀번호

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "profile_id")
    private Profile profile; //회원 프로필

    private String role; //USER, ADMIN

    private String provider; //local, kakao, google

    @Builder //DTO -> 엔티티
    public Member(String name, String email, String password, Profile profile, String role, String provider) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.profile = profile;
        this.role = role;
        this.provider = provider;
    }
}
