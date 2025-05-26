package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.Profile;
import dankook.capstone.dto.ProfileRequestDto;
import dankook.capstone.repository.MemberRepository;
import dankook.capstone.repository.ProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final ProfileRepository profileRepository;
    private final MemberRepository memberRepository;

    //회원 프로필 저장
    @Transactional
    public Long saveProfile(Long memberId, ProfileRequestDto profileRequestDto){
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));

        Profile profile = Profile.builder()
                .member(member)
                .birthYear(profileRequestDto.getBirthYear())
                .gender(profileRequestDto.getGender())
                .residence(profileRequestDto.getResidence())
                .universityType(profileRequestDto.getUniversityType())
                .university(profileRequestDto.getUniversity())
                .academicStatus(profileRequestDto.getAcademicStatus())
                .semester(profileRequestDto.getSemester())
                .majorField(profileRequestDto.getMajorField())
                .major(profileRequestDto.getMajor())
                .gpa(profileRequestDto.getGpa())
                .incomeLevel(profileRequestDto.getIncomeLevel())
                .isDisabled(profileRequestDto.isDisabled())
                .isMultiChild(profileRequestDto.isMultiChild())
                .isBasicLivingRecipient(profileRequestDto.isBasicLivingRecipient())
                .isSecondLowestIncome(profileRequestDto.isSecondLowestIncome())
                .build();

        member.setProfile(profile);
        Profile savedProfile = profileRepository.save(profile);
        return savedProfile.getId();
    }
}
