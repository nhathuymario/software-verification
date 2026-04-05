package com.example.LTJava.review.controller;

import java.util.List;

import com.example.LTJava.common.dto.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import com.example.LTJava.auth.security.CustomUserDetails;
import com.example.LTJava.review.entity.ReviewAssignment;
import com.example.LTJava.review.entity.ReviewStatus;
import com.example.LTJava.review.service.ReviewAssignmentService;

@RestController
@RequestMapping("/api/reviewer/reviews")
@PreAuthorize("hasRole('LECTURER') or hasRole('AA') or hasRole('HOD')")
public class ReviewerReviewController {

    private final ReviewAssignmentService service;

    public ReviewerReviewController(ReviewAssignmentService service) {
        this.service = service;
    }

    @GetMapping("/my")
    public ResponseEntity<List<ReviewAssignment>> my(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @RequestParam(value = "status", required = false) ReviewStatus status
    ) {
        return ResponseEntity.ok(service.myAssignments(currentUser.getId(), status));
    }

    @PutMapping("/{assignmentId}/start")
    public ResponseEntity<ApiResponse<ReviewAssignment>> start(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @PathVariable Long assignmentId
    ) {
        ReviewAssignment result = service.start(currentUser.getId(), assignmentId);
        return ResponseEntity.ok(
                ApiResponse.success("Bắt đầu thực hiện đánh giá thành công!", result)
        );
    }

    @PutMapping("/{assignmentId}/done")
    public ResponseEntity<ApiResponse<ReviewAssignment>> done(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @PathVariable Long assignmentId
    ) {

        ReviewAssignment result = service.done(currentUser.getId(), assignmentId);

        return ResponseEntity.ok(
                ApiResponse.success("Bạn đã hoàn thành đánh giá.", result)
        );
    }
}
