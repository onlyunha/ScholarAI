package dankook.capstone.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@AllArgsConstructor
public class NotificationLog { //알림 로그

    @Id
    @GeneratedValue
    @Column(name = "notificationLog_id")
    private Long id;

    private Long memberId;
    private Long scholarshipId;

    private LocalDateTime scheduledTime;

    @Setter
    private LocalDateTime sentTime;

    private String message;

    @Setter
    private boolean sent;

    private String type;

    @Builder
    public NotificationLog(Long memberId, Long scholarshipId, LocalDateTime scheduledTime, LocalDateTime sentTime, String message, boolean sent, String type) {
        this.memberId = memberId;
        this.scholarshipId = scholarshipId;
        this.scheduledTime = scheduledTime;
        this.sentTime = sentTime;
        this.message = message;
        this.sent = sent;
        this.type = type;
    }
}
