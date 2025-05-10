package dankook.capstone.repository;

import dankook.capstone.domain.ScholarshipLike;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ScholarshipLikeRepository extends JpaRepository<ScholarshipLike, Long> {

    //특정 회원이 특정 장학금을 찜했는지 조회
    Optional<ScholarshipLike> findByMemberIdAndScholarshipId(Long memberId, Long scholarshipId);

    //특정 회원이 찜한 모든 장학금 리스트 조회
    List<ScholarshipLike> findAllByMemberId(Long memberId);

    //특정 찜 삭제
    //void deleteByMemberIdAndScholarshipId(Long memberId, Long ScholarshipId);

    //찜 존재 여부 확인(중복 방지)
    boolean existsByMemberIdAndScholarshipId(Long memberId, Long scholarshipId);
}
