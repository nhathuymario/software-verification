package com.example.LTJava.user.service;

import com.example.LTJava.syllabus.repository.NotificationRepository;
import com.example.LTJava.user.dto.CreateUserRequest;
import com.example.LTJava.user.entity.Role;
import com.example.LTJava.user.entity.User;
import com.example.LTJava.user.repository.RoleRepository;
import com.example.LTJava.user.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.example.LTJava.user.dto.ImportUsersResult;
import com.example.LTJava.user.dto.UserImportRow;
import com.example.LTJava.user.importer.ExcelUserImporter;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
//import java.util.Optional;
//import java.util.ArrayList;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final ExcelUserImporter excelUserImporter;
    private NotificationRepository notificationRepository;

    public UserServiceImpl(UserRepository userRepository,
                           RoleRepository roleRepository,
                           PasswordEncoder passwordEncoder, PasswordEncoder passwordEncoder1,
                           ExcelUserImporter excelUserImporter,
                           NotificationRepository notificationRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.excelUserImporter = excelUserImporter;
        this.notificationRepository = notificationRepository;
    }

    @Override
    public User createUser(CreateUserRequest request) {

        String cccd = request.getCccd();
        if (cccd == null || cccd.isBlank()) {
            throw new RuntimeException("CCCD không được để trống");
        }
        if (userRepository.existsByCccd(cccd)) {
            throw new RuntimeException("CCCD đã tồn tại");
        }

        String username = cccd;
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username đã tồn tại: " + username);
        }

        String fullName = request.getFullName();
        if (fullName == null || fullName.isBlank()) {
            throw new RuntimeException("Full name không được để trống");
        }

        String dobStr = request.getDateOfBirth();
        if (dobStr == null || dobStr.isBlank()) {
            throw new RuntimeException("Ngày sinh không được để trống");
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate dob;
        try {
            dob = LocalDate.parse(dobStr, formatter);
        } catch (DateTimeParseException e) {
            throw new RuntimeException("Ngày sinh không đúng định dạng dd/MM/yyyy");
        }

        String rawPassword = dob.format(DateTimeFormatter.ofPattern("ddMMyyyy"));
        String hashedPassword = passwordEncoder.encode(rawPassword);

        String reqRole = request.getRoleName();
        String finalRoleName = (reqRole == null || reqRole.isBlank()) ? "USER" : reqRole;

        Role role = roleRepository.findByName(finalRoleName)
                .orElseGet(() -> roleRepository.save(new Role(finalRoleName)));

        User user = new User();
        user.setCccd(cccd);
        user.setUsername(username);
        user.setPassword(hashedPassword);
        user.setFullName(fullName);
        user.setDateOfBirth(dob);
        user.setActive(true);

        user.getRoles().add(role);   // QUAN TRỌNG

        return userRepository.save(user);
    }
    // ====== TẠO HÀNG LOẠT (BULK) ======
    @Override
    public List<User> createUsersBulk(List<CreateUserRequest> requests) {
        return requests.stream()
                .map(this::createUser)
                .toList();
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public User lockUser(Long userId) {
        // 1. Tìm user mục tiêu muốn khóa
        User targetUser = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user id = " + userId));

        // 2. Lấy thông tin người dùng hiện tại đang thực hiện thao tác (Current Admin)
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String currentUsername;

        if (principal instanceof UserDetails) {
            currentUsername = ((UserDetails) principal).getUsername();
        } else {
            currentUsername = principal.toString();
        }

        // 3. BVA & Security: Chặn tự khóa bản thân
        if (targetUser.getUsername().equals(currentUsername)) {
            throw new RuntimeException("Bạn không thể tự khóa tài khoản của chính mình!");
        }

        // 4. BVA: Chặn khóa người đã bị khóa
        if (!targetUser.isActive()) {
            throw new RuntimeException("Người dùng này hiện đang bị khóa rồi.");
        }

        // 5. Thực hiện khóa
        targetUser.setActive(false);
        return userRepository.save(targetUser);
    }

    @Override
    public User unlockUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user id = " + userId));

        // BVA: Nếu đã active (true) thì không cho mở khóa nữa
        if (user.isActive()) {
            throw new RuntimeException("Người dùng này hiện đang hoạt động, không cần mở khóa.");
        }

        user.setActive(true);
        return userRepository.save(user);
    }

    @Override
    public User changeUserRole(Long userId, String roleName) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user id = " + userId));

        if (roleName == null || roleName.isBlank()) {
            throw new RuntimeException("Role name không được để trống");
        }

        // BVA: Kiểm tra xem user đã có role này chưa để tránh update thừa
        boolean alreadyHasRole = user.getRoles().stream()
                .anyMatch(r -> r.getName().equalsIgnoreCase(roleName));
        if (alreadyHasRole) {
            throw new RuntimeException("Người dùng đã sở hữu quyền " + roleName + " rồi.");
        }

        Role role = roleRepository.findByName(roleName)
                .orElseThrow(() -> new RuntimeException("Role " + roleName + " không tồn tại trong hệ thống"));

        user.getRoles().clear();
        user.getRoles().add(role);

        return userRepository.save(user);
    }
    // xóa user
    @Override
    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user id = " + userId));

        // BVA & Security: Không cho phép Admin tự xóa chính mình
        // Giả sử bạn lấy username của người đang đăng nhập từ SecurityContext
        String currentUsername = org.springframework.security.core.context.SecurityContextHolder
                .getContext().getAuthentication().getName();
        if (user.getUsername().equals(currentUsername)) {
            throw new RuntimeException("Bạn không thể tự xóa tài khoản của chính mình!");
        }

        // BVA: Kiểm tra nếu là Admin cuối cùng (Tùy nghiệp vụ)
        // long adminCount = userRepository.countByRoleName("ADMIN");
        // if (adminCount <= 1 && user.isAdmin()) { ... }

        notificationRepository.deleteByUserId(userId);
        userRepository.deleteById(userId);
    }

    @Override
    public ImportUsersResult importUsersFromExcel(MultipartFile file) {

        ExcelUserImporter.ParseResult parsed = excelUserImporter.parse(file);
        ImportUsersResult result = parsed.result();
        List<UserImportRow> rows = parsed.rows();

        int success = 0;
        DateTimeFormatter dmy = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        for (UserImportRow r : rows) {
            try {
                // ✅ LOG DỮ LIỆU ĐỌC TỪ EXCEL (thô)
                System.out.println("IMPORT ROW: " + r.getExcelRowNumber()
                        + " | cccd=" + r.getCccd()
                        + " | dob=" + r.getDateOfBirth()
                        + " | role=" + r.getRoleName());

                CreateUserRequest req = new CreateUserRequest();
                req.setFullName(r.getFullName());
                req.setCccd(r.getCccd());
                req.setRoleName(r.getRoleName());

                String dobStr = r.getDateOfBirth().format(dmy);
                // ✅ LOG DOB STRING GỬI VÀO createUser()
                System.out.println("IMPORT ROW: " + r.getExcelRowNumber()
                        + " | dobStr=" + dobStr);

                req.setDateOfBirth(dobStr);

                createUser(req);
                success++;

            } catch (Exception e) {
                // ✅ LOG LỖI THEO DÒNG
                System.out.println("IMPORT ERROR ROW: " + r.getExcelRowNumber()
                        + " | message=" + e.getMessage());

                result.getErrors().add(new ImportUsersResult.RowError(r.getExcelRowNumber(), e.getMessage()));
            }
        }

        result.setSuccessCount(success);
        result.setFailedCount(result.getErrors().size());
        return result;
    }



}
