package com.example.LTJava.config;

import com.example.LTJava.user.entity.Role;
import com.example.LTJava.user.entity.User;
import com.example.LTJava.user.repository.RoleRepository;
import com.example.LTJava.user.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.HashSet;

@Configuration
public class DataSeeder {

    @Bean
    CommandLineRunner seedSystemAdmin(UserRepository userRepo,
                                      RoleRepository roleRepo,
                                      PasswordEncoder encoder) {

        return args -> {

            // ===== 1. Tạo các role =====
            Role systemAdmin = createRoleIfNotExists(roleRepo, "SYSTEM_ADMIN");
            Role lecturer = createRoleIfNotExists(roleRepo, "LECTURER");
            Role hod = createRoleIfNotExists(roleRepo, "HOD");
            Role aa = createRoleIfNotExists(roleRepo, "AA");
            Role student = createRoleIfNotExists(roleRepo, "STUDENT");
            Role principal = createRoleIfNotExists(roleRepo, "PRINCIPAL");

            // ===== 2. Seed các user =====
            seedUser(userRepo, encoder, systemAdmin, "000000000000", "System Admin");
            seedUser(userRepo, encoder, lecturer, "111111111111", "Lecturer User");
            seedUser(userRepo, encoder, hod, "222222222222", "Head Of Department");
            seedUser(userRepo, encoder, aa, "333333333333", "Academic Affairs");
            seedUser(userRepo, encoder, student, "444444444444", "Student User");
            seedUser(userRepo, encoder, principal, "555555555555", "Principal User");

        };
    }

    private Role createRoleIfNotExists(RoleRepository repo, String roleName) {
        return repo.findByName(roleName)
                .orElseGet(() -> {
                    Role r = new Role();
                    r.setName(roleName);
                    return repo.save(r);
                });
    }

    private void seedUser(UserRepository userRepo,
                          PasswordEncoder encoder,
                          Role role,
                          String cccd,
                          String fullName) {

        if (userRepo.findByCccd(cccd).isPresent()) {
            System.out.println("ℹ️ User " + role.getName() + " already exists");
            return;
        }

        User user = new User();
        user.setCccd(cccd);
        user.setUsername(cccd);
        user.setFullName(fullName);
        user.setDateOfBirth(LocalDate.of(2000, 1, 1));
        user.setPassword(encoder.encode("123456"));
        user.setActive(true);

        HashSet<Role> roles = new HashSet<>();
        roles.add(role);
        user.setRoles(roles);

        userRepo.save(user);

        System.out.println("✅ Seeded " + role.getName());
        System.out.println("👉 Login CCCD: " + cccd + " | password: 123456");
    }
}