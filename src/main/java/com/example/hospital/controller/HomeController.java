package com.example.hospital.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.example.hospital.repository.DoctorRepository;
import com.example.hospital.repository.DoctorScheduleRepository;
import com.example.hospital.repository.NewsRepository;
import com.example.hospital.repository.ServiceRepository;
import com.example.hospital.entity.Appointment;
import com.example.hospital.entity.DoctorSchedule;
import com.example.hospital.entity.Doctor;

@Controller
public class HomeController {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private NewsRepository newsRepository;

    @Autowired
    private DoctorScheduleRepository doctorScheduleRepository;

    @GetMapping("/")
    public String home(Model model) {
        try {
            // Clean up invalid doctor data first
            List<Doctor> allDoctors = doctorRepository.findAll();
            List<Doctor> invalidDoctors = allDoctors.stream()
                    .filter(doctor -> doctor == null || doctor.getName() == null || doctor.getName().trim().isEmpty())
                    .toList();

            if (!invalidDoctors.isEmpty()) {
                doctorRepository.deleteAll(invalidDoctors);
                // Reload the list after cleanup
                allDoctors = doctorRepository.findAll();
            }

            // Filter out doctors with null or empty names
            List<Doctor> validDoctors = allDoctors.stream()
                    .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                    .toList();

            model.addAttribute("doctors", validDoctors);
        } catch (Exception e) {
            model.addAttribute("doctors", new ArrayList<>());
        }

        try {
            model.addAttribute("services", serviceRepository.findAll());
        } catch (Exception e) {
            model.addAttribute("services", new ArrayList<>());
        }

        try {
            model.addAttribute("news", newsRepository.findAll());
        } catch (Exception e) {
            model.addAttribute("news", new ArrayList<>());
        }

        // Add schedule data
        try {
            Map<String, List<DoctorSchedule>> scheduleMap = new HashMap<>();
            List<DoctorSchedule> allSchedules = doctorScheduleRepository.findAll();

            for (DoctorSchedule schedule : allSchedules) {
                String doctorName = schedule.getName();
                if (doctorName != null && !doctorName.trim().isEmpty()) {
                    if (!scheduleMap.containsKey(doctorName)) {
                        scheduleMap.put(doctorName, new ArrayList<>());
                    }
                    scheduleMap.get(doctorName).add(schedule);
                }
            }

            model.addAttribute("scheduleMap", scheduleMap);
        } catch (Exception e) {
            model.addAttribute("scheduleMap", new HashMap<>());
        }

        // Add specializations
        try {
            List<String> specializations = new ArrayList<>();
            specializations.add("Dokter Umum");
            specializations.add("Dokter Gigi");
            specializations.add("Dokter Anak");
            specializations.add("Dokter Kandungan");
            specializations.add("Dokter Bedah");
            model.addAttribute("specializations", specializations);
        } catch (Exception e) {
            model.addAttribute("specializations", new ArrayList<>());
        }

        return "index";
    }

    @GetMapping("/schedule")
    public String schedule(Model model) {
        try {
            List<Doctor> allDoctors = doctorRepository.findAll();
            // Filter out doctors with null or empty names
            List<Doctor> validDoctors = allDoctors.stream()
                    .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                    .toList();
            model.addAttribute("doctors", validDoctors);
        } catch (Exception e) {
            model.addAttribute("doctors", new ArrayList<>());
        }

        // Add schedule data
        try {
            Map<String, List<DoctorSchedule>> scheduleMap = new HashMap<>();
            List<DoctorSchedule> allSchedules = doctorScheduleRepository.findAll();

            for (DoctorSchedule schedule : allSchedules) {
                String doctorName = schedule.getName();
                if (doctorName != null && !doctorName.trim().isEmpty()) {
                    if (!scheduleMap.containsKey(doctorName)) {
                        scheduleMap.put(doctorName, new ArrayList<>());
                    }
                    scheduleMap.get(doctorName).add(schedule);
                }
            }

            model.addAttribute("scheduleMap", scheduleMap);
        } catch (Exception e) {
            model.addAttribute("scheduleMap", new HashMap<>());
        }

        // Add specializations
        try {
            List<String> specializations = new ArrayList<>();
            specializations.add("Dokter Umum");
            specializations.add("Dokter Gigi");
            specializations.add("Dokter Anak");
            specializations.add("Dokter Kandungan");
            specializations.add("Dokter Bedah");
            model.addAttribute("specializations", specializations);
        } catch (Exception e) {
            model.addAttribute("specializations", new ArrayList<>());
        }

        return "user/schedule";
    }

    @GetMapping("/testimonials")
    public String testimonials(Model model) {
        return "user/testimonials";
    }

    @GetMapping("/about")
    public String about(Model model) {
        return "user/about";
    }

    @GetMapping("/services")
    public String services(Model model) {
        return "user/services";
    }

    @GetMapping("/fasilitas")
    public String fasilitas(Model model) {
        return "user/fasilitas";
    }

    @GetMapping("/patients")
    public String patients(Model model) {
        return "user/patients";
    }

    @GetMapping("/homecare")
    public String homecare(Model model) {
        return "user/homecare";
    }

    @GetMapping("/janji-temu")
    public String janjiTemu(Model model) {
        try {
            List<Doctor> allDoctors = doctorRepository.findAll();
            // Filter out doctors with null or empty names
            List<Doctor> validDoctors = allDoctors.stream()
                    .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                    .toList();
            model.addAttribute("doctors", validDoctors);
        } catch (Exception e) {
            model.addAttribute("doctors", new ArrayList<>());
        }

        // Add appointment object for form binding
        model.addAttribute("appointment", new Appointment());

        return "user/janji-temu";
    }

    @GetMapping("/login")
    public String login(Model model) {
        return "login";
    }
}
