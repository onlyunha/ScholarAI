package dankook.capstone.repository;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAQueryFactory;
import dankook.capstone.domain.FinancialAidType;
import dankook.capstone.domain.QScholarship;
import dankook.capstone.domain.Scholarship;
import dankook.capstone.dto.request.ScholarshipSearchCondition;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ScholarshipRepositoryImpl implements ScholarshipRepositoryCustom{

    private final JPAQueryFactory queryFactory;

    //통합
    @Override
    public Page<Scholarship> searchScholarships(ScholarshipSearchCondition condition, Pageable pageable) {
        QScholarship s = QScholarship.scholarship;
        BooleanBuilder builder = new BooleanBuilder(); //빌더 객체

        //키워드(운영기관명 또는 상품명)
        if(condition.getKeyword() != null && !condition.getKeyword().isBlank()){
            builder.and(
                    //운영기관명 또는 상품명 중 하나라도 포함하면 결과에 포함
                    s.organizationName.containsIgnoreCase(condition.getKeyword()) //대소문자 구문 없이 keyword 포함 여부 확인
                            .or(s.productName.containsIgnoreCase(condition.getKeyword()))
            );
        }

        //학자금유형구분 필터
        if (condition.getTypes() != null && !condition.getTypes().isEmpty()) {
            List<String> labels = condition.getTypes().stream()
                    .map(FinancialAidType::getLabel)
                    .toList();

            builder.and(s.financialAidType.in(labels)); //equals
        }

        LocalDate today = LocalDate.now();
        boolean onlyRecruiting = condition.isOnlyRecruiting(); //사용자가 '모집중인 장학금 보기'를 선택
        boolean onlyUpcoming = condition.isOnlyUpcoming(); //사용자가 '모집예정 장학금 보기'를 선택

        if (onlyRecruiting && onlyUpcoming) {
            // 모집중 + 모집예정
            builder.and(
                    s.applicationStartDate.loe(today)
                            .and(s.applicationEndDate.goe(today)) //모집중
                            .or(s.applicationStartDate.gt(today)) //모집예정                             // 모집예정
            );
        } else if (onlyRecruiting) {
            // 모집중만
            builder.and(s.applicationStartDate.loe(today) //모집시작일<=오늘
                    .and(s.applicationEndDate.goe(today))); //모집종료일>=오늘
        } else if (onlyUpcoming) {
            // 모집예정만
            builder.and(s.applicationStartDate.gt(today)); //모집 시작일>오늘
        }

//        //현재 모집중인 장학금
//        if (condition.isOnlyRecruiting()) { //사용자가 '모집중인 장학금 보기'를 선택
//            LocalDate today = LocalDate.now();
//            builder.and(s.applicationStartDate.loe(today)) //모집시작일<=오늘
//                    .and(s.applicationEndDate.goe(today)); //모집종료일>=오늘
//        }

        // 페이징 쿼리
        List<Scholarship> content = queryFactory
                .selectFrom(s)
                .where(builder)
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        // 전체 개수
        Long total = queryFactory
                .select(s.count())
                .from(s)
                .where(builder)
                .fetchOne();

        long totalCount = total != null ? total : 0L;

        return new PageImpl<>(content, pageable, totalCount);
    }
}
