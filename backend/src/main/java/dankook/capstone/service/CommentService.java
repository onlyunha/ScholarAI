package dankook.capstone.service;

import dankook.capstone.domain.Comment;
import dankook.capstone.domain.Member;
import dankook.capstone.domain.Post;
import dankook.capstone.repository.CommentRepository;
import dankook.capstone.repository.PostRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CommentService {

    private final CommentRepository commentRepository;
    private final PostRepository postRepository;

    //댓글 작성
    public Comment createComment(Long postId, String content, Member member){
        Post post = postRepository.findById(postId)
                .orElseThrow(()-> new EntityNotFoundException("해당 게시글이 존재하지 않습니다."));

        Comment comment = Comment.builder()
                .content(content)
                .post(post)
                .member(member)
                .build();

        return commentRepository.save(comment);
    }

    //댓글 목록 조회
    public List<Comment> getCommentsByPost(Long postId){
        Post post = postRepository.findById(postId)
                .orElseThrow(()-> new EntityNotFoundException("해당 게시글이 존재하지 않습니다."));
        return commentRepository.findByPost(post);

    }

    //댓글 수정
    public void updateComment(Long commentId, String newContent, Member currentMember){
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new EntityNotFoundException("해당 댓글이 존재하지 않습니다."));

        if (!comment.getMember().getId().equals(currentMember.getId())) {
            throw new AccessDeniedException("댓글 수정 권한이 없습니다.");
        }

        comment.update(newContent);
    }

    //댓글 삭제
    public void deleteComment(Long commentId, Member currentMember){
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new EntityNotFoundException("해당 댓글이 존재하지 않습니다."));

        if (!comment.getMember().getId().equals(currentMember.getId())) {
            throw new AccessDeniedException("댓글 삭제 권한이 없습니다.");
        }

        commentRepository.delete(comment);
    }

}
