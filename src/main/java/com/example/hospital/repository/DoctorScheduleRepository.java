package com.example.hospital.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.example.hospital.entity.DoctorSchedule;

public interface DoctorScheduleRepository extends JpaRepository<DoctorSchedule, Long> {
    List<DoctorSchedule> findByName(String name);
}
