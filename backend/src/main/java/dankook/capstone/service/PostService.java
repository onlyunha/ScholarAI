package dankook.capstone.service;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.Post;
import dankook.capstone.repository.PostRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;

    //게시글 작성
    @Transactional
    public Post createPost(String title, String content, Member member){
        Post post = Post.builder()
                .title(title)
                .content(content)
                .member(member)
                .build();
        return postRepository.save(post); //게시글 저장
    }

    //게시글 단건 조회
    @Transactional(readOnly = true)
    public Post getPost(Long id){
        return postRepository.findById(id)
                .orElseThrow(()->new EntityNotFoundException("해당 게시글이 존재하지 않습니다."));
    }

    //게시글 전체 조회
    @Transactional(readOnly = true)
    public List<Post> getAllPosts(){
        return postRepository.findAll();
    }

    //게시글 수정
    @Transactional
    public void updatePost(Long id, String newTitle, String newContent, Member currentMember){
        Post post = getPost(id);
        if (!post.getMember().getId().equals(currentMember.getId())) {
            throw new AccessDeniedException("게시글 수정 권한이 없습니다.");
        }
        post.update(newTitle, newContent);
    }

    //게시글 삭제
    @Transactional
    public void deletePost(Long id, Member currentMember){
        Post post = getPost(id);
        if (!post.getMember().getId().equals(currentMember.getId())) {
            throw new AccessDeniedException("게시글 삭제 권한이 없습니다.");
        }
        postRepository.delete(post);
    }

}
