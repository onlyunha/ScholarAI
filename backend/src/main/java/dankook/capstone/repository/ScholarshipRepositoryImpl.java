package dankook.capstone.repository;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import dankook.capstone.domain.QScholarship;
import dankook.capstone.domain.Scholarship;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class ScholarshipRepositoryImpl implements ScholarshipRepositoryCustom{

    private final JPAQueryFactory queryFactory;

    @Override
    public List<Scholarship> searchScholarships(String keyword) {
        QScholarship s = QScholarship.scholarship;

        BooleanBuilder builder = new BooleanBuilder(); //빌더 객체

        if(keyword != null && !keyword.isBlank()){
            builder.and(
                    //운영기관명 또는 상품명 중 하나라도 포함하면 결과에 포함
                    s.organizationName.containsIgnoreCase(keyword) //대소문자 구문 없이 keyword 포함 여부 확인
                            .or(s.productName.containsIgnoreCase(keyword))
            );
        }

        return queryFactory
                .selectFrom(s)
                .where(builder)
                .fetch(); //List로 가져오기
    }
}
