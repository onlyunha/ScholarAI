package dankook.capstone.service;

import dankook.capstone.dto.ProfileRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@ConditionalOnProperty(name = "feature.ai.enabled", havingValue = "true") //EC2에서 FastAPI 임시 제외
public class AiRecommendationService {

    @Value("${ai.api.url}")
    private String fastApiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    //장학금 ID 리스트 반환
    public List<Long> getRecommendedScholarships(ProfileRequestDto profileRequestDto){

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON); //Content-Type: application/json 헤더 설정

        HttpEntity<ProfileRequestDto> entity = new HttpEntity<>(profileRequestDto, headers);


        //응답에서 recommendations 필드 파싱
        try{
            //HTTP POST 요청
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    fastApiUrl + "/recommend",
                    entity,
                    Map.class //JSON 응답을 자바의 Map<String, Object> 형태로 받아옴
            );

            // 응답이 200 OK이고, recommendations 필드가 있다면 파싱
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Object recommendationsObj = response.getBody().get("recommendations");

                if (recommendationsObj instanceof List<?>) {
                    List<?> rawList = (List<?>) recommendationsObj;

                    // 안전하게 Long 타입으로 변환
                    return rawList.stream()
                            .filter(Objects::nonNull) //null 요소 제거
                            .map(Object::toString) //문자열로 변환
                            .map(Long::valueOf) //Long 타입으로 변환
                            .collect(Collectors.toList()); //List<Long>로 반환
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
        }

        return Collections.emptyList(); //추천을 못 받아도 null이 아닌 비어있는 리스트를 반환

    }

}
