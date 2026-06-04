package com.example.ltjava.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * Processing Job Entity - Track file processing từ Lambda
 * Ánh xạ tới bảng 'processing_jobs' trong RDS
 */
@Entity
@Table(name = "processing_jobs", indexes = {
    @Index(name = "idx_status", columnList = "status"),
    @Index(name = "idx_created_at", columnList = "created_at"),
    @Index(name = "idx_s3_key", columnList = "s3_key")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProcessingJob {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "s3_key", nullable = false, length = 500)
    private String s3Key;  // S3 file path: uploads/syllabus/file_20240601_12345.pdf

    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;  // Original file name

    @Column(name = "file_size")
    private Long fileSize;  // File size in bytes

    @Column(name = "file_type", length = 50)
    private String fileType;  // MIME type: application/pdf, image/jpeg

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    @Builder.Default
    private JobStatus status = JobStatus.PENDING;

    @Column(name = "progress", nullable = false)
    @Builder.Default
    private Integer progress = 0;  // 0-100

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;  // Error details nếu có

    @Column(name = "result_data", columnDefinition = "LONGTEXT")
    private String resultData;  // JSON kết quả processing

    @Column(name = "lambda_request_id", length = 255)
    private String lambdaRequestId;  // AWS Lambda request ID

    @Column(name = "processing_time_ms")
    private Long processingTimeMs;  // Thời gian xử lý (ms)

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;  // Khi job hoàn tất

    /**
     * Job Status Enum
     */
    public enum JobStatus {
        PENDING("Chờ xử lý"),
        PROCESSING("Đang xử lý"),
        COMPLETED("Hoàn tất"),
        FAILED("Lỗi"),
        CANCELLED("Đã hủy");

        private final String displayName;

        JobStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    // Business methods
    public boolean isCompleted() {
        return this.status == JobStatus.COMPLETED;
    }

    public boolean isFailed() {
        return this.status == JobStatus.FAILED;
    }

    public boolean isProcessing() {
        return this.status == JobStatus.PROCESSING;
    }

    public void markCompleted(String result) {
        this.status = JobStatus.COMPLETED;
        this.progress = 100;
        this.resultData = result;
        this.completedAt = LocalDateTime.now();
    }

    public void markFailed(String error) {
        this.status = JobStatus.FAILED;
        this.errorMessage = error;
        this.completedAt = LocalDateTime.now();
    }

    public void updateProgress(int progress, String message) {
        this.progress = Math.min(progress, 100);
        this.errorMessage = message;  // Can be used for status message
    }

    @PrePersist
    protected void onCreate() {
        if (this.status == null) {
            this.status = JobStatus.PENDING;
        }
        if (this.progress == null) {
            this.progress = 0;
        }
    }
}

