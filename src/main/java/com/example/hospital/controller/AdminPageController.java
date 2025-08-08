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
import org.springframework.web.bind.annotation.PathVariable;
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
import com.example.hospital.repository.PageContentRepository;
import com.example.hospital.service.PageContentService;

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
    @Autowired
    private PageContentRepository pageContentRepository;
    @Autowired
    private PageContentService pageContentService;

    @GetMapping("/admin")
    public String adminDashboard(Model model, @RequestParam(defaultValue = "0") int page) {
        int pageSize = 5;
        Page<Doctor> doctorPage = doctorRepository.findAll(PageRequest.of(page, pageSize));

        List<Doctor> allDoctors = doctorRepository.findAll();
        System.out.println("Total doctors in database: " + allDoctors.size());

        // Log doctors with null or empty names
        allDoctors.stream()
                .filter(doctor -> doctor == null || doctor.getName() == null || doctor.getName().trim().isEmpty())
                .forEach(doctor -> System.out.println("Invalid doctor: " + doctor));

        // Filter out doctors with null or empty names
        List<Doctor> validDoctors = doctorPage.getContent().stream()
                .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                .toList();

        // Filter all doctors too
        List<Doctor> validAllDoctors = allDoctors.stream()
                .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                .toList();

        System.out.println("Valid doctors: " + validAllDoctors.size());

        // Log some sample doctors for debugging
        validAllDoctors.stream().limit(5).forEach(doctor -> {
            String status = "Aktif";
            if (doctor.getIsOnLeave() != null && doctor.getIsOnLeave()) {
                status = "Cuti";
            } else if (doctor.getIsLocked() != null && doctor.getIsLocked()) {
                status = "Dikunci";
            }
            System.out.println("Sample doctor: ID=" + doctor.getId() +
                    ", Name=" + doctor.getName() +
                    ", Specialization=" + doctor.getSpecialization() +
                    ", Status=" + status);
        });

        List<DoctorSchedule> allDoctorSchedules = doctorScheduleRepository.findAll();
        Set<String> specializations = allDoctorSchedules.stream()
                .filter(schedule -> schedule.getSpecialization() != null
                        && !schedule.getSpecialization().trim().isEmpty())
                .map(DoctorSchedule::getSpecialization)
                .collect(Collectors.toCollection(TreeSet::new));

        // Get all appointments and page contents for dashboard stats
        List<com.example.hospital.entity.Appointment> allAppointments = appointmentRepository.findAll();
        List<com.example.hospital.entity.PageContent> allPageContents = pageContentRepository.findAll();

        // Get today's appointments
        LocalDate today = LocalDate.now();
        List<com.example.hospital.entity.Appointment> recentAppointments = allAppointments.stream()
                .filter(appointment -> {
                    if (appointment.getAppointmentDate() != null) {
                        return appointment.getAppointmentDate().equals(today);
                    }
                    return false;
                })
                .toList();

        model.addAttribute("doctorSchedules", validDoctors);
        model.addAttribute("totalPages", doctorPage.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("doctors", validAllDoctors);
        System.out.println("Added " + validAllDoctors.size() + " doctors to model");
        model.addAttribute("specializations", specializations);
        model.addAttribute("news", newsRepository.findAll());
        model.addAttribute("services", serviceRepository.findAll());
        model.addAttribute("appointments", allAppointments);
        model.addAttribute("pageContents", allPageContents);
        model.addAttribute("recentAppointments", recentAppointments);
        model.addAttribute("allDoctorSchedules", allDoctorSchedules);
        return "admin/admin";
    }

    @GetMapping("/admin/doctors")
    public String adminDoctors(Model model) {
        List<Doctor> allDoctors = doctorRepository.findAll();
        System.out.println("Total doctors in database (doctors page): " + allDoctors.size());

        // Filter out doctors with null or empty names
        List<Doctor> validDoctors = allDoctors.stream()
                .filter(doctor -> doctor != null && doctor.getName() != null && !doctor.getName().trim().isEmpty())
                .toList();

        System.out.println("Valid doctors (doctors page): " + validDoctors.size());

        // Log some sample doctors for doctors page
        validDoctors.stream().limit(5).forEach(doctor -> {
            System.out.println("Doctors page - Sample doctor: ID=" + doctor.getId() +
                    ", Name=" + doctor.getName() +
                    ", Specialization=" + doctor.getSpecialization());
        });

        model.addAttribute("doctors", validDoctors);
        System.out.println("Added " + validDoctors.size() + " doctors to doctors page model");
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

    @GetMapping("/admin/page-contents")
    public String adminPageContents(Model model) {
        model.addAttribute("pageContents", pageContentRepository.findAll());
        model.addAttribute("pageTypes", com.example.hospital.entity.PageContent.PageType.values());
        return "admin/page-contents";
    }

    @GetMapping("/admin/appointments")
    public String adminAppointments(Model model) {
        model.addAttribute("appointments", appointmentRepository.findAll());
        return "admin/appointments";
    }

    @GetMapping("/admin/doctor-schedule/{doctorId}")
    public String adminDoctorSchedule(@PathVariable Long doctorId, Model model) {
        Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
        if (doctor == null) {
            return "redirect:/admin";
        }

        List<DoctorSchedule> doctorSchedules = doctorScheduleRepository.findAll().stream()
                .filter(schedule -> schedule.getName().equals(doctor.getName()))
                .toList();

        model.addAttribute("doctor", doctor);
        model.addAttribute("doctorSchedules", doctorSchedules);
        model.addAttribute("allDoctorSchedules", doctorScheduleRepository.findAll());
        return "admin/doctor-schedule";
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
