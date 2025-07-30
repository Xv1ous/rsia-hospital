-- Migration untuk sistem pembatasan pendaftaran

-- Menambahkan kolom baru ke tabel doctor
ALTER TABLE doctor
ADD COLUMN max_patients_per_day INT DEFAULT 30,
ADD COLUMN is_locked BOOLEAN DEFAULT FALSE,
ADD COLUMN lock_reason VARCHAR(255),
ADD COLUMN lock_start_date VARCHAR(20),
ADD COLUMN lock_end_date VARCHAR(20);

-- Membuat tabel patient_registration
CREATE TABLE patient_registration (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    doctor_id BIGINT NOT NULL,
    patient_name VARCHAR(255) NOT NULL,
    patient_phone VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL,
    appointment_date DATE NOT NULL,
    registration_time VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    notes TEXT,
    FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

-- Membuat index untuk optimasi query
CREATE INDEX idx_registration_doctor_date ON patient_registration(doctor_id, appointment_date);
CREATE INDEX idx_registration_patient_phone ON patient_registration(patient_phone);
CREATE INDEX idx_registration_status ON patient_registration(status);
