package dankook.capstone.controller;

import dankook.capstone.domain.Member;
import dankook.capstone.domain.Post;
import dankook.capstone.dto.CustomUserDetails;
import dankook.capstone.dto.PostRequestDto;
import dankook.capstone.dto.PostResponseDto;
import dankook.capstone.dto.ResponseDto;
import dankook.capstone.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/posts")
public class PostController {

    private final PostService postService;

    //게시글 작성
    @PostMapping
    public ResponseEntity<ResponseDto<Long>> createPost(@RequestBody PostRequestDto postRequestDto,
                                                        @AuthenticationPrincipal CustomUserDetails userDetails){
        Member member = userDetails.getMember();
        Post post = postService.createPost(postRequestDto.getTitle(), postRequestDto.getContent(), member);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new ResponseDto<>("게시글이 등록되었습니다.", post.getId()));
    }

    //게시글 단건 조회
    @GetMapping("/{id}")
    public ResponseEntity<ResponseDto<PostResponseDto>> getPost(@PathVariable Long id){
        Post post = postService.getPost(id);
        return ResponseEntity.ok(new ResponseDto<>("게시글 조회 성공", PostResponseDto.from(post)));
    }

    //게시글 전체 조회
    @GetMapping
    public ResponseEntity<ResponseDto<List<PostResponseDto>>> getAllPosts(){
        List<PostResponseDto> posts = postService.getAllPosts().stream()
                .map(PostResponseDto::from)
                .collect(Collectors.toList());
        return ResponseEntity.ok(new ResponseDto<>("게시글 전체 조회 성공", posts));
    }

    //게시글 수정
    @PutMapping("/{id}")
    public ResponseEntity<ResponseDto<Void>> updatePost(@PathVariable Long id,
                                                        @RequestBody PostRequestDto postRequestDto,
                                                        @AuthenticationPrincipal CustomUserDetails userDetails){
        Member member = userDetails.getMember();
        postService.updatePost(id, postRequestDto.getTitle(), postRequestDto.getContent(), member);
        return ResponseEntity.ok(new ResponseDto<>("게시글이 수정되었습니다.", null));
    }

    //게시글 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<ResponseDto<Void>> deletePost(@PathVariable Long id,
                                                        @AuthenticationPrincipal CustomUserDetails userDetails){
        Member member = userDetails.getMember();
        postService.deletePost(id, member);
        return ResponseEntity.ok(new ResponseDto<>("게시글이 삭제되었습니다.", null));
    }
}
