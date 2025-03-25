//package dankook.capstone.auth;
//
//import dankook.capstone.domain.Member;
//import dankook.capstone.dto.*;
//import dankook.capstone.repository.MemberRepository;
//import lombok.RequiredArgsConstructor;
//import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
//import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
//import org.springframework.security.oauth2.core.user.OAuth2User;
//import org.springframework.stereotype.Service;
//
//@Service
//@RequiredArgsConstructor
//public class CustomOAuth2UserService extends DefaultOAuth2UserService {
//
//    private final MemberRepository memberRepository;
//
//    @Override
//    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException{
//        OAuth2User oAuth2User = super.loadUser(userRequest);
//        System.out.println(oAuth2User);
//
//        String registrationId = userRequest.getClientRegistration().getRegistrationId();
//
//        OAuth2Response oAuth2Response = null;
//
//        if(registrationId.equals("naver")){
//            oAuth2Response = new NaverResponse(oAuth2User.getAttributes());
//        }
//        else if(registrationId.equals("google")){
//            oAuth2Response = new GoogleResponse(oAuth2User.getAttributes());
//        }
//        else{
//            return null;
//        }
//
//        //이메일을 기준으로 기존 회원 조회
//        Member member = memberRepository.findByEmail(oAuth2Response.getEmail()).orElse(null);
//
//        //새로운 회원일 경우
//        if(member == null){
//            member = Member.builder()
//                    .email(oAuth2Response.getEmail())
//                    .password(null)
//                    .role("ROLE_USER")
//                    .provider(oAuth2Response.getProvider())
//                    .build();
//
//            memberRepository.save(member); //DB에 회원 저장
//        }
//
//        //이미 존재하는 회원일 경우 조회된 Member 객체 사용
//        //신규 회원일 경우 새로 생성한 Member 객체 사용
//        OAuth2UserDto oAuth2UserDto = OAuth2UserDto.builder()
//                .email(member.getEmail())
//                .name(oAuth2Response.getName())
//                .role(member.getRole())
//                .provider(member.getProvider())
//                .build();
//
//        return new CustomOAuth2User(oAuth2UserDto);
//
//    }
//
//}
