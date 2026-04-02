package com.example.LTJava.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public class UserImportRow {

    private int excelRowNumber;

    @NotBlank(message = "CCCD trong file không được trống")
    @Size(min = 12, max = 12, message = "CCCD tại dòng {excelRowNumber} phải đúng 12 số")
    private String cccd;

    @NotBlank(message = "Họ tên không được trống")
    private String fullName;

    @NotNull(message = "Ngày sinh không hợp lệ")
    private LocalDate dateOfBirth;

    private String roleName;

    // Getters và Setters...
    public int getExcelRowNumber() { return excelRowNumber; }
    public void setExcelRowNumber(int excelRowNumber) { this.excelRowNumber = excelRowNumber; }
    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}