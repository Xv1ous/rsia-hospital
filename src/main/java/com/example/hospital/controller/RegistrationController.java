package com.example.hospital.controller;

import com.example.hospital.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@RestController
@RequestMapping("/api/registration")
public class RegistrationController {

    @Autowired
    private RegistrationService registrationService;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Validasi pendaftaran
     */
    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateRegistration(
            @RequestParam Long doctorId,
            @RequestParam String patientPhone,
            @RequestParam String appointmentDate) {

        try {
            LocalDate date = LocalDate.parse(appointmentDate, DATE_FORMATTER);
            Map<String, Object> result = registrationService.validateRegistration(doctorId, patientPhone, date);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> error = Map.of(
                    "valid", false,
                    "message", "Format tanggal tidak valid. Gunakan format YYYY-MM-DD");
            return ResponseEntity.badRequest().body(error);
        }
    }

    /**
     * Mendaftarkan pasien baru
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> registerPatient(
            @RequestParam Long doctorId,
            @RequestParam String patientName,
            @RequestParam String patientPhone,
            @RequestParam String appointmentDate,
            @RequestParam String registrationTime,
            @RequestParam(required = false) String notes) {

        try {
            LocalDate date = LocalDate.parse(appointmentDate, DATE_FORMATTER);
            Map<String, Object> result = registrationService.registerPatient(
                    doctorId, patientName, patientPhone, date, registrationTime, notes);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> error = Map.of(
                    "success", false,
                    "message", "Format tanggal tidak valid. Gunakan format YYYY-MM-DD");
            return ResponseEntity.badRequest().body(error);
        }
    }

    /**
     * Mendapatkan status dokter
     */
    @GetMapping("/doctor-status")
    public ResponseEntity<Map<String, Object>> getDoctorStatus(
            @RequestParam Long doctorId,
            @RequestParam String date) {

        try {
            LocalDate appointmentDate = LocalDate.parse(date, DATE_FORMATTER);
            Map<String, Object> result = registrationService.getDoctorStatus(doctorId, appointmentDate);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> error = Map.of(
                    "status", "ERROR",
                    "message", "Format tanggal tidak valid. Gunakan format YYYY-MM-DD");
            return ResponseEntity.badRequest().body(error);
        }
    }

    /**
     * Mendapatkan daftar pendaftaran per dokter
     */
    @GetMapping("/doctor-registrations/{doctorId}")
    public ResponseEntity<Map<String, Object>> getDoctorRegistrations(@PathVariable Long doctorId) {
        Map<String, Object> result = registrationService.getDoctorRegistrations(doctorId);
        return ResponseEntity.ok(result);
    }
}
