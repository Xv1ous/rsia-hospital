package com.example.hospital.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.example.hospital.entity.Appointment;
import com.example.hospital.entity.Doctor;
import com.example.hospital.entity.DoctorSchedule;
import com.example.hospital.entity.News;
import com.example.hospital.entity.Service;
import com.example.hospital.entity.PageContent;
import com.example.hospital.repository.AppointmentRepository;
import com.example.hospital.repository.DoctorRepository;
import com.example.hospital.repository.DoctorScheduleRepository;
import com.example.hospital.repository.NewsRepository;
import com.example.hospital.repository.ServiceRepository;
import com.example.hospital.repository.PageContentRepository;
import com.example.hospital.service.PageContentService;

@RestController
@RequestMapping("/admin/api")
public class AdminController {
    @Autowired
    private AppointmentRepository appointmentRepository;
    @Autowired
    private DoctorRepository doctorRepository;
    @Autowired
    private NewsRepository newsRepository;
    @Autowired
    private ServiceRepository serviceRepository;
    @Autowired
    private DoctorScheduleRepository doctorScheduleRepository;
    @Autowired
    private PageContentRepository pageContentRepository;
    @Autowired
    private PageContentService pageContentService;

    // --- Appointment CRUD ---
    @GetMapping("/appointments")
    public List<Appointment> getAllAppointments() {
        return appointmentRepository.findAll();
    }

    @GetMapping("/appointments/{id}")
    public Appointment getAppointmentById(@PathVariable Long id) {
        return appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
    }

    @PostMapping("/appointments")
    public Appointment createAppointment(@RequestBody Appointment a) {
        return appointmentRepository.save(a);
    }

    @PutMapping("/appointments/{id}")
    public Appointment updateAppointment(@PathVariable Long id, @RequestBody Appointment a) {
        a.setId(id);
        return appointmentRepository.save(a);
    }

    @DeleteMapping("/appointments/{id}")
    public void deleteAppointment(@PathVariable Long id) {
        appointmentRepository.deleteById(id);
    }

    // --- Doctor CRUD ---
    @GetMapping("/doctors")
    public List<Doctor> getAllDoctors() {
        return doctorRepository.findAll();
    }

    @GetMapping("/doctors/{id}")
    public Doctor getDoctorById(@PathVariable Long id) {
        return doctorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));
    }

    @PostMapping("/doctors")
    public Doctor createDoctor(@RequestBody Doctor d) {
        return doctorRepository.save(d);
    }

    @PutMapping("/doctors/{id}")
    public Doctor updateDoctor(@PathVariable Long id, @RequestBody Doctor d) {
        Doctor existingDoctor = doctorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));

        // Update basic fields
        existingDoctor.setName(d.getName());
        existingDoctor.setSpecialization(d.getSpecialization());
        existingDoctor.setMaxPatientsPerDay(d.getMaxPatientsPerDay());

        // Update leave status
        existingDoctor.setIsOnLeave(d.getIsOnLeave());
        existingDoctor.setLeaveReason(d.getLeaveReason());
        existingDoctor.setLeaveStartDate(d.getLeaveStartDate());
        existingDoctor.setLeaveEndDate(d.getLeaveEndDate());

        // Update lock status
        existingDoctor.setIsLocked(d.getIsLocked());
        existingDoctor.setLockReason(d.getLockReason());
        existingDoctor.setLockStartDate(d.getLockStartDate());
        existingDoctor.setLockEndDate(d.getLockEndDate());

        return doctorRepository.save(existingDoctor);
    }

    @DeleteMapping("/doctors/{id}")
    public void deleteDoctor(@PathVariable Long id) {
        doctorRepository.deleteById(id);
    }

    // --- News CRUD ---
    @GetMapping("/news")
    public List<News> getAllNews() {
        return newsRepository.findAll();
    }

    @PostMapping("/news")
    public News createNewsWithImage(@RequestParam("title") String title,
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
        return newsRepository.save(news);
    }

    @PutMapping("/news/{id}")
    public News updateNews(@PathVariable Long id, @RequestBody News n) {
        n.setId(id);
        return newsRepository.save(n);
    }

    @DeleteMapping("/news/{id}")
    public void deleteNews(@PathVariable Long id) {
        newsRepository.deleteById(id);
    }

    // --- Service CRUD ---
    @GetMapping("/services")
    public List<Service> getAllServices() {
        return serviceRepository.findAll();
    }

    @PostMapping("/services")
    public Service createService(@RequestBody Service s) {
        return serviceRepository.save(s);
    }

    @PutMapping("/services/{id}")
    public Service updateService(@PathVariable Long id, @RequestBody Service s) {
        s.setId(id);
        return serviceRepository.save(s);
    }

    @DeleteMapping("/services/{id}")
    public void deleteService(@PathVariable Long id) {
        serviceRepository.deleteById(id);
    }

    // --- DoctorSchedule CRUD ---
    @GetMapping("/doctor-schedules")
    public List<DoctorSchedule> getAllDoctorSchedules() {
        return doctorScheduleRepository.findAll();
    }

    @GetMapping("/doctor-schedules/search")
    public List<DoctorSchedule> getDoctorSchedulesByName(@RequestParam String doctorName) {
        return doctorScheduleRepository.findByName(doctorName);
    }

    @PostMapping("/doctor-schedules")
    public DoctorSchedule createDoctorSchedule(@RequestBody DoctorSchedule d) {
        return doctorScheduleRepository.save(d);
    }

    @PutMapping("/doctor-schedules/{id}")
    public DoctorSchedule updateDoctorSchedule(@PathVariable Long id,
            @RequestBody DoctorSchedule d) {
        d.setId(id);
        return doctorScheduleRepository.save(d);
    }

    @DeleteMapping("/doctor-schedules/{id}")
    public void deleteDoctorSchedule(@PathVariable Long id) {
        doctorScheduleRepository.deleteById(id);
    }

    // --- API untuk sistem pembatasan ---
    @GetMapping("/api/doctors")
    public List<Doctor> getDoctorsForAPI() {
        return doctorRepository.findAll();
    }

    // --- Page Content CRUD ---
    @GetMapping("/page-contents")
    public List<PageContent> getAllPageContents() {
        return pageContentRepository.findAll();
    }

    @GetMapping("/page-contents/{pageType}")
    public List<PageContent> getPageContentsByType(@PathVariable String pageType) {
        try {
            PageContent.PageType type = PageContent.PageType.valueOf(pageType.toUpperCase());
            return pageContentRepository.findByPageTypeOrderBySortOrderAsc(type);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid page type: " + pageType);
        }
    }

    @PostMapping("/page-contents")
    public PageContent createPageContent(@RequestBody PageContent content) {
        return pageContentService.saveContent(content);
    }

    @PutMapping("/page-contents/{id}")
    public PageContent updatePageContent(@PathVariable Long id, @RequestBody PageContent content) {
        PageContent existingContent = pageContentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Page content not found"));

        existingContent.setPageType(content.getPageType());
        existingContent.setTitle(content.getTitle());
        existingContent.setDescription(content.getDescription());
        existingContent.setIconSvg(content.getIconSvg());
        existingContent.setCategory(content.getCategory());
        existingContent.setPrice(content.getPrice());
        existingContent.setOriginalPrice(content.getOriginalPrice());
        existingContent.setFeatures(content.getFeatures());
        existingContent.setImageUrl(content.getImageUrl());
        existingContent.setSortOrder(content.getSortOrder());
        existingContent.setIsActive(content.getIsActive());

        return pageContentService.saveContent(existingContent);
    }

    @DeleteMapping("/page-contents/{id}")
    public void deletePageContent(@PathVariable Long id) {
        pageContentService.deleteContent(id);
    }
}
