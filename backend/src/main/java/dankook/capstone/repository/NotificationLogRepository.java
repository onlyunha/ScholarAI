package dankook.capstone.repository;

import dankook.capstone.domain.NotificationLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationLogRepository extends JpaRepository<NotificationLog, Long> {
    //중복 예약 방지
    boolean existsByMemberIdAndScholarshipIdAndSentFalse(Long memberId, Long scholarshipId);

    //예약 알림 목록 가져오기
    List<NotificationLog> findByMemberIdAndScholarshipIdAndSentFalse(Long memberId, Long scholarshipId);

    //알림 내역 조회(역순)
    List<NotificationLog> findByMemberIdOrderByScheduledTimeDesc(Long memberId);
}
