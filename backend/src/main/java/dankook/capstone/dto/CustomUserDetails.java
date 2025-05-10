package dankook.capstone.dto;

import dankook.capstone.domain.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayDeque;
import java.util.Collection;
import java.util.Optional;

@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {

    private final Member member;

    /*
     * member 객체를 기반으로 이메일(아이디), 비밀번호, 역할(role) 등의 정보 반환
     */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {

        Collection<GrantedAuthority> collection = new ArrayDeque<>();

        collection.add(new GrantedAuthority() {
            @Override
            public String getAuthority() {
                return member.getRole();
            }
        });

        return collection;
    }

    @Override
    public String getPassword() {
        return member.getPassword();
    }

    @Override
    public String getUsername() {
        return member.getEmail();
    }

    public Long getMemberId(){
        return member.getId();
    }

    @Override //계정 만료 여부
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override //계정 잠금 여부
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override //비밀번호 만료 여부
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override //계정 활성화 여부
    public boolean isEnabled() {
        return true;
    }


}
