package com.example.hospital.repository;

import com.example.hospital.entity.PageContent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PageContentRepository extends JpaRepository<PageContent, Long> {
    List<PageContent> findByPageTypeAndIsActiveTrueOrderBySortOrderAsc(PageContent.PageType pageType);

    List<PageContent> findByPageTypeOrderBySortOrderAsc(PageContent.PageType pageType);

    List<PageContent> findByIsActiveTrueOrderBySortOrderAsc();
}
