package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.NotificationLog;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.domain.ScholarshipLike;
import dankook.capstone.repository.MemberRepository;
import dankook.capstone.repository.NotificationLogRepository;
import dankook.capstone.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;

@Service
@RequiredArgsConstructor
public class ScholarshipScheduler {

    private final TaskScheduler taskScheduler;
    private final FcmPushNotificationService fcmPushNotificationService;
    private final NotificationLogRepository notificationLogRepository;
//    private final ScholarshipRepository scholarshipRepository;
//    private final MemberRepository memberRepository;


//    // 예약된 알림을 저장 (memberId -> (scholarshipId -> List<ScheduledFuture>))
//    private final Map<Long, Map<Long, List<ScheduledFuture<?>>>> scheduledTasks = new ConcurrentHashMap<>();

    //장학금을 찜할 때 알림 예약
    public void scheduleScholarshipReminder(ScholarshipLike scholarshipLike){

        Long memberId = scholarshipLike.getMember().getId();
        Long scholarshipId = scholarshipLike.getScholarship().getId();

        //중복 예약 방지
        boolean alreadyScheduled = notificationLogRepository.existsByMemberIdAndScholarshipIdAndSentFalse(memberId, scholarshipId);
        if (alreadyScheduled) {
            System.out.println("이미 예약된 알림입니다.");
            return;
        }

//        Member member = memberRepository.findById(memberId)
//                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
//        Scholarship scholarship = scholarshipRepository.findById(scholarshipId)
//                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 장학금입니다."));

        //알림 전송 시점 계산(모집일, 마감 1일 전, 마감일)
        LocalDateTime applicationStartDate = scholarshipLike.getScholarship().getApplicationStartDate().atStartOfDay();  // 모집 시작일
        LocalDateTime applicationEndDate = scholarshipLike.getScholarship().getApplicationEndDate().atStartOfDay();  // 마감일
        LocalDateTime oneDayBeforeEndDate = applicationEndDate.minusDays(1);  // 마감 1일 전

//        String base = "[" + scholarshipLike.getScholarship().getOrganizationName() + " " + scholarshipLike.getScholarship().getProductName() + "]";
//        String startMsg = base + " 모집이 시작되었습니다!";
//        String oneDayBeforeMsg = base + " 마감일이 1일 남았습니다!";
//        String deadlineMsg = base + " 오늘이 마감일입니다! 신청을 잊지 마세요!";

//        //알림 예약 및 저장
//        List<ScheduledFuture<?>> futures = List.of(
//                scheduleNotification(member, applicationStartDate, startMsg),
//                scheduleNotification(member, oneDayBeforeEndDate, oneDayBeforeMsg),
//                scheduleNotification(member, applicationEndDate, deadlineMsg)
//        );
//
//        scheduledTasks.computeIfAbsent(memberId, k -> new ConcurrentHashMap<>())
//                .put(scholarshipId, futures);

        String base = "[" + scholarshipLike.getScholarship().getOrganizationName() + " " + scholarshipLike.getScholarship().getProductName() + "]";
        scheduleNotification(memberId, scholarshipId, scholarshipLike.getMember(), applicationStartDate, base + " 모집이 시작되었습니다!", "START");
        scheduleNotification(memberId, scholarshipId, scholarshipLike.getMember(), oneDayBeforeEndDate, base + " 마감일이 1일 남았습니다!", "ONE_DAY_BEFORE");
        scheduleNotification(memberId, scholarshipId, scholarshipLike.getMember(), applicationEndDate, base + " 오늘이 마감일입니다! 신청을 잊지 마세요!", "END");
    }

    //알림 전송을 위한 동적 스케줄링
    private void scheduleNotification(Long memberId, Long scholarshipId, Member member,
                                 LocalDateTime notificationTime, String message, String type){
        // 알림 전송까지의 시간을 밀리초로 계산
        long delayMillis = Duration.between(LocalDateTime.now(), notificationTime).toMillis();

        if (delayMillis <= 0) {
            return;
        }

        // DB 저장
        NotificationLog log = NotificationLog.builder()
                .memberId(memberId)
                .scholarshipId(scholarshipId)
                .message(message)
                .scheduledTime(notificationTime)
                .sent(false)
                .type(type)
                .build();

        notificationLogRepository.save(log);

        // 알림을 보내는 작업을 예약
        taskScheduler.schedule(() -> {
            String fcmToken = member.getFcmToken();
            fcmPushNotificationService.sendPushNotification(fcmToken, message);  // 알림 메시지 전송
            log.setSent(true);
            log.setSentTime(LocalDateTime.now());
            notificationLogRepository.save(log);
        }, new Date(System.currentTimeMillis() + delayMillis));  // 계산된 시간에 알림 예약
    }

    //장학금을 찜 취소 시 알림 취소
    public void cancelScheduledReminder(Long memberId, Long scholarshipId) {
        List<NotificationLog> logs = notificationLogRepository
                .findByMemberIdAndScholarshipIdAndSentFalse(memberId, scholarshipId);
        logs.forEach(notificationLogRepository::delete); // 삭제 또는 상태 변경
    }
}
