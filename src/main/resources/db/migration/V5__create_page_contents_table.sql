CREATE TABLE page_contents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    page_type VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon_svg TEXT,
    category VARCHAR(100),
    price VARCHAR(100),
    original_price VARCHAR(100),
    features TEXT,
    image_url VARCHAR(500),
    sort_order INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data for facilities
INSERT INTO page_contents (page_type, title, description, category, price, original_price, features, sort_order, is_active) VALUES
('FACILITIES', 'Paket Check Up Lengkap', 'Hemat 30% untuk pemeriksaan kesehatan lengkap termasuk laboratorium', 'PROMO TERBATAS', 'Rp 350.000', 'Rp 500.000', '• Pemeriksaan fisik lengkap<br>• Tes laboratorium darah<br>• Pemeriksaan urine<br>• Konsultasi dokter', 1, TRUE),
('FACILITIES', 'Layanan Home Care', 'Perawatan kesehatan di rumah dengan tenaga medis profesional', 'NEW ARRIVAL', 'Mulai Rp 200.000', NULL, '• Tersedia 24/7<br>• Tenaga medis profesional<br>• Perawatan di rumah', 2, TRUE),
('FACILITIES', 'Paket Keluarga Sehat', 'Check up untuk 4 anggota keluarga + konsultasi dokter gratis', 'BUNDLE OFFER', 'Rp 800.000', 'Rp 1.200.000', '• Check up untuk 4 orang<br>• Konsultasi dokter gratis<br>• Hemat Rp 400.000', 3, TRUE);

-- Insert sample data for services
INSERT INTO page_contents (page_type, title, description, category, price, sort_order, is_active) VALUES
('SERVICES', 'IGD 24 Jam', 'Layanan gawat darurat siap 24 jam untuk kebutuhan mendesak', 'Darurat', 'Gratis', 1, TRUE),
('SERVICES', 'Rawat Inap', 'Fasilitas kamar nyaman untuk perawatan intensif dan pemulihan', 'Inap', 'Mulai Rp 500.000/hari', 2, TRUE),
('SERVICES', 'Rawat Jalan', 'Konsultasi dan perawatan tanpa harus menginap di rumah sakit', 'Jalan', 'Mulai Rp 150.000', 3, TRUE),
('SERVICES', 'Laboratorium', 'Pemeriksaan laboratorium lengkap dan akurat', 'Lab', 'Mulai Rp 100.000', 4, TRUE),
('SERVICES', 'USG & Radiologi', 'Layanan USG, rontgen, dan radiologi modern', 'Radiologi', 'Mulai Rp 200.000', 5, TRUE),
('SERVICES', 'Apotek', 'Apotek lengkap dengan obat-obatan berkualitas', 'Apotek', 'Tersedia', 6, TRUE),
('SERVICES', 'Vaksinasi', 'Layanan vaksinasi untuk anak dan dewasa', 'Vaksin', 'Mulai Rp 50.000', 7, TRUE),
('SERVICES', 'Konsultasi Online', 'Konsultasi dokter secara online, mudah dan praktis', 'Online', 'Mulai Rp 100.000', 8, TRUE);

-- Insert sample data for homecare
INSERT INTO page_contents (page_type, title, description, category, price, features, sort_order, is_active) VALUES
('HOMECARE', 'Perawatan Keperawatan', 'Perawatan luka, pemasangan infus, dan monitoring tanda vital', 'Nursing', 'Mulai Rp 150.000', '• Perawatan luka pasca operasi<br>• Pemasangan dan monitoring infus<br>• Pengukuran tekanan darah<br>• Perawatan kateter', 1, TRUE),
('HOMECARE', 'Kunjungan Dokter', 'Konsultasi dan pemeriksaan langsung oleh dokter spesialis', 'Doctor', 'Mulai Rp 300.000', '• Konsultasi kesehatan<br>• Pemeriksaan fisik<br>• Evaluasi pengobatan<br>• Resep obat', 2, TRUE),
('HOMECARE', 'Fisioterapi', 'Terapi fisik untuk pemulihan dan rehabilitasi', 'Physio', 'Mulai Rp 250.000', '• Terapi pasca stroke<br>• Rehabilitasi pasca operasi<br>• Terapi nyeri sendi<br>• Latihan pernapasan', 3, TRUE),
('HOMECARE', 'Perawatan Bayi', 'Perawatan khusus untuk bayi dan balita', 'Baby', 'Mulai Rp 200.000', '• Perawatan tali pusat<br>• Pijat bayi<br>• Konsultasi ASI<br>• Monitoring tumbuh kembang', 4, TRUE),
('HOMECARE', 'Perawatan Lansia', 'Perawatan khusus untuk lansia dan penderita demensia', 'Elderly', 'Mulai Rp 500.000', '• Pendampingan 24 jam<br>• Bantuan aktivitas harian<br>• Monitoring kesehatan<br>• Terapi kognitif', 5, TRUE),
('HOMECARE', 'Penyewaan Alat', 'Penyewaan alat medis untuk perawatan di rumah', 'Equipment', 'Mulai Rp 100.000', '• Oxygen concentrator<br>• Nebulizer<br>• Tensi meter<br>• Kursi roda', 6, TRUE);
