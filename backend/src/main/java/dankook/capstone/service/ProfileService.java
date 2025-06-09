package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.Profile;
import dankook.capstone.dto.request.ProfileRequestDto;
import dankook.capstone.dto.response.ProfileResponseDto;
import dankook.capstone.repository.MemberRepository;
import dankook.capstone.repository.ProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
                .disabled(profileRequestDto.isDisabled())
                .multiChild(profileRequestDto.isMultiChild())
                .basicLivingRecipient(profileRequestDto.isBasicLivingRecipient())
                .secondLowestIncome(profileRequestDto.isSecondLowestIncome())
                .build();

        member.setProfile(profile);
        Profile savedProfile = profileRepository.save(profile);
        return savedProfile.getId();
    }

    //회원 프로필 조회
    @Transactional(readOnly = true)
    public ProfileResponseDto getProfileResponseById(Long profileId){
        //프로필 ID로 회원 프로필 조회 후 DTO 변환 후 응답
        Profile profile = profileRepository.findById(profileId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 프로필입니다."));

        return ProfileResponseDto.from(profile);
    }

    //회원 프로필 수정
    @Transactional
    public void updateProfile(Long profileId, ProfileRequestDto profileRequestDto){
        Profile profile = profileRepository.findById(profileId)
                .orElseThrow(()-> new IllegalArgumentException("존재하지 않는 프로필입니다."));

        profile.update(
                profileRequestDto.getBirthYear(),
                profileRequestDto.getGender(),
                profileRequestDto.getResidence(),
                profileRequestDto.getUniversityType(),
                profileRequestDto.getUniversity(),
                profileRequestDto.getAcademicStatus(),
                profileRequestDto.getSemester(),
                profileRequestDto.getMajorField(),
                profileRequestDto.getMajor(),
                profileRequestDto.getGpa(),
                profileRequestDto.getIncomeLevel(),
                profileRequestDto.isDisabled(),
                profileRequestDto.isMultiChild(),
                profileRequestDto.isBasicLivingRecipient(),
                profileRequestDto.isSecondLowestIncome()
        );
    }
}
