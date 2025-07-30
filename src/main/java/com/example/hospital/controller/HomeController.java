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
            model.addAttribute("doctors", doctorRepository.findAll());
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
            Map<String, List<Object>> scheduleMap = new HashMap<>();
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
            model.addAttribute("doctors", doctorRepository.findAll());
        } catch (Exception e) {
            model.addAttribute("doctors", new ArrayList<>());
        }

        // Add schedule data
        try {
            Map<String, List<Object>> scheduleMap = new HashMap<>();
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

    @GetMapping("/admin/registration-management")
    public String registrationManagement(Model model) {
        return "admin/registration-management";
    }

    @GetMapping("/registration")
    public String registration(Model model) {
        return "user/registration";
    }
}
