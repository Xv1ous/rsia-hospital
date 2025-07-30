package com.example.hospital;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import com.example.hospital.entity.User;
import com.example.hospital.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Configuration
public class SecurityConfig {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LoginAttemptService loginAttemptService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        return username -> {
            if (loginAttemptService.isLocked(username)) {
                throw new RuntimeException(
                        "Akun terkunci karena terlalu banyak percobaan login gagal.");
            }
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
            return org.springframework.security.core.userdetails.User
                    .withUsername(user.getUsername()).password(user.getPassword())
                    .roles(user.getRole().replace("ROLE_", "")).build();
        };
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests(auth -> auth.requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/user/**", "/schedule", "/about", "/services", "/fasilitas", "/patients", "/homecare",
                        "/news", "/specializations", "/janji-temu", "/registration", "/", "/css/**", "/js/**",
                        "/asset hospital/**", "/api/registration/**")
                .permitAll().anyRequest().permitAll())
                .formLogin(form -> form.loginPage("/login")
                        .successHandler(customAuthenticationSuccessHandler()).permitAll())
                .logout(logout -> logout.permitAll())
                .csrf(csrf -> csrf.ignoringRequestMatchers("/admin/api/**"));
        return http.build();
    }

    @Bean
    public AuthenticationSuccessHandler customAuthenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                    HttpServletResponse response, Authentication authentication)
                    throws IOException, ServletException {
                for (GrantedAuthority auth : authentication.getAuthorities()) {
                    if ("ROLE_ADMIN".equals(auth.getAuthority())) {
                        response.sendRedirect("/admin");
                        return;
                    }
                }
                response.sendRedirect("/");
            }
        };
    }

    @EventListener
    public void onAuthenticationFailure(AuthenticationFailureBadCredentialsEvent event) {
        String username = (String) event.getAuthentication().getPrincipal();
        loginAttemptService.loginFailed(username);
    }
}

@Component
class LoginAttemptService {
    private final ConcurrentHashMap<String, Integer> attempts = new ConcurrentHashMap<>();
    private final int MAX_ATTEMPTS = 5;

    public void loginFailed(String username) {
        attempts.merge(username, 1, Integer::sum);
    }

    public boolean isLocked(String username) {
        return attempts.getOrDefault(username, 0) >= MAX_ATTEMPTS;
    }

    public void loginSucceeded(String username) {
        attempts.remove(username);
    }
}
