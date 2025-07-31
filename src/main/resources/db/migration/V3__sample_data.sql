-- Sample data for Hospital Management System
-- This file contains comprehensive sample data for testing and demonstration

-- Clear existing data (except users)
DELETE FROM appointments;
DELETE FROM news;
DELETE FROM services;
DELETE FROM doctor_schedule;
DELETE FROM doctor;

-- Insert real doctor schedules from jadwal_clean.sql
INSERT INTO doctor_schedule(hospital, name, day, time, specialization) VALUES
('Rumah Sakit Buah Hati Pamulang', 'dr. Irwan Eka Putra, Sp.OG', 'Senin', '14:00-17:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Irwan Eka Putra, Sp.OG', 'Minggu', '09:00-12:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Medissa Diantika, Sp.OG', 'Selasa', '14:00-16:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Medissa Diantika, Sp.OG', 'Jumat', '13:00-15:30', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Senin', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Selasa', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Kamis', '15:00-18:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Jumat', '16:00-18:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. E. Rohati, Sp.OG', 'Sabtu', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Senin', '19:30-21:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Selasa', '18:00-Selesai', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Rabu', '13:00-17:30', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Kamis', '10:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Jumat', '09:00-13:00', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Jumat', '18:00-Selesai', 'Spesialis Kebidanan & Kandungan'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ismail Yahya, Sp.OG', 'Sabtu', '18:00-Selesai', 'Spesialis Kebidanan & Kandungan'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Aditya Suryansyah, Sp.A (K)', 'Senin', '19:00-21:00', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Aditya Suryansyah, Sp.A (K)', 'Rabu', '19:00-21:00', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Aditya Suryansyah, Sp.A (K)', 'Jumat', '16:30-19:00', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Aditya Suryansyah, Sp.A (K)', 'Sabtu', '09:00-13:00', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Senin', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Selasa', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Rabu', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Kamis', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ellya Marliah, Sp.A', 'Jumat', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Endang Triningsih, Sp.A (K)', 'Selasa', '09:00-10:30', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Endang Triningsih, Sp.A (K)', 'Rabu', '17:00-19:00', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Endang Triningsih, Sp.A (K)', 'Kamis', '09:00-10:30', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Endang Triningsih, Sp.A (K)', 'Jumat', '09:00-10:30', 'Subspesialis Endokrinologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fajar Subroto, Sp.A (K)', 'Senin', '17:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fajar Subroto, Sp.A (K)', 'Selasa', '18:30-21:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fajar Subroto, Sp.A (K)', 'Kamis', '18:30-21:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fajar Subroto, Sp.A (K)', 'Jumat', '20:00-22:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fajar Subroto, Sp.A (K)', 'Sabtu', '18:30-21:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Firmansyah Chatab, Sp.A', 'Senin', '09:00-11:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Firmansyah Chatab, Sp.A', 'Selasa', '20:00-Selesai', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Firmansyah Chatab, Sp.A', 'Rabu', '09:00-11:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Firmansyah Chatab, Sp.A', 'Kamis', '20:00-Selesai', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Firmansyah Chatab, Sp.A', 'Jumat', '20:00-Selesai', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Senin', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Selasa', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Rabu', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Kamis', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Jumat', '12:00-19:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Sabtu', '12:00-16:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, Sp.A', 'Minggu', '10:00-13:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Labiqotullababah Ahasmi, Sp.A', 'Selasa', '11:00-15:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Labiqotullababah Ahasmi, Sp.A', 'Rabu', '12:00-14:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Labiqotullababah Ahasmi, Sp.A', 'Kamis', '11:00-15:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Labiqotullababah Ahasmi, Sp.A', 'Sabtu', '09:00-12:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fitriyani, Sp.A', 'Senin', '11:00-14:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fitriyani, Sp.A', 'Selasa', '18:30-20:30', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fitriyani, Sp.A', 'Kamis', '18:30-20:30', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fitriyani, Sp.A', 'Sabtu', '10:00-13:00', 'Spesialis Anak'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Fitriyani, Sp.A', 'Minggu', '08:00-10:00', 'Spesialis Anak'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Sandhi Ari Susanti Sp.THT-KL', 'Senin', '13.00 - 15.00', 'Spesialis THT'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sandhi Ari Susanti Sp.THT-KL', 'Kamis', '15.00 - 17.00', 'Spesialis THT'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sandhi Ari Susanti Sp.THT-KL', 'Sabtu', '12.00 - 15.00', 'Spesialis THT'),

('Rumah Sakit Buah Hati Pamulang', 'dr. M. Reza Jauhari Zen, Sp.B', 'Rabu', '14.00 - 17.00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS ', 'Senin', '12.00 - 14.00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS ', 'Selasa', '19.00 - 21.00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS ', 'Rabu', '12.00 - 14.00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS ', 'Kamis', '19.00 - 21.00', 'Spesialis Bedah'),
('Rumah Sakit Buah Hati Pamulang', 'dr. R. Diky Laksmana, Sp.B,FICS ', 'Jumat', '19.00 - 21.00', 'Spesialis Bedah'),

('Rumah Sakit Buah Hati Pamulang', 'drg. Bono Widiastuti, Sp. KGA', 'Rabu', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Bono Widiastuti, Sp. KGA', 'Jumat', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Rini Triani, Sp. KGA', 'Selasa', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Rini Triani, Sp. KGA', 'Kamis', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Murni', 'Senin', '16:00-19:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Murni', 'Sabtu', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Nastiti Rahajeng', 'Selasa', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Nastiti Rahajeng', 'Jumat', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Riani Apsari', 'Rabu', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Riani Apsari', 'Jumat', '17:00-20:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Cicilia Triana', 'Senin', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Cicilia Triana', 'Kamis', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Cicilia Triana', 'Jumat', '09:00-12:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Syleovina Rizkita Sari', 'Rabu', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Syleovina Rizkita Sari', 'Kamis', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Laksmi Kusumaningtyas', 'Selasa', '13:00-16:00', 'Dokter Gigi'),
('Rumah Sakit Buah Hati Pamulang', 'drg. Laksmi Kusumaningtyas', 'Minggu', '09:00-12:00', 'Dokter Gigi'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Senin', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Selasa', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Rabu', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Kamis', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sekar Asmara Jayaning Diah', 'Jumat', '08:00-12:00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Senin', '12.00-16.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Selasa', '12.00-16.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Rabu', '12.00-16.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Kamis', '12.00-16.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Jumat', '12.00-16.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Selasa', '18.00-20.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Rabu', '18.00-20.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Kamis', '18.00-20.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Reza Hafiyyan', 'Sabtu', '08.00-16.00', 'Dokter Umum'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Reza Hafiyyan', 'Minggu', '08.00-16.00', 'Dokter Umum'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Shella Riana ', 'Selasa', '09.00-12.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Shella Riana ', 'Kamis', '09.00-12.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Shella Riana ', 'Sabtu', '09.00-12.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sarah Kamilah', 'Senin', '09.00-12.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sarah Kamilah', 'Rabu', '09.00-12.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, SpA ', 'Senin', '12.00-19.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, SpA ', 'Selasa', '16.00-19.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, SpA ', 'Rabu', '12.00-19.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, SpA ', 'Kamis', '16.00-19.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, SpA ', 'Jumat', '12.00-19.00', 'Poli Laktasi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hetty Wati Napitupulu, SpA ', 'Sabtu', '12.00-16.00', 'Poli Laktasi'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Sri Dewi Imayanti, Sp.Rad ', 'Sabtu', '08.00-10.00', 'Radiologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sri Dewi Imayanti, Sp.Rad ', 'Sabtu', '08.00-10.00', 'Radiologi'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Sri Dewi Imayanti, Sp.Rad ', 'Sabtu', '08.00-10.00', 'Radiologi'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Ryandri Yovanda, Sp.PD', 'Senin', '09.00-11.00', 'Spesialis Penyakit Dalam'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ryandri Yovanda, Sp.PD', 'Selasa', '19.00-21.00', 'Spesialis Penyakit Dalam'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ryandri Yovanda, Sp.PD', 'Kamis', '09.00-11.00', 'Spesialis Penyakit Dalam'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ryandri Yovanda, Sp.PD', 'Jumat', '15.00-17.00', 'Spesialis Penyakit Dalam'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Radia Puri', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Nabila Maudy Salma', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Amalina Fitrasari', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Taqiyya Maryam', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Ning Indah Permatasari', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Saflan Ady Saputra', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Reza Hafiyyan', 'Setiap Hari', '24 Jam', 'Dokter IGD'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Khusnul Khotimah', 'Setiap Hari', '24 Jam', 'Dokter IGD'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Hikmah Amayanti Adil, Sp.KFR', 'Rabu', '15:00-17:00', 'Spesialis Rehabilitasi Medik'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hikmah Amayanti Adil, Sp.KFR', 'Jumat', '09:00-12:00', 'Spesialis Rehabilitasi Medik'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Hikmah Amayanti Adil, Sp.KFR', 'Sabtu', '15:00-17:00', 'Spesialis Rehabilitasi Medik'),

('Rumah Sakit Buah Hati Pamulang', 'dr. Rika Ilham Munazat, Sp.An', 'Senin', '16:00-17:00', 'Poliklinik Nyeri'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Rika Ilham Munazat, Sp.An', 'Rabu', '16:00-17:00', 'Poliklinik Nyeri'),
('Rumah Sakit Buah Hati Pamulang', 'dr. Rika Ilham Munazat, Sp.An', 'Jumat', '16:00-17:00', 'Poliklinik Nyeri'),

('Rumah Sakit Buah Hati Pamulang', 'Susilawaty, SST.Ft', 'Senin', '10:00-17:00', 'Tumbuh Kembang'),
('Rumah Sakit Buah Hati Pamulang', 'Susilawaty, SST.Ft', 'Selasa', '10:00-17:00', 'Tumbuh Kembang'),
('Rumah Sakit Buah Hati Pamulang', 'Susilawaty, SST.Ft', 'Rabu', '10:00-17:00', 'Tumbuh Kembang'),
('Rumah Sakit Buah Hati Pamulang', 'Susilawaty, SST.Ft', 'Kamis', '10:00-17:00', 'Tumbuh Kembang'),
('Rumah Sakit Buah Hati Pamulang', 'Susilawaty, SST.Ft', 'Jumat', '10:00-17:00', 'Tumbuh Kembang'),
('Rumah Sakit Buah Hati Pamulang', 'Susilawaty, SST.Ft', 'Sabtu', '10:00-17:00', 'Tumbuh Kembang');

-- Insert basic doctor data from schedule data
INSERT INTO doctor (name, specialization)
SELECT DISTINCT name, specialization FROM doctor_schedule;

-- Insert sample services
INSERT INTO services (name, description, icon) VALUES
('Konsultasi Umum', 'Layanan konsultasi kesehatan umum dengan dokter spesialis', 'fa-user-md'),
('Pemeriksaan Laboratorium', 'Tes darah, urin, dan pemeriksaan laboratorium lainnya', 'fa-flask'),
('Radiologi', 'X-Ray, CT Scan, MRI, dan pemeriksaan radiologi lainnya', 'fa-x-ray'),
('Farmasi', 'Layanan apotek dan konsultasi obat', 'fa-pills'),
('Gawat Darurat', 'Layanan gawat darurat 24 jam', 'fa-ambulance'),
('Rawat Inap', 'Layanan rawat inap dengan fasilitas lengkap', 'fa-bed'),
('Fisioterapi', 'Layanan fisioterapi dan rehabilitasi', 'fa-walking'),
('Konsultasi Gizi', 'Konsultasi nutrisi dan diet', 'fa-apple-alt'),
('Vaksinasi', 'Layanan vaksinasi untuk anak dan dewasa', 'fa-syringe'),
('Kesehatan Gigi', 'Layanan kesehatan gigi dan mulut', 'fa-tooth');

-- Insert sample news
INSERT INTO news (title, content, image_url, published_at) VALUES
('RSIA Buah Hati Pamulang Buka Layanan Vaksinasi COVID-19', 'RSIA Buah Hati Pamulang kini menyediakan layanan vaksinasi COVID-19 untuk masyarakat umum. Vaksinasi tersedia setiap hari kerja dengan jadwal yang dapat diatur melalui aplikasi atau telepon.', 'news-covid-vaccine.jpg', '2024-01-15 10:00:00'),
('Tips Menjaga Kesehatan Jantung di Usia Muda', 'Dokter kardiologi kami memberikan tips penting untuk menjaga kesehatan jantung sejak usia muda. Mulai dari pola makan hingga olahraga yang tepat.', 'news-heart-health.jpg', '2024-01-20 14:30:00'),
('Pelayanan 24 Jam untuk Gawat Darurat', 'RSIA Buah Hati Pamulang memberikan pelayanan gawat darurat 24 jam dengan tim dokter dan perawat yang siap sedia melayani pasien.', 'news-emergency.jpg', '2024-01-25 09:15:00'),
('Program Skrining Kesehatan Gratis', 'Dalam rangka memperingati Hari Kesehatan Nasional, RSIA Buah Hati Pamulang menyelenggarakan program skrining kesehatan gratis untuk masyarakat.', 'news-screening.jpg', '2024-02-01 11:45:00'),
('Teknologi Terbaru untuk Diagnosis Penyakit', 'RSIA Buah Hati Pamulang telah mengadopsi teknologi terbaru untuk diagnosis penyakit yang lebih akurat dan cepat.', 'news-technology.jpg', '2024-02-05 16:20:00'),
('Konsultasi Online dengan Dokter Spesialis', 'Nikmati kemudahan konsultasi online dengan dokter spesialis kami tanpa perlu datang ke rumah sakit.', 'news-online-consultation.jpg', '2024-02-10 13:00:00'),
('Program Vaksinasi Anak Terlengkap', 'RSIA Buah Hati Pamulang menyediakan program vaksinasi anak terlengkap sesuai dengan jadwal imunisasi yang direkomendasikan IDAI.', 'news-child-vaccine.jpg', '2024-02-15 10:30:00'),
('Layanan Fisioterapi untuk Pemulihan', 'Tim fisioterapi kami siap membantu pemulihan pasien pasca operasi atau cedera dengan program terapi yang disesuaikan.', 'news-physiotherapy.jpg', '2024-02-20 15:45:00'),
('Konsultasi Gizi untuk Diet Sehat', 'Dapatkan konsultasi gizi dari ahli gizi kami untuk program diet sehat yang sesuai dengan kondisi kesehatan Anda.', 'news-nutrition.jpg', '2024-02-25 12:15:00'),
('Pelayanan Kesehatan Gigi Modern', 'Klinik gigi RSIA Buah Hati Pamulang dilengkapi dengan peralatan modern untuk pelayanan kesehatan gigi yang optimal.', 'news-dental.jpg', '2024-03-01 14:00:00');

-- Insert sample appointments
INSERT INTO appointments (patient_name, patient_phone, doctor_id, department, appointment_date, appointment_time, status, notes) VALUES
('Budi Santoso', '081234567890', 1, 'Spesialis Kebidanan & Kandungan', '2024-03-15', '09:00:00', 'Dikonfirmasi', 'Kontrol kehamilan'),
('Siti Nurhaliza', '081234567891', 3, 'Spesialis Anak', '2024-03-16', '10:30:00', 'Menunggu', 'Imunisasi anak usia 2 tahun'),
('Ahmad Rizki', '081234567892', 2, 'Subspesialis Endokrinologi', '2024-03-17', '14:00:00', 'Dikonfirmasi', 'Konsultasi diabetes'),
('Dewi Sartika', '081234567893', 5, 'Dokter Gigi', '2024-03-18', '11:00:00', 'Menunggu', 'Pemeriksaan gigi'),
('Rudi Hermawan', '081234567894', 4, 'Spesialis Bedah', '2024-03-19', '15:30:00', 'Dikonfirmasi', 'Kontrol pasca operasi'),
('Nina Kartika', '081234567895', 6, 'Spesialis Kebidanan & Kandungan', '2024-03-20', '08:30:00', 'Menunggu', 'Pemeriksaan kehamilan'),
('Hendra Gunawan', '081234567896', 7, 'Spesialis Penyakit Dalam', '2024-03-21', '13:00:00', 'Dikonfirmasi', 'Kontrol rutin'),
('Maya Indah', '081234567897', 8, 'Poli Laktasi', '2024-03-22', '16:00:00', 'Menunggu', 'Konsultasi ASI'),
('Bambang Sutejo', '081234567898', 9, 'Radiologi', '2024-03-23', '09:30:00', 'Dikonfirmasi', 'CT Scan kepala'),
('Ratna Sari', '081234567899', 10, 'Dokter Umum', '2024-03-24', '12:00:00', 'Menunggu', 'Konsultasi umum');

-- Update admin password to the provided encrypted value
UPDATE users SET password='$2a$12$lLKRwSUbB7NQOOr6pL.ysO7c1sss.9qpZYIi2Tpigo.Z6GsjNYuL.' WHERE username='admin';
