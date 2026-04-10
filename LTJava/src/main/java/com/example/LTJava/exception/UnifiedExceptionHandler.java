package com.example.LTJava.exception;

import com.example.LTJava.user.exception.AppException;
import org.springframework.web.bind.MethodArgumentNotValidException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.http.converter.HttpMessageNotReadableException; // Sửa lỗi 'Cannot resolve symbol'


import java.time.Instant;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@ControllerAdvice
public class UnifiedExceptionHandler {
    private final Logger logger = LoggerFactory.getLogger(UnifiedExceptionHandler.class);

    // 1. Xử lý lỗi Validation (Ví dụ: CCCD không đủ 12 số) -> Trả về 400
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(MethodArgumentNotValidException ex) {
        Map<String, Object> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error ->
                errors.put(error.getField(), error.getDefaultMessage())
        );

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now());
        body.put("status", HttpStatus.BAD_REQUEST.value());
        body.put("errors", errors); // Trả về danh sách các trường bị lỗi

        return ResponseEntity.badRequest().body(body);
    }

    // 2. Xử lý AppException (Lỗi nghiệp vụ như Lock/Unlock/Role) -> Trả về Dynamic Status
    @ExceptionHandler(AppException.class)
    public ResponseEntity<Map<String, Object>> handleAppException(AppException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now());
        body.put("status", ex.getStatus().value());
        body.put("error", ex.getMessage());

        return ResponseEntity.status(ex.getStatus()).body(body);
    }

    // 3. Xử lý ResourceNotFoundException -> Trả về 404
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(ResourceNotFoundException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now());
        body.put("status", HttpStatus.NOT_FOUND.value());
        body.put("error", "Not Found");
        body.put("message", ex.getMessage());

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
    }

    // 4. Xử lý các lỗi Runtime/Illegal thông thường -> Trả về 400
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgument(IllegalArgumentException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now());
        body.put("status", 400);
        body.put("error", "Bad Request");
        body.put("message", ex.getMessage());

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    // 5. Chốt chặn cuối cùng: Xử lý tất cả các lỗi hệ thống khác -> Trả về 500
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleAllOthers(Exception ex) {
        logger.error("Unhandled exception: ", ex);
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now());
        body.put("status", 500);
        body.put("message", "Có lỗi xảy ra, vui lòng thử lại sau");

        return ResponseEntity.internalServerError().body(body);
    }

    // 6. Xử lý lỗi đọc JSON (Sai định dạng ngày tháng, sai kiểu dữ liệu field)
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, Object>> handleJsonError(HttpMessageNotReadableException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now());
        body.put("status", HttpStatus.BAD_REQUEST.value());
        body.put("error", "Bad Request");

        String message = "Dữ liệu gửi lên không đúng định dạng JSON hoặc sai kiểu dữ liệu.";

        // Lấy nguyên nhân gốc rễ của lỗi (Root Cause)
        Throwable rootCause = ex.getRootCause();
        if (rootCause != null && rootCause.getMessage().contains("java.time.LocalDateTime")) {
            message = "Định dạng ngày tháng không hợp lệ (Ví dụ đúng: 2026-04-14T23:59:59). " +
                    "Lưu ý: Ngày và tháng phải có đủ 2 chữ số.";
        }

        body.put("message", message);
        return ResponseEntity.badRequest().body(body);
    }
}