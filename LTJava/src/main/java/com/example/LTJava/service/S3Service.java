package com.example.ltjava.service;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.PutObjectResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * S3 Service - Handle file upload/download từ AWS S3
 * Sử dụng cho việc lưu trữ file (PDF, Image, Excel, v.v.)
 */
@Service
@Slf4j
@Profile({"rds", "docker", "prod"})
public class S3Service {

    @Autowired
    private AmazonS3 amazonS3;

    @Value("${aws.s3.bucket-name:ltjava-storage}")
    private String bucketName;

    @Value("${aws.s3.region:us-east-1}")
    private String region;

    /**
     * Upload file đến S3
     *
     * @param file       file cần upload
     * @param folderPath thư mục trong S3 (e.g., "uploads/syllabus")
     * @return S3 file URL
     * @throws IOException nếu không đọc được file
     */
    public String uploadFile(MultipartFile file, String folderPath) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File không được để trống");
        }

        String fileName = generateFileName(file.getOriginalFilename(), folderPath);
        
        try (InputStream inputStream = file.getInputStream()) {
            uploadFileToS3(fileName, inputStream, file.getSize(), file.getContentType());
            log.info("✅ File uploaded to S3: {}", fileName);
            return getFileUrl(fileName);
        } catch (IOException e) {
            log.error("❌ Failed to upload file to S3", e);
            throw new IOException("Failed to upload file: " + e.getMessage(), e);
        }
    }

    /**
     * Upload file byte array đến S3
     *
     * @param fileBytes   file content as bytes
     * @param fileName    tên file trên S3
     * @param contentType MIME type
     * @return S3 file URL
     */
    public String uploadFileBytes(byte[] fileBytes, String fileName, String contentType) {
        try {
            uploadFileToS3(fileName, new java.io.ByteArrayInputStream(fileBytes), 
                          fileBytes.length, contentType);
            log.info("✅ Bytes uploaded to S3: {}", fileName);
            return getFileUrl(fileName);
        } catch (Exception e) {
            log.error("❌ Failed to upload bytes to S3", e);
            throw new RuntimeException("Failed to upload file: " + e.getMessage(), e);
        }
    }

    /**
     * Download file từ S3
     *
     * @param fileName tên file trên S3
     * @return file content as bytes
     */
    public byte[] downloadFile(String fileName) {
        try {
            com.amazonaws.services.s3.model.S3Object s3Object = 
                    amazonS3.getObject(new GetObjectRequest(bucketName, fileName));
            
            try (InputStream inputStream = s3Object.getObjectContent()) {
                return inputStream.readAllBytes();
            }
        } catch (AmazonServiceException e) {
            if (e.getStatusCode() == 404) {
                throw new RuntimeException("File not found: " + fileName);
            }
            throw new RuntimeException("Failed to download file: " + e.getMessage(), e);
        } catch (IOException e) {
            throw new RuntimeException("Failed to read file: " + e.getMessage(), e);
        }
    }

    /**
     * Delete file từ S3
     *
     * @param fileName tên file trên S3
     */
    public void deleteFile(String fileName) {
        try {
            amazonS3.deleteObject(bucketName, fileName);
            log.info("✅ File deleted from S3: {}", fileName);
        } catch (Exception e) {
            log.error("❌ Failed to delete file from S3", e);
            throw new RuntimeException("Failed to delete file: " + e.getMessage(), e);
        }
    }

    /**
     * Check nếu file tồn tại trên S3
     *
     * @param fileName tên file
     * @return true nếu file tồn tại
     */
    public boolean fileExists(String fileName) {
        try {
            return amazonS3.doesObjectExist(bucketName, fileName);
        } catch (Exception e) {
            log.warn("Failed to check file existence: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Get file size từ S3
     *
     * @param fileName tên file
     * @return size in bytes
     */
    public long getFileSize(String fileName) {
        try {
            ObjectMetadata metadata = amazonS3.getObjectMetadata(bucketName, fileName);
            return metadata.getContentLength();
        } catch (Exception e) {
            log.warn("Failed to get file size: {}", e.getMessage());
            return 0;
        }
    }

    /**
     * Get presigned URL (for temporary access)
     *
     * @param fileName        tên file
     * @param expirationMinutes hết hạn sau bao nhiêu phút
     * @return presigned URL
     */
    public String getPresignedUrl(String fileName, int expirationMinutes) {
        try {
            java.util.Date expiration = new java.util.Date();
            long expTimeMillis = expiration.getTime() + (expirationMinutes * 60 * 1000);
            expiration.setTime(expTimeMillis);

            com.amazonaws.services.s3.model.GeneratePresignedUrlRequest generatePresignedUrlRequest =
                    new com.amazonaws.services.s3.model.GeneratePresignedUrlRequest(bucketName, fileName)
                            .withMethod(com.amazonaws.HttpMethod.GET)
                            .withExpiration(expiration);

            java.net.URL url = amazonS3.generatePresignedUrl(generatePresignedUrlRequest);
            return url.toString();
        } catch (Exception e) {
            log.error("Failed to generate presigned URL", e);
            throw new RuntimeException("Failed to generate presigned URL: " + e.getMessage(), e);
        }
    }

    // ========== Private Helper Methods ==========

    /**
     * Generate unique file name
     */
    private String generateFileName(String originalFileName, String folderPath) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        String fileExtension = getFileExtension(originalFileName);
        String nameWithoutExt = getFileNameWithoutExtension(originalFileName);
        
        return String.format("%s/%s_%s_%s.%s",
                folderPath, nameWithoutExt, timestamp, uuid, fileExtension);
    }

    /**
     * Upload file tới S3
     */
    private void uploadFileToS3(String fileName, InputStream inputStream, 
                               long size, String contentType) {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(size);
        if (contentType != null) {
            metadata.setContentType(contentType);
        }

        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, fileName, 
                                                                  inputStream, metadata);
        
        // Enable server-side encryption
        metadata.setSSEAlgorithm(ObjectMetadata.AES_256_SERVER_SIDE_ENCRYPTION);
        
        amazonS3.putObject(putObjectRequest);
    }

    /**
     * Get S3 file URL
     */
    private String getFileUrl(String fileName) {
        return String.format("https://%s.s3.%s.amazonaws.com/%s", 
                bucketName, region, fileName);
    }

    /**
     * Get file extension
     */
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf(".");
        return lastDot > 0 ? fileName.substring(lastDot + 1) : "";
    }

    /**
     * Get file name without extension
     */
    private String getFileNameWithoutExtension(String fileName) {
        int lastDot = fileName.lastIndexOf(".");
        return lastDot > 0 ? fileName.substring(0, lastDot) : fileName;
    }
}

