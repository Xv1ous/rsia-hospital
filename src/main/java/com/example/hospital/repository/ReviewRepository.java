package com.example.hospital.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.example.hospital.entity.Review;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    // Find approved reviews with rating >= 4
    @Query("SELECT r FROM Review r WHERE r.isApproved = true AND r.rating >= 4 ORDER BY r.rating DESC, r.createdAt DESC")
    List<Review> findApprovedHighRatingReviews();

    // Find all approved reviews
    @Query("SELECT r FROM Review r WHERE r.isApproved = true ORDER BY r.createdAt DESC")
    List<Review> findAllApprovedReviews();

    // Find reviews by patient type
    @Query("SELECT r FROM Review r WHERE r.isApproved = true AND r.patientType = ?1 ORDER BY r.createdAt DESC")
    List<Review> findApprovedReviewsByPatientType(String patientType);

    // Count total approved reviews
    @Query("SELECT COUNT(r) FROM Review r WHERE r.isApproved = true")
    Long countApprovedReviews();

    // Get average rating
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.isApproved = true")
    Double getAverageRating();
}
