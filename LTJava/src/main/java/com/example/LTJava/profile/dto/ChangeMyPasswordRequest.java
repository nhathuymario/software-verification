package com.example.LTJava.profile.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class ChangeMyPasswordRequest {

    @NotBlank(message = "Mật khẩu hiện tại không được để trống")
    private String currentPassword;

    @NotBlank(message = "Mật khẩu mới không được để trống")
    // Áp dụng BVA: Min 8, Max 12 cho mật khẩu mới
    @Size(min = 8, max = 12, message = "Mật khẩu mới phải từ 8 đến 12 ký tự")
    private String newPassword;

    public String getCurrentPassword() { return currentPassword; }
    public void setCurrentPassword(String currentPassword) { this.currentPassword = currentPassword; }

    public String getNewPassword() { return newPassword; }
    public void setNewPassword(String newPassword) { this.newPassword = newPassword; }
}