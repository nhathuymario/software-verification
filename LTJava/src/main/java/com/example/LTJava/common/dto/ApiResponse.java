package com.example.LTJava.common.dto; // Thay đổi theo package bạn chọn

import lombok.*;
import java.time.Instant;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private Instant timestamp;
    private int status;
    private String message;
    private T data;

    // Constructor nhanh để dùng cho thành công
    public static <T> ApiResponse<T> success(String message, T data) {
        return ApiResponse.<T>builder()
                .timestamp(Instant.now())
                .status(200)
                .message(message)
                .data(data)
                .build();
    }
}