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
import java.util.Set;

@Configuration
public class DataSeeder {

    @Bean
    CommandLineRunner seedSystemAdmin(UserRepository userRepo,
                                      RoleRepository roleRepo,
                                      PasswordEncoder encoder) {

        return args -> {

            Role systemAdmin = createRole(roleRepo, "SYSTEM_ADMIN");
            Role lecturer = createRole(roleRepo, "LECTURER");
            Role hod = createRole(roleRepo, "HOD");
            Role aa = createRole(roleRepo, "AA");
            Role student = createRole(roleRepo, "STUDENT");
            Role principal = createRole(roleRepo, "PRINCIPAL");

            seedUser(userRepo, encoder, systemAdmin, "000000000000", "System Admin");
            seedUser(userRepo, encoder, lecturer, "111111111111", "Lecturer User");
            seedUser(userRepo, encoder, lecturer, "666666666666", "Lecturer User");
            seedUser(userRepo, encoder, hod, "222222222222", "HOD User");
            seedUser(userRepo, encoder, aa, "333333333333", "AA User");
            seedUser(userRepo, encoder, student, "444444444444", "Student User");
            seedUser(userRepo, encoder, principal, "555555555555", "Principal User");

        };
    }

    private Role createRole(RoleRepository repo, String name) {
        return repo.findByName(name)
                .orElseGet(() -> repo.save(new Role(name)));
    }

    private void seedUser(UserRepository userRepo,
                          PasswordEncoder encoder,
                          Role role,
                          String cccd,
                          String fullName) {

        if (userRepo.findByCccd(cccd).isPresent()) return;

        User user = new User();
        user.setCccd(cccd);
        user.setUsername(cccd);
        user.setFullName(fullName);
        user.setPassword(encoder.encode("123456"));
        user.setDateOfBirth(LocalDate.of(2000, 1, 1));
        user.setActive(true);

        Set<Role> roles = new HashSet<>();
        roles.add(role);

        user.setRoles(roles);

        userRepo.save(user);

        System.out.println("Seeded user role: " + role.getName());
    }
}