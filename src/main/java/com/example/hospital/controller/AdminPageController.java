package com.example.hospital.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import com.example.hospital.entity.Doctor;
import com.example.hospital.entity.DoctorSchedule;
import com.example.hospital.entity.News;
import com.example.hospital.repository.AppointmentRepository;
import com.example.hospital.repository.DoctorRepository;
import com.example.hospital.repository.DoctorScheduleRepository;
import com.example.hospital.repository.NewsRepository;
import com.example.hospital.repository.ServiceRepository;

@Controller
public class AdminPageController {
    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private NewsRepository newsRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private DoctorScheduleRepository doctorScheduleRepository;

    @GetMapping("/admin")
    public String adminDashboard(Model model, @RequestParam(defaultValue = "0") int page) {
        int pageSize = 5;
        Page<Doctor> doctorPage = doctorRepository.findAll(PageRequest.of(page, pageSize));

        // Filter out doctors with null or empty names
        List<Doctor> validDoctors = doctorPage.getContent().stream()
                .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                .toList();

        List<Doctor> allDoctors = doctorRepository.findAll();
        // Filter all doctors too
        List<Doctor> validAllDoctors = allDoctors.stream()
                .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                .toList();

        List<DoctorSchedule> allDoctorSchedules = doctorScheduleRepository.findAll();
        Set<String> specializations = allDoctorSchedules.stream()
                .filter(schedule -> schedule.getSpecialization() != null
                        && !schedule.getSpecialization().trim().isEmpty())
                .map(DoctorSchedule::getSpecialization)
                .collect(Collectors.toCollection(TreeSet::new));

        model.addAttribute("doctorSchedules", validDoctors);
        model.addAttribute("totalPages", doctorPage.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("doctors", validAllDoctors);
        model.addAttribute("specializations", specializations);
        model.addAttribute("news", newsRepository.findAll());
        model.addAttribute("services", serviceRepository.findAll());
        model.addAttribute("appointments", appointmentRepository.findAll());
        return "admin/admin";
    }

    @GetMapping("/admin/doctors")
    public String adminDoctors(Model model) {
        List<Doctor> allDoctors = doctorRepository.findAll();
        // Filter out doctors with null or empty names
        List<Doctor> validDoctors = allDoctors.stream()
                .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                .toList();
        model.addAttribute("doctors", validDoctors);
        return "admin/doctors";
    }

    @GetMapping("/admin/news")
    public String adminNews(Model model) {
        model.addAttribute("news", newsRepository.findAll());
        return "admin/news";
    }

    @GetMapping("/admin/services")
    public String adminServices(Model model) {
        model.addAttribute("services", serviceRepository.findAll());
        return "admin/services";
    }

    @GetMapping("/admin/appointments")
    public String adminAppointments(Model model) {
        model.addAttribute("appointments", appointmentRepository.findAll());
        return "admin/appointments";
    }

    @PostMapping("/admin/news")
    public String createNewsWithImage(@RequestParam("title") String title,
            @RequestParam("date") String date, @RequestParam("content") String content,
            @RequestParam(value = "image", required = false) MultipartFile image,
            @RequestParam("status") String status) throws Exception {
        News news = new News();
        news.setTitle(title);
        news.setDate(LocalDate.parse(date));
        news.setContent(content);
        news.setStatus(status);
        if (image != null && !image.isEmpty()) {
            String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            Path uploadPath = Paths.get("src/main/resources/static/news-images/");
            if (!Files.exists(uploadPath))
                Files.createDirectories(uploadPath);
            Path filePath = uploadPath.resolve(fileName);
            image.transferTo(filePath);
            news.setImageUrl("/news-images/" + fileName);
        }
        newsRepository.save(news);
        return "redirect:/admin";
    }
}
