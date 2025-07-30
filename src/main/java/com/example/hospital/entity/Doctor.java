package com.example.hospital.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "doctor")
@Data
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String specialization;

    @Column(name = "is_on_leave")
    private Boolean isOnLeave = false;

    @Column(name = "leave_reason")
    private String leaveReason;

    @Column(name = "leave_start_date")
    private String leaveStartDate;

    @Column(name = "leave_end_date")
    private String leaveEndDate;

    @Column(name = "max_patients_per_day")
    private Integer maxPatientsPerDay = 30;

    @Column(name = "is_locked")
    private Boolean isLocked = false;

    @Column(name = "lock_reason")
    private String lockReason;

    @Column(name = "lock_start_date")
    private String lockStartDate;

    @Column(name = "lock_end_date")
    private String lockEndDate;
}
