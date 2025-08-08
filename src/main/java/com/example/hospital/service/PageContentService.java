package com.example.hospital.service;

import com.example.hospital.entity.PageContent;
import com.example.hospital.repository.PageContentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class PageContentService {

    @Autowired
    private PageContentRepository pageContentRepository;

    public List<PageContent> getAllContents() {
        return pageContentRepository.findAll();
    }

    public List<PageContent> getContentsByPageType(PageContent.PageType pageType) {
        return pageContentRepository.findByPageTypeAndIsActiveTrueOrderBySortOrderAsc(pageType);
    }

    public List<PageContent> getAllContentsByPageType(PageContent.PageType pageType) {
        return pageContentRepository.findByPageTypeOrderBySortOrderAsc(pageType);
    }

    public Optional<PageContent> getContentById(Long id) {
        return pageContentRepository.findById(id);
    }

    public PageContent saveContent(PageContent content) {
        return pageContentRepository.save(content);
    }

    public void deleteContent(Long id) {
        pageContentRepository.deleteById(id);
    }

    public List<PageContent> getActiveContents() {
        return pageContentRepository.findByIsActiveTrueOrderBySortOrderAsc();
    }
}
