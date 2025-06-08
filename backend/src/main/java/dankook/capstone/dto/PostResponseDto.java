package dankook.capstone.dto;

import dankook.capstone.domain.Post;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Builder
@Getter
public class PostResponseDto { //게시글 전체 조회용
    private Long postId;
    private String title;
    private String authorName; //작성자
    private int commentCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static PostResponseDto from(Post post){
        String authorName = (post.getMember() == null || post.getMember().isDeleted())
                ? "탈퇴한 회원" : post.getMember().getName();

        return PostResponseDto.builder()
                .postId(post.getId())
                .title(post.getTitle())
                .authorName(authorName) //작성자
                .commentCount(post.getComments().size())
                .createdAt(post.getCreatedAt())
                .updatedAt(post.getUpdatedAt())
                .build();
    }
}
