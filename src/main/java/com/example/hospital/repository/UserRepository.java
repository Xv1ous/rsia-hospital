package com.example.hospital.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.example.hospital.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}
