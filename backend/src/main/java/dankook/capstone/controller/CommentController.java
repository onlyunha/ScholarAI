package dankook.capstone.controller;

import dankook.capstone.domain.Comment;
import dankook.capstone.domain.Member;
import dankook.capstone.dto.CommentRequestDto;
import dankook.capstone.dto.CommentResponseDto;
import dankook.capstone.dto.CustomUserDetails;
import dankook.capstone.dto.ResponseDto;
import dankook.capstone.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class CommentController {

    private final CommentService commentService;

    //댓글 작성
    @PostMapping("/posts/{postId}/comments")
    public ResponseEntity<ResponseDto<Long>> createComment(@PathVariable Long postId,
                                                           @RequestBody CommentRequestDto commentRequestDto,
                                                           @AuthenticationPrincipal CustomUserDetails userDetails){
        Member member = userDetails.getMember();
        Comment comment = commentService.createComment(postId, commentRequestDto.getContent(), member);
        return ResponseEntity.ok(new ResponseDto<>("댓글이 등록되었습니다.", comment.getId()));
    }

    //댓글 목록 조회
    @GetMapping("/posts/{postId}/comments")
    public ResponseEntity<ResponseDto<List<CommentResponseDto>>> getComments(@PathVariable Long postId){
        List<CommentResponseDto> comments = commentService.getCommentsByPost(postId).stream()
                .map(CommentResponseDto::from)
                .toList();
        return ResponseEntity.ok(new ResponseDto<>("댓글 목록 조회 성공", comments));
    }

    //댓글 수정
    @PutMapping("/comments/{commentId}")
    public ResponseEntity<ResponseDto<Void>> updateComment(@PathVariable Long commentId,
                                                           @RequestBody CommentRequestDto commentRequestDto,
                                                           @AuthenticationPrincipal CustomUserDetails userDetails){
        Member member = userDetails.getMember();
        commentService.updateComment(commentId, commentRequestDto.getContent(), member);
        return ResponseEntity.ok(new ResponseDto<>("댓글이 수정되었습니다.", null));
    }

    //댓글 삭제
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<ResponseDto<Void>> deleteComment(@PathVariable Long commentId,
                                                           @AuthenticationPrincipal CustomUserDetails userDetails){
        Member member = userDetails.getMember();
        commentService.deleteComment(commentId, member);
        return ResponseEntity.ok(new ResponseDto<>("댓글이 삭제되었습니다.", null));
    }

}
