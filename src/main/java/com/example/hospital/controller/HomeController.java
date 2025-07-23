package com.example.hospital.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import com.example.hospital.entity.Appointment;
import com.example.hospital.entity.Doctor;
import com.example.hospital.entity.DoctorSchedule;
import com.example.hospital.repository.AppointmentRepository;
import com.example.hospital.repository.DoctorRepository;
import com.example.hospital.repository.DoctorScheduleRepository;

@Controller
public class HomeController {
    @Autowired
    private DoctorRepository doctorRepository;
    @Autowired
    private DoctorScheduleRepository doctorScheduleRepository;
    @Autowired
    private AppointmentRepository appointmentRepository;

    @GetMapping("/")
    public String home(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        List<DoctorSchedule> doctorSchedules = doctorScheduleRepository.findAll();
        Map<String, List<DoctorSchedule>> scheduleMap =
                doctorSchedules.stream().collect(Collectors.groupingBy(DoctorSchedule::getName));
        java.util.Set<String> specializations =
                doctorSchedules.stream().map(DoctorSchedule::getSpecialization)
                        .collect(java.util.stream.Collectors.toCollection(java.util.TreeSet::new));
        model.addAttribute("doctors", doctors);
        model.addAttribute("scheduleMap", scheduleMap);
        model.addAttribute("specializations", specializations);
        return "index";
    }

    @GetMapping("/fasilitas")
    public String fasilitas() {
        return "user/fasilitas";
    }

    @GetMapping("/janji-temu")
    public String janjiTemu(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        List<DoctorSchedule> doctorSchedules = doctorScheduleRepository.findAll();
        // Ambil semua spesialisasi unik
        java.util.Set<String> specializations =
                doctorSchedules.stream().map(DoctorSchedule::getSpecialization)
                        .collect(java.util.stream.Collectors.toCollection(java.util.TreeSet::new));
        model.addAttribute("doctors", doctors);
        model.addAttribute("specializations", specializations);
        model.addAttribute("appointment", new Appointment());
        return "user/janji-temu";
    }

    @PostMapping("/janji-temu")
    public String submitJanjiTemu(@ModelAttribute Appointment appointment, Model model) {
        System.out.println("DEBUG: status sebelum set = " + appointment.getStatus());
        if (appointment.getStatus() == null || appointment.getStatus().isEmpty()) {
            appointment.setStatus("Menunggu");
        }
        System.out.println("DEBUG: status sesudah set = " + appointment.getStatus());
        appointmentRepository.save(appointment);
        // Kirim ulang doctors & specializations agar form tetap bisa diisi
        List<Doctor> doctors = doctorRepository.findAll();
        List<DoctorSchedule> doctorSchedules = doctorScheduleRepository.findAll();
        java.util.Set<String> specializations =
                doctorSchedules.stream().map(DoctorSchedule::getSpecialization)
                        .collect(java.util.stream.Collectors.toCollection(java.util.TreeSet::new));
        model.addAttribute("doctors", doctors);
        model.addAttribute("specializations", specializations);
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("success", true);
        return "user/janji-temu";
    }

    @GetMapping("/about")
    public String about() {
        return "user/about";
    }

    @GetMapping("/services")
    public String services() {
        return "user/services";
    }

    @GetMapping("/specializations")
    public String specializations() {
        return "user/specializations";
    }

    @GetMapping("/news")
    public String news() {
        return "user/news";
    }

    @GetMapping("/schedule")
    public String schedule(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        List<DoctorSchedule> doctorSchedules = doctorScheduleRepository.findAll();
        Map<String, List<DoctorSchedule>> scheduleMap =
                doctorSchedules.stream().collect(Collectors.groupingBy(DoctorSchedule::getName));
        java.util.Set<String> specializations =
                doctorSchedules.stream().map(DoctorSchedule::getSpecialization)
                        .collect(java.util.stream.Collectors.toCollection(java.util.TreeSet::new));
        model.addAttribute("doctors", doctors);
        model.addAttribute("scheduleMap", scheduleMap);
        model.addAttribute("specializations", specializations);
        return "user/schedule";
    }

    @GetMapping("/testimonials")
    public String testimonials() {
        return "user/testimonials";
    }

    @GetMapping("/vision-mission")
    public String visionMission() {
        return "user/vision-mission";
    }

    @GetMapping("/gallery")
    public String gallery() {
        return "user/gallery";
    }

    @GetMapping("/partners")
    public String partners() {
        return "user/partners";
    }

    @GetMapping("/doctor-profile/{doctorId}")
    public String doctorProfile(@PathVariable Long doctorId, Model model) {
        Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
        if (doctor == null) {
            return "redirect:/schedule";
        }
        // Ambil jadwal dokter dari doctor_schedule
        List<DoctorSchedule> schedules = doctorScheduleRepository.findAll().stream()
                .filter(ds -> ds.getName().equalsIgnoreCase(doctor.getName()))
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("doctor", doctor);
        model.addAttribute("schedules", schedules);
        return "user/doctor-profile";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
