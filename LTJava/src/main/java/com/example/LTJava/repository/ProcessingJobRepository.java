package com.example.ltjava.repository;

import com.example.ltjava.entity.ProcessingJob;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Processing Job Repository - Track file processing từ Lambda
 */
@Repository
public interface ProcessingJobRepository extends JpaRepository<ProcessingJob, Long> {

    /**
     * Tìm job theo S3 key
     */
    Optional<ProcessingJob> findByS3Key(String s3Key);

    /**
     * Tìm tất cả jobs pending
     */
    @Query("SELECT j FROM ProcessingJob j WHERE j.status = 'PENDING' ORDER BY j.createdAt ASC")
    List<ProcessingJob> findAllPending();

    /**
     * Tìm tất cả jobs đang xử lý
     */
    @Query("SELECT j FROM ProcessingJob j WHERE j.status = 'PROCESSING' ORDER BY j.createdAt DESC")
    List<ProcessingJob> findAllProcessing();

    /**
     * Tìm jobs hoàn tất trong 24 giờ gần đây
     */
    @Query("SELECT j FROM ProcessingJob j WHERE j.status = 'COMPLETED' AND j.completedAt >= :since ORDER BY j.completedAt DESC")
    List<ProcessingJob> findRecentCompleted(@Param("since") LocalDateTime since);

    /**
     * Đếm jobs theo status
     */
    long countByStatus(ProcessingJob.JobStatus status);

    /**
     * Tìm failed jobs
     */
    @Query("SELECT j FROM ProcessingJob j WHERE j.status = 'FAILED' ORDER BY j.createdAt DESC")
    List<ProcessingJob> findAllFailed();

    /**
     * Tìm jobs chưa hoàn tát (PENDING hoặc PROCESSING)
     */
    @Query("SELECT j FROM ProcessingJob j WHERE j.status IN ('PENDING', 'PROCESSING') ORDER BY j.createdAt ASC")
    List<ProcessingJob> findUnfinishedJobs();

    /**
     * Tìm job theo Lambda request ID
     */
    Optional<ProcessingJob> findByLambdaRequestId(String lambdaRequestId);

    /**
     * Tìm jobs timeout (PROCESSING lâu hơn 5 phút)
     */
    @Query(value = "SELECT * FROM processing_jobs WHERE status = 'PROCESSING' AND updated_at < DATE_SUB(NOW(), INTERVAL 5 MINUTE) ORDER BY updated_at ASC", nativeQuery = true)
    List<ProcessingJob> findTimeoutJobs();

    /**
     * Tìm jobs theo file type
     */
    List<ProcessingJob> findByFileType(String fileType);

    /**
     * Tìm jobs tạo trong khoảng thời gian
     */
    @Query("SELECT j FROM ProcessingJob j WHERE j.createdAt BETWEEN :from AND :to ORDER BY j.createdAt DESC")
    List<ProcessingJob> findByDateRange(@Param("from") LocalDateTime from, @Param("to") LocalDateTime to);

    /**
     * Tổng file size processed
     */
    @Query("SELECT SUM(j.fileSize) FROM ProcessingJob j WHERE j.status = 'COMPLETED'")
    Long getTotalProcessedSize();

    /**
     * Trung bình processing time
     */
    @Query("SELECT AVG(j.processingTimeMs) FROM ProcessingJob j WHERE j.status = 'COMPLETED'")
    Double getAverageProcessingTime();
}

