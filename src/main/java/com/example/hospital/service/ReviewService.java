package com.example.hospital.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.hospital.entity.Review;
import com.example.hospital.repository.ReviewRepository;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd MMM yyyy");
    private static final DateTimeFormatter DATE_FULL_FORMATTER = DateTimeFormatter.ofPattern("dd MMMM yyyy");

    public List<Review> getHighRatingReviews() {
        List<Review> reviews = reviewRepository.findApprovedHighRatingReviews();

        // If no reviews, return sample data
        if (reviews.isEmpty()) {
            return getSampleReviews();
        }

        return reviews.stream()
                .limit(6) // Limit to 6 reviews
                .toList();
    }

    public List<Review> getAllApprovedReviews() {
        List<Review> reviews = reviewRepository.findAllApprovedReviews();

        // If no reviews, return sample data
        if (reviews.isEmpty()) {
            return getSampleReviews();
        }

        return reviews;
    }

    public Review saveReview(Review review) {
        review.setCreatedAt(LocalDateTime.now());
        review.setIsApproved(false); // Need admin approval
        review.setIsVerified(false);
        return reviewRepository.save(review);
    }

    public Long getTotalReviews() {
        return reviewRepository.countApprovedReviews();
    }

    public Double getAverageRating() {
        Double avgRating = reviewRepository.getAverageRating();
        return avgRating != null ? avgRating : 4.8; // Default if no reviews
    }

    // Helper method untuk format tanggal
    public String formatDate(LocalDateTime date) {
        if (date == null) return "";
        return date.format(DATE_FORMATTER);
    }

    // Helper method untuk format tanggal lengkap
    public String formatDateFull(LocalDateTime date) {
        if (date == null) return "";
        return date.format(DATE_FULL_FORMATTER);
    }

    private List<Review> getSampleReviews() {
        List<Review> sampleReviews = new java.util.ArrayList<>();

        Review review1 = new Review();
        review1.setAuthorName("Sarah Johnson");
        review1.setRating(5);
        review1.setComment("Pelayanan sangat ramah dan profesional. Dokter sangat teliti dalam mendiagnosis dan memberikan penjelasan yang mudah dipahami. Anak saya merasa nyaman selama pemeriksaan.");
        review1.setPatientType("ibu_anak");
        review1.setCreatedAt(LocalDateTime.now().minusDays(5));
        review1.setIsVerified(true);
        review1.setIsApproved(true);
        sampleReviews.add(review1);

        Review review2 = new Review();
        review2.setAuthorName("Ahmad Rahman");
        review2.setRating(5);
        review2.setComment("Fasilitas sangat modern dan bersih. Proses pendaftaran cepat dan mudah. Dokter sangat sabar dan teliti dalam memberikan penjelasan.");
        review2.setPatientType("rawat_jalan");
        review2.setCreatedAt(LocalDateTime.now().minusDays(10));
        review2.setIsVerified(true);
        review2.setIsApproved(true);
        sampleReviews.add(review2);

        Review review3 = new Review();
        review3.setAuthorName("Dewi Sari");
        review3.setRating(5);
        review3.setComment("Dokter sangat sabar dan teliti. Anak saya merasa nyaman selama pemeriksaan. Terima kasih atas pelayanan yang luar biasa.");
        review3.setPatientType("ibu_anak");
        review3.setCreatedAt(LocalDateTime.now().minusDays(15));
        review3.setIsVerified(true);
        review3.setIsApproved(true);
        sampleReviews.add(review3);

        Review review4 = new Review();
        review4.setAuthorName("Budi Santoso");
        review4.setRating(4);
        review4.setComment("Pelayanan bagus, dokter ramah dan profesional. Hanya perlu perbaikan pada sistem antrian yang kadang lama.");
        review4.setPatientType("rawat_jalan");
        review4.setCreatedAt(LocalDateTime.now().minusDays(20));
        review4.setIsVerified(true);
        review4.setIsApproved(true);
        sampleReviews.add(review4);

        Review review5 = new Review();
        review5.setAuthorName("Maya Indah");
        review5.setRating(5);
        review5.setComment("Sangat puas dengan pelayanan rawat inap. Perawat sangat perhatian dan dokter selalu mengontrol kondisi pasien.");
        review5.setPatientType("rawat_inap");
        review5.setCreatedAt(LocalDateTime.now().minusDays(25));
        review5.setIsVerified(true);
        review5.setIsApproved(true);
        sampleReviews.add(review5);

        Review review6 = new Review();
        review6.setAuthorName("Rudi Hermawan");
        review6.setRating(5);
        review6.setComment("Fasilitas lengkap dan modern. Dokter spesialis sangat kompeten. Sangat merekomendasikan untuk keluarga.");
        review6.setPatientType("rawat_jalan");
        review6.setCreatedAt(LocalDateTime.now().minusDays(30));
        review6.setIsVerified(true);
        review6.setIsApproved(true);
        sampleReviews.add(review6);

        return sampleReviews;
    }
}
