package dankook.capstone.repository;

import dankook.capstone.domain.Post;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface PostRepository extends JpaRepository<Post, Long> {
    //fetch join 수정 예정
    @Query("""
    SELECT DISTINCT p FROM Post p
    LEFT JOIN FETCH p.member pm
    LEFT JOIN FETCH p.comments c
    LEFT JOIN FETCH c.member cm
    WHERE p.id = :id
""")
    Optional<Post> findPostWithAllAssociationsById(@Param("id") Long id); //단건 조회용 fetch join 쿼리

    @Query("""
    SELECT DISTINCT p FROM Post p
    LEFT JOIN FETCH p.member
    LEFT JOIN FETCH p.comments
""")
    List<Post> findAllWithMemberAndComments(); //전체 조회용 fetch join 쿼리

    @Query("SELECT p FROM Post p LEFT JOIN FETCH p.comments WHERE p.id = :id")
    Optional<Post> findWithComments(@Param("id") Long id);
}
