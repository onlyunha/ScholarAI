package dankook.capstone.repository;

import dankook.capstone.domain.Scholarship;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScholarshipRepository extends JpaRepository<Scholarship, Long>, ScholarshipRepositoryCustom {
}
