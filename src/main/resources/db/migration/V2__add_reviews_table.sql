-- Create reviews table
CREATE TABLE reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL,
    author_email VARCHAR(255) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    patient_type VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    INDEX idx_rating (rating),
    INDEX idx_approved (is_approved),
    INDEX idx_created_at (created_at)
);

-- Insert sample reviews
INSERT INTO reviews (author_name, author_email, rating, comment, patient_type, created_at, is_verified, is_approved) VALUES
('Sarah Johnson', 'sarah@example.com', 5, 'Pelayanan sangat ramah dan profesional. Dokter sangat teliti dalam mendiagnosis dan memberikan penjelasan yang mudah dipahami. Anak saya merasa nyaman selama pemeriksaan.', 'ibu_anak', NOW() - INTERVAL 5 DAY, TRUE, TRUE),
('Ahmad Rahman', 'ahmad@example.com', 5, 'Fasilitas sangat modern dan bersih. Proses pendaftaran cepat dan mudah. Dokter sangat sabar dan teliti dalam memberikan penjelasan.', 'rawat_jalan', NOW() - INTERVAL 10 DAY, TRUE, TRUE),
('Dewi Sari', 'dewi@example.com', 5, 'Dokter sangat sabar dan teliti. Anak saya merasa nyaman selama pemeriksaan. Terima kasih atas pelayanan yang luar biasa.', 'ibu_anak', NOW() - INTERVAL 15 DAY, TRUE, TRUE),
('Budi Santoso', 'budi@example.com', 4, 'Pelayanan bagus, dokter ramah dan profesional. Hanya perlu perbaikan pada sistem antrian yang kadang lama.', 'rawat_jalan', NOW() - INTERVAL 20 DAY, TRUE, TRUE),
('Maya Indah', 'maya@example.com', 5, 'Sangat puas dengan pelayanan rawat inap. Perawat sangat perhatian dan dokter selalu mengontrol kondisi pasien.', 'rawat_inap', NOW() - INTERVAL 25 DAY, TRUE, TRUE),
('Rudi Hermawan', 'rudi@example.com', 5, 'Fasilitas lengkap dan modern. Dokter spesialis sangat kompeten. Sangat merekomendasikan untuk keluarga.', 'rawat_jalan', NOW() - INTERVAL 30 DAY, TRUE, TRUE);
