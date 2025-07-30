package com.example.hospital.service;

import com.example.hospital.entity.Doctor;
import com.example.hospital.entity.PatientRegistration;
import com.example.hospital.repository.DoctorRepository;
import com.example.hospital.repository.PatientRegistrationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Service
public class RegistrationService {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PatientRegistrationRepository patientRegistrationRepository;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Validasi pendaftaran berdasarkan 3 aturan:
     * 1. Dokter tidak sedang cuti
     * 2. Pasien belum mendaftar ke dokter yang sama dalam 1 minggu
     * 3. Dokter belum mencapai batas maksimal 30 pasien per hari
     */
    public Map<String, Object> validateRegistration(Long doctorId, String patientPhone, LocalDate appointmentDate) {
        Map<String, Object> result = new HashMap<>();
        result.put("valid", true);
        result.put("message", "Pendaftaran valid");

        Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
        if (doctor == null) {
            result.put("valid", false);
            result.put("message", "Dokter tidak ditemukan");
            return result;
        }

        // 1. Cek apakah dokter sedang cuti
        if (Boolean.TRUE.equals(doctor.getIsOnLeave())) {
            result.put("valid", false);
            result.put("message", "Dokter sedang cuti: " + doctor.getLeaveReason());
            result.put("type", "CUTI");
            return result;
        }

        // 2. Cek apakah dokter sedang dikunci
        if (Boolean.TRUE.equals(doctor.getIsLocked())) {
            result.put("valid", false);
            result.put("message", "Dokter sedang dikunci: " + doctor.getLockReason());
            result.put("type", "LOCKED");
            return result;
        }

        // 3. Cek apakah pasien sudah mendaftar ke dokter yang sama dalam 1 minggu
        LocalDate weekStart = appointmentDate.minusDays(7);
        LocalDate weekEnd = appointmentDate.plusDays(7);

        Long existingRegistrations = patientRegistrationRepository.countByDoctorAndPatientInWeek(
                doctorId, patientPhone, weekStart, weekEnd);

        if (existingRegistrations > 0) {
            result.put("valid", false);
            result.put("message",
                    "Anda sudah mendaftar ke dokter ini dalam 1 minggu terakhir. Silakan tunggu 1 minggu untuk mendaftar kembali.");
            result.put("type", "DOUBLE_BOOKING");
            return result;
        }

        // 4. Cek apakah dokter sudah mencapai batas maksimal 30 pasien per hari
        Long dailyRegistrations = patientRegistrationRepository.countByDoctorAndDate(doctorId, appointmentDate);
        if (dailyRegistrations >= doctor.getMaxPatientsPerDay()) {
            result.put("valid", false);
            result.put("message", "Dokter sudah mencapai batas maksimal " + doctor.getMaxPatientsPerDay()
                    + " pasien per hari. Silakan pilih tanggal lain.");
            result.put("type", "MAX_PATIENTS");
            return result;
        }

        return result;
    }

    /**
     * Mendaftarkan pasien baru
     */
    public Map<String, Object> registerPatient(Long doctorId, String patientName, String patientPhone,
            LocalDate appointmentDate, String registrationTime, String notes) {
        Map<String, Object> result = new HashMap<>();

        // Validasi pendaftaran
        Map<String, Object> validation = validateRegistration(doctorId, patientPhone, appointmentDate);
        if (!(Boolean) validation.get("valid")) {
            return validation;
        }

        try {
            Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
            if (doctor == null) {
                result.put("success", false);
                result.put("message", "Dokter tidak ditemukan");
                return result;
            }

            PatientRegistration registration = new PatientRegistration();
            registration.setDoctor(doctor);
            registration.setPatientName(patientName);
            registration.setPatientPhone(patientPhone);
            registration.setRegistrationDate(LocalDate.now());
            registration.setAppointmentDate(appointmentDate);
            registration.setRegistrationTime(registrationTime);
            registration.setNotes(notes);
            registration.setStatus("ACTIVE");

            patientRegistrationRepository.save(registration);

            result.put("success", true);
            result.put("message", "Pendaftaran berhasil! Nomor antrian: " + registration.getId());
            result.put("registrationId", registration.getId());

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Terjadi kesalahan: " + e.getMessage());
        }

        return result;
    }

    /**
     * Mendapatkan status dokter (tersedia, cuti, kunci, atau penuh)
     */
    public Map<String, Object> getDoctorStatus(Long doctorId, LocalDate date) {
        Map<String, Object> result = new HashMap<>();

        Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
        if (doctor == null) {
            result.put("status", "NOT_FOUND");
            result.put("message", "Dokter tidak ditemukan");
            return result;
        }

        // Cek cuti
        if (Boolean.TRUE.equals(doctor.getIsOnLeave())) {
            result.put("status", "ON_LEAVE");
            result.put("message", "Dokter sedang cuti: " + doctor.getLeaveReason());
            return result;
        }

        // Cek kunci
        if (Boolean.TRUE.equals(doctor.getIsLocked())) {
            result.put("status", "LOCKED");
            result.put("message", "Dokter sedang dikunci: " + doctor.getLockReason());
            return result;
        }

        // Cek kapasitas
        Long dailyRegistrations = patientRegistrationRepository.countByDoctorAndDate(doctorId, date);
        int remainingSlots = doctor.getMaxPatientsPerDay() - dailyRegistrations.intValue();

        if (remainingSlots <= 0) {
            result.put("status", "FULL");
            result.put("message", "Dokter sudah penuh untuk tanggal ini");
        } else {
            result.put("status", "AVAILABLE");
            result.put("message", "Tersedia " + remainingSlots + " slot");
            result.put("remainingSlots", remainingSlots);
        }

        result.put("totalSlots", doctor.getMaxPatientsPerDay());
        result.put("usedSlots", dailyRegistrations);

        return result;
    }

    /**
     * Mendapatkan daftar pendaftaran per dokter
     */
    public Map<String, Object> getDoctorRegistrations(Long doctorId) {
        Map<String, Object> result = new HashMap<>();

        try {
            Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
            if (doctor == null) {
                result.put("success", false);
                result.put("message", "Dokter tidak ditemukan");
                return result;
            }

            var registrations = patientRegistrationRepository.findByDoctorIdOrderByAppointmentDateDesc(doctorId);

            result.put("success", true);
            result.put("doctor", doctor);
            result.put("registrations", registrations);
            result.put("totalRegistrations", registrations.size());

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Terjadi kesalahan: " + e.getMessage());
        }

        return result;
    }
}
