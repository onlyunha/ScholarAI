package dankook.capstone.repository;

import dankook.capstone.domain.Comment;

import dankook.capstone.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByPost(Post post); // 특정 게시글의 댓글 리스트 조회
}
