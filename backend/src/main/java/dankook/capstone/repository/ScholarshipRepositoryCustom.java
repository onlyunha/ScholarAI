package dankook.capstone.repository;

import dankook.capstone.domain.Scholarship;

import java.util.List;

public interface ScholarshipRepositoryCustom {
    List<Scholarship> searchScholarships(String keyword);
}
