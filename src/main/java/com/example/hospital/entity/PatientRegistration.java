package com.example.hospital.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "patient_registration")
@Data
public class PatientRegistration {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @Column(name = "patient_name")
    private String patientName;

    @Column(name = "patient_phone")
    private String patientPhone;

    @Column(name = "registration_date")
    private LocalDate registrationDate;

    @Column(name = "appointment_date")
    private LocalDate appointmentDate;

    @Column(name = "registration_time")
    private String registrationTime;

    @Column(name = "status")
    private String status = "ACTIVE"; // ACTIVE, CANCELLED, COMPLETED

    @Column(name = "notes")
    private String notes;
}
