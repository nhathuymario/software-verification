package com.example.LTJava.syllabuscomment.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.LTJava.auth.security.CustomUserDetails;
import com.example.LTJava.syllabuscomment.dto.CommentRequest;
import com.example.LTJava.syllabuscomment.dto.CommentResponse;
import com.example.LTJava.syllabuscomment.service.SyllabusCommentService;

@RestController
@RequestMapping("/api")
@PreAuthorize("hasRole('LECTURER') or hasRole('AA') or hasRole('HOD')")
public class SyllabusCommentController {

    private final SyllabusCommentService service;

    public SyllabusCommentController(SyllabusCommentService service) {
        this.service = service;
    }

    // ===== comment theo syllabus (không assignment) =====
    @PostMapping("/syllabus/{id}/comments")
    public CommentResponse add(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails user,
            @RequestBody CommentRequest req) {

        return service.addComment(id, user.getUser().getId(), req.getContent());
    }

    @GetMapping("/syllabus/{id}/comments")
    public List<CommentResponse> list(@PathVariable Long id) {
        return service.getComments(id);
    }

    // ===== comment theo assignment (collaborative review) =====
    @PostMapping("/reviews/{assignmentId}/comments")
    public CommentResponse addForAssignment(
            @PathVariable Long assignmentId,
            @AuthenticationPrincipal CustomUserDetails user,
            @RequestBody CommentRequest req
    ) {
        return service.addCommentForAssignment(assignmentId, user.getUser().getId(), req.getContent());
    }

    @GetMapping("/reviews/{assignmentId}/comments")
    public List<CommentResponse> listForAssignment(@PathVariable Long assignmentId) {
        return service.getCommentsByAssignment(assignmentId);
    }

    @PutMapping("/comments/{commentId}")
    public CommentResponse update(
            @PathVariable Long commentId,
            @AuthenticationPrincipal CustomUserDetails user,
            @RequestBody CommentRequest req) {

        return service.updateComment(commentId, user.getUser().getId(), req.getContent());
    }

    @DeleteMapping("/comments/{commentId}")
    public void delete(
            @PathVariable Long commentId,
            @AuthenticationPrincipal CustomUserDetails user) {

        service.deleteComment(commentId, user.getUser().getId());
    }

    @GetMapping("/lecturer/syllabus/{id}/comments")
    @PreAuthorize("hasRole('LECTURER')")
    public List<CommentResponse> listForLecturer(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails user
    ) {
        return service.getCommentsForOwner(id, user.getId());
    }

}
