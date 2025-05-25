package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.repository.MemberRepository;
import dankook.capstone.repository.ScholarshipRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class ScholarshipScheduler {

    private final TaskScheduler taskScheduler;
    private final FcmPushNotificationService fcmPushNotificationService;
    private final ScholarshipRepository scholarshipRepository;
    private final MemberRepository memberRepository;

    //장학금을 찜할 때 알림 예약
    public void scheduleScholarshipReminder(Long memberId, Long scholarshipId){
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
        Scholarship scholarship = scholarshipRepository.findById(scholarshipId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 장학금입니다."));

        //알림 전송 시점 계산(모집일, 마감 1일 전, 마감일)
        LocalDateTime applicationStartDate = scholarship.getApplicationStartDate().atStartOfDay();  // 모집 시작일
        LocalDateTime applicationEndDate = scholarship.getApplicationEndDate().atStartOfDay();  // 마감일
        LocalDateTime oneDayBeforeEndDate = applicationEndDate.minusDays(1);  // 마감 1일 전

        String startDateMessage = "[" + scholarship.getOrganizationName() + " " + scholarship.getProductName() + "] " + "모집이 시작되었습니다!";
        String oneDayBeforeMessage = "[" + scholarship.getOrganizationName() + " " + scholarship.getProductName() + "] " + "마감일이 1일 남았습니다!";
        String deadlineMessage= "[" + scholarship.getOrganizationName() + " " + scholarship.getProductName() + "] " + "오늘이 마감일입니다! 신청을 잊지 마세요!";

        // 각 알림 전송 예약
        scheduleNotification(member, scholarship, applicationStartDate, startDateMessage);
        scheduleNotification(member, scholarship, oneDayBeforeEndDate, oneDayBeforeMessage);
        scheduleNotification(member, scholarship, applicationEndDate, deadlineMessage);
    }

    //알림 전송을 위한 동적 스케줄링
    private void scheduleNotification(Member member, Scholarship scholarship, LocalDateTime notificationTime, String message){
        // 알림 전송까지의 시간을 밀리초로 계산
        long delayMillis = Duration.between(LocalDateTime.now(), notificationTime).toMillis();

        // 알림을 보내는 작업을 예약
        taskScheduler.schedule(() -> {
            String fcmToken = member.getFcmToken();
            fcmPushNotificationService.sendPushNotification(fcmToken, message);  // 알림 메시지 전송
        }, new Date(System.currentTimeMillis() + delayMillis));  // 계산된 시간에 알림 예약
    }

}
