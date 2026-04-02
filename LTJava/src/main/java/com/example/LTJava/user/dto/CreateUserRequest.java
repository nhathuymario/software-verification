package com.example.LTJava.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class CreateUserRequest {

    @NotBlank(message = "Họ tên không được để trống")
    @Size(min = 2, max = 100, message = "Họ tên phải từ 2 đến 100 ký tự")
    private String fullName;

    @NotBlank(message = "CCCD không được để trống")
    // BVA: Min=12, Max=12 đảm bảo độ dài chính xác
    @Size(min = 12, max = 12, message = "CCCD phải có đúng 12 chữ số")
    @Pattern(regexp = "^[0-9]+$", message = "CCCD chỉ được chứa các chữ số")
    private String cccd;

    @NotBlank(message = "Ngày sinh không được để trống")
    @Pattern(regexp = "^\\d{2}/\\d{2}/\\d{4}$", message = "Ngày sinh phải đúng định dạng dd/MM/yyyy")
    private String dateOfBirth;

    private String roleName;

    public CreateUserRequest() {}


    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}