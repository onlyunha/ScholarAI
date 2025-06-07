package dankook.capstone.dto;

import dankook.capstone.domain.Comment;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Builder
@Getter
public class CommentResponseDto {
    private Long commentId;
    private String content;
    private String authorName;
    private Long memberId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static CommentResponseDto from(Comment comment) {
        boolean deleted = comment.getMember() == null || comment.getMember().isDeleted();
        String authorName = deleted ? "탈퇴한 회원" : comment.getMember().getName();
        Long memberId = deleted ? null : comment.getMember().getId();

        return CommentResponseDto.builder()
                .commentId(comment.getId())
                .content(comment.isDeleted() ? "삭제된 댓글입니다" : comment.getContent())
                .authorName(authorName) //작성자
                .memberId(memberId)
                .createdAt(comment.getCreatedAt())
                .updatedAt(comment.getUpdatedAt())
                .build();
    }
}
