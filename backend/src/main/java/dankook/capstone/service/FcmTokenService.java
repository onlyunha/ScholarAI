package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.dto.FcmTokenRequestDto;
import dankook.capstone.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FcmTokenService {

    private final MemberRepository memberRepository;

    //FCM 토큰 저장
    @Transactional
    public void saveFcmToken(FcmTokenRequestDto fcmTokenRequestDto){
        Member member = memberRepository.findById(fcmTokenRequestDto.getMemberId())
                .orElseThrow(()-> new IllegalArgumentException("존재하지 않는 회원입니다."));

        member.updateFcmToken(fcmTokenRequestDto.getFcmToken());
    }
}
