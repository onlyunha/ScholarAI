package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.domain.ScholarshipLike;
import dankook.capstone.dto.ScholarshipLikeResponseDto;
import dankook.capstone.repository.MemberRepository;
import dankook.capstone.repository.ScholarshipLikeRepository;
import dankook.capstone.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ScholarshipLikeService {

    private final ScholarshipLikeRepository scholarshipLikeRepository;
    private final MemberRepository memberRepository;
    private final ScholarshipRepository scholarshipRepository;

    //찜 하기
    @Transactional
    public void likeScholarship(Long memberId, Long scholarshipId){
        if(scholarshipLikeRepository.existsByMemberIdAndScholarshipId(memberId, scholarshipId)){
            throw new IllegalStateException("이미 찜한 장학금입니다.");
        }

        Member member = memberRepository.findById(memberId)
                .orElseThrow(()-> new IllegalArgumentException("존재하지 않는 회원입니다."));

        Scholarship scholarship = scholarshipRepository.findById(scholarshipId)
                .orElseThrow(()-> new IllegalArgumentException("존재하지 않는 장학금입니다."));

        ScholarshipLike scholarshipLike = ScholarshipLike.builder()
                .member(member)
                .scholarship(scholarship)
                .build();

        scholarshipLikeRepository.save(scholarshipLike);
    }

    //찜 취소
    @Transactional
    public void unlikeScholarship(Long memberId, Long scholarshipId){
        ScholarshipLike scholarshipLike = scholarshipLikeRepository.findByMemberIdAndScholarshipId(memberId, scholarshipId)
                .orElseThrow(() -> new IllegalArgumentException("찜한 적 없는 장학금입니다."));
        scholarshipLikeRepository.delete(scholarshipLike);
    }

    //찜 목록 조회
    public List<ScholarshipLikeResponseDto> getLikedScholarships(Long memberId){
        List<ScholarshipLike> scholarshipLikes = scholarshipLikeRepository.findAllByMemberId(memberId);

        return scholarshipLikes.stream()
                .filter(like -> like.getScholarship() != null)
                .map(like -> ScholarshipLikeResponseDto.builder()
                        .scholarshipId(like.getScholarship().getId())
                        .organizationName(like.getScholarship().getOrganizationName())
                        .productName(like.getScholarship().getProductName())
                        .likedAt(like.getCreatedAt())
                        .build()
                ).toList();
    }
}
