package com.example.hospital.repository;

import com.example.hospital.entity.PatientRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PatientRegistrationRepository extends JpaRepository<PatientRegistration, Long> {

    // Hitung jumlah pendaftaran per dokter per hari
    @Query("SELECT COUNT(pr) FROM PatientRegistration pr WHERE pr.doctor.id = :doctorId AND pr.appointmentDate = :date AND pr.status = 'ACTIVE'")
    Long countByDoctorAndDate(@Param("doctorId") Long doctorId, @Param("date") LocalDate date);

    // Cek apakah pasien sudah mendaftar ke dokter tertentu dalam 1 minggu
    @Query("SELECT COUNT(pr) FROM PatientRegistration pr WHERE pr.doctor.id = :doctorId AND pr.patientPhone = :patientPhone AND pr.appointmentDate BETWEEN :startDate AND :endDate AND pr.status = 'ACTIVE'")
    Long countByDoctorAndPatientInWeek(@Param("doctorId") Long doctorId, @Param("patientPhone") String patientPhone,
            @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    // Ambil semua pendaftaran aktif per dokter per hari
    List<PatientRegistration> findByDoctorIdAndAppointmentDateAndStatus(Long doctorId, LocalDate appointmentDate,
            String status);

    // Ambil pendaftaran per dokter
    List<PatientRegistration> findByDoctorIdOrderByAppointmentDateDesc(Long doctorId);
}
