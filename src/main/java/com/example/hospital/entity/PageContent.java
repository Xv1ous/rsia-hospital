package com.example.hospital.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "page_contents")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private PageType pageType;

    private String title;
    private String description;
    private String iconSvg;
    private String category;
    private String price;
    private String originalPrice;
    private String features;
    private String imageUrl;
    private Integer sortOrder;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum PageType {
        FACILITIES("fasilitas"),
        SERVICES("layanan"),
        HOMECARE("homecare");

        private final String displayName;

        PageType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
}
