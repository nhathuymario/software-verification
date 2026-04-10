package com.example.LTJava.profile.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.stream.Collectors;
import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.LTJava.profile.dto.ChangeMyPasswordRequest;
import com.example.LTJava.profile.dto.MeResponse;
import com.example.LTJava.profile.dto.UpdateMyProfileRequest;
import com.example.LTJava.profile.entity.UserProfile;
import com.example.LTJava.profile.repository.UserProfileRepository;
import com.example.LTJava.user.entity.User;
import com.example.LTJava.user.exception.AppException;
import com.example.LTJava.user.repository.UserRepository;

@Service
@Transactional
public class ProfileServiceImpl implements ProfileService {

    @Value("${app.upload.base-dir}")
    private String uploadBaseDir;

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;
    private final PasswordEncoder passwordEncoder;

    public ProfileServiceImpl(
            UserRepository userRepository,
            UserProfileRepository userProfileRepository,
            PasswordEncoder passwordEncoder
    ) {
        this.userRepository = userRepository;
        this.userProfileRepository = userProfileRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional(readOnly = true)
    public MeResponse getMe(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException("User không tồn tại", HttpStatus.NOT_FOUND));

        UserProfile profile = userProfileRepository.findByUserId(userId).orElse(null);

        return toMeResponse(user, profile);
    }

    @Override
    public MeResponse updateMyProfile(Long userId, UpdateMyProfileRequest req) {

        if (req == null) {
            throw new AppException("Thiếu dữ liệu cập nhật", HttpStatus.BAD_REQUEST);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException("User không tồn tại", HttpStatus.NOT_FOUND));

        // update fullName
        if (req.getFullName() != null && !req.getFullName().trim().isEmpty()) {
            user.setFullName(req.getFullName().trim());
        }

        UserProfile profile = userProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    UserProfile p = new UserProfile();
                    p.setUser(user);
                    return p;
                });

        // ✅ EMAIL VALIDATE
        String email = req.getEmail();
        if (email != null) {
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new AppException("Email không hợp lệ", HttpStatus.BAD_REQUEST);
            }
            profile.setEmail(email.trim());
        }

        if (req.getPhone() != null) {
            profile.setPhone(req.getPhone().trim());
        }

        if (req.getAddress() != null) {
            profile.setAddress(req.getAddress().trim());
        }

        if (req.getAvatarUrl() != null) {
            profile.setAvatarUrl(req.getAvatarUrl().trim());
        }

        if (req.getBio() != null) {
            profile.setBio(req.getBio().trim());
        }

        userRepository.save(user);
        userProfileRepository.save(profile);

        return toMeResponse(user, profile);
    }

    @Override
    public void changeMyPassword(Long userId, ChangeMyPasswordRequest req) {

        if (req == null || req.getCurrentPassword() == null || req.getNewPassword() == null) {
            throw new AppException("Thiếu dữ liệu đổi mật khẩu", HttpStatus.BAD_REQUEST);
        }

        if (req.getNewPassword().length() < 6) {
            throw new AppException("Mật khẩu mới tối thiểu 6 ký tự", HttpStatus.BAD_REQUEST);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException("User không tồn tại", HttpStatus.NOT_FOUND));

        if (!passwordEncoder.matches(req.getCurrentPassword(), user.getPassword())) {
            throw new AppException("Mật khẩu hiện tại không đúng", HttpStatus.BAD_REQUEST);
        }

        user.setPassword(passwordEncoder.encode(req.getNewPassword()));
        userRepository.save(user);
    }

    @Override
    public String uploadMyAvatar(Long userId, MultipartFile file) {

        if (file == null || file.isEmpty()) {
            throw new AppException("File avatar rỗng", HttpStatus.BAD_REQUEST);
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new AppException("Chỉ cho phép upload file ảnh", HttpStatus.BAD_REQUEST);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException("User không tồn tại", HttpStatus.NOT_FOUND));

        UserProfile profile = userProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    UserProfile p = new UserProfile();
                    p.setUser(user);
                    return p;
                });

        String original = file.getOriginalFilename();
        String ext = "";
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf("."));
        }

        String fileName = UUID.randomUUID() + ext;

        Path avatarDir = Paths.get(uploadBaseDir, "avatars");

        try {
            Files.createDirectories(avatarDir);
            Path dest = avatarDir.resolve(fileName).normalize();
            Files.copy(file.getInputStream(), dest, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new AppException("Không lưu được file avatar", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        String avatarUrl = "/uploads/avatars/" + fileName;
        profile.setAvatarUrl(avatarUrl);
        userProfileRepository.save(profile);

        return avatarUrl;
    }

    private MeResponse toMeResponse(User user, UserProfile profile) {
        MeResponse res = new MeResponse();
        res.id = user.getId();
        res.username = user.getUsername();
        res.cccd = user.getCccd();
        res.fullName = user.getFullName();
        res.dateOfBirth = user.getDateOfBirth();
        res.active = user.isActive();

        res.roles = user.getRoles().stream()
                .map(r -> r.getName())
                .collect(Collectors.toSet());

        MeResponse.ProfileDto p = new MeResponse.ProfileDto();
        if (profile != null) {
            p.email = profile.getEmail();
            p.phone = profile.getPhone();
            p.address = profile.getAddress();
            p.avatarUrl = profile.getAvatarUrl();
            p.bio = profile.getBio();
        }
        res.profile = p;

        return res;
    }
}