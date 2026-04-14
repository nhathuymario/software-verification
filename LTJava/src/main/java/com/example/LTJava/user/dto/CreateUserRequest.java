package com.example.LTJava.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.*;

import java.time.LocalDate;

public class CreateUserRequest {

    @NotBlank(message = "Họ tên không được để trống")
    @Size(min = 2, message = "Họ tên quá ngắn (tối thiểu phải có 2 ký tự)") // Biên dưới: 1 ký tự sẽ lỗi
    @Size(max = 100, message = "Họ tên quá dài (tối đa chỉ 100 ký tự)")    // Biên trên: 101 ký tự sẽ lỗi
    private String fullName;

    @NotBlank(message = "CCCD không được để trống")
    @Pattern(regexp = "^[0-9]+$", message = "CCCD chỉ được chứa các chữ số")
// Kiểm tra biên dưới (11 ký tự)
    @Size(min = 12, message = "CCCD đang ngắn hơn quy định (phải đủ 12 chữ số)")
// Kiểm tra biên trên (13 ký tự)
    @Size(max = 12, message = "CCCD đang dài hơn quy định (chỉ được tối đa 12 chữ số)")
    private String cccd;

    @NotNull(message = "Ngày sinh không được để trống")
    @Past(message = "Ngày sinh phải là ngày trong quá khứ")
    @JsonFormat(pattern = "dd/MM/yyyy")
    private LocalDate dateOfBirth;

    private String roleName;

    public CreateUserRequest() {}


    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public LocalDate  getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate  dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}