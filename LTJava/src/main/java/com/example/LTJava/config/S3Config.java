package com.example.ltjava.config;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * AWS S3 Configuration
 * Kết nối Spring Boot với S3 Bucket
 */
@Configuration
@Profile({"rds", "docker", "prod"})
public class S3Config {

    @Value("${aws.s3.region:us-east-1}")
    private String region;

    @Value("${aws.s3.endpoint:}")
    private String endpoint;

    @Value("${aws.access.key.id:}")
    private String accessKey;

    @Value("${aws.secret.access.key:}")
    private String secretKey;

    /**
     * Create S3 Client Bean
     * @return AmazonS3 client
     */
    @Bean
    public AmazonS3 amazonS3Client() {
        AmazonS3ClientBuilder builder = AmazonS3ClientBuilder.standard()
                .withRegion(region);

        // Use custom endpoint if provided (for testing/local)
        if (endpoint != null && !endpoint.isEmpty()) {
            builder.withEndpointConfiguration(
                    new AwsClientBuilder.EndpointConfiguration(endpoint, region)
            ).withPathStyleAccessEnabled(true);
        }

        // Use credentials if provided (from env vars)
        if (accessKey != null && !accessKey.isEmpty() && secretKey != null && !secretKey.isEmpty()) {
            builder.withCredentials(
                    new AWSStaticCredentialsProvider(
                            new BasicAWSCredentials(accessKey, secretKey)
                    )
            );
        } else {
            // Use default credential provider chain (IAM role, environment, etc.)
            builder.withCredentials(new com.amazonaws.auth.DefaultAWSCredentialsProviderChain());
        }

        return builder.build();
    }
}

