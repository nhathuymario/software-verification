package com.example.LTJava.user.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    // 1. Bắt lỗi nghiệp vụ (Do mình tự ném ra bằng AppException)
    @ExceptionHandler(value = AppException.class)
    public ResponseEntity<Map<String, String>> handlingAppException(AppException exception) {
        Map<String, String> error = new HashMap<>();
        error.put("error", exception.getMessage());
        return ResponseEntity.status(exception.getStatus()).body(error);
    }

    // 2. Bắt lỗi Validation (Từ các Annotation @Size, @NotBlank ở DTO)
    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handlingValidation(MethodArgumentNotValidException exception) {
        Map<String, String> errors = new HashMap<>();
        exception.getBindingResult().getFieldErrors().forEach(error ->
                errors.put(error.getField(), error.getDefaultMessage())
        );
        return ResponseEntity.badRequest().body(errors);
    }

    // 3. Bắt các lỗi không xác định (Lỗi 500 - ví dụ NullPointer)
    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<String> handlingRuntimeException(Exception exception) {
        return ResponseEntity.internalServerError().body("Lỗi hệ thống: " + exception.getMessage());
    }
}