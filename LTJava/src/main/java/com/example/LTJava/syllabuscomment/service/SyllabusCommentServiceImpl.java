package com.example.LTJava.syllabuscomment.service;

import com.example.LTJava.review.entity.ReviewAssignment;
import com.example.LTJava.review.entity.ReviewStatus;
import com.example.LTJava.review.repository.ReviewAssignmentRepository;
import com.example.LTJava.syllabus.entity.Syllabus;
import com.example.LTJava.syllabus.entity.SyllabusStatus;
import com.example.LTJava.syllabus.repository.SyllabusRepository;
import com.example.LTJava.syllabuscomment.dto.CommentResponse;
import com.example.LTJava.syllabuscomment.entity.CommentStatus;
import com.example.LTJava.syllabuscomment.entity.SyllabusComment;
import com.example.LTJava.syllabuscomment.repository.SyllabusCommentRepository;
import com.example.LTJava.user.entity.User;
import com.example.LTJava.user.exception.AppException;
import org.springframework.http.HttpStatus;
import com.example.LTJava.user.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SyllabusCommentServiceImpl implements SyllabusCommentService {

    private final SyllabusRepository syllabusRepo;
    private final UserRepository userRepo;
    private final SyllabusCommentRepository commentRepo;

    // ✅ thêm assignmentRepo
    private final ReviewAssignmentRepository assignmentRepo;

    public SyllabusCommentServiceImpl(
            SyllabusRepository syllabusRepo,
            UserRepository userRepo,
            SyllabusCommentRepository commentRepo,
            ReviewAssignmentRepository assignmentRepo
    ) {
        this.syllabusRepo = syllabusRepo;
        this.userRepo = userRepo;
        this.commentRepo = commentRepo;
        this.assignmentRepo = assignmentRepo;
    }

    // ===== Comment kiểu cũ (không assignment) =====
    @Override
    public CommentResponse addComment(Long syllabusId, Long lecturerId, String content) {
        Syllabus syllabus = syllabusRepo.findById(syllabusId)
                .orElseThrow(() -> new RuntimeException("Syllabus không tồn tại"));

        // ✅ collaborative review bạn muốn ở DRAFT
        if (syllabus.getStatus() != SyllabusStatus.DRAFT) {
            throw new RuntimeException("Chỉ được comment khi syllabus ở trạng thái DRAFT");
        }

        User commenter = userRepo.findById(lecturerId)
                .orElseThrow(() -> new RuntimeException("User không tồn tại"));

        SyllabusComment c = new SyllabusComment();
        c.setSyllabus(syllabus);
        c.setCommenter(commenter);
        c.setContent(content);
        c.setAssignment(null); // không assignment

        return toDTO(commentRepo.save(c));
    }

    // ===== ✅ Comment trong collaborative review (theo assignment) =====
    @Override
    public CommentResponse addCommentForAssignment(Long assignmentId, Long lecturerId, String content) {
        // 1. Dùng AppException với 404 cho trường hợp không tồn tại
        ReviewAssignment assignment = assignmentRepo.findById(assignmentId)
                .orElseThrow(() -> new AppException("Phân công đánh giá không tồn tại", HttpStatus.NOT_FOUND));

        // 2. Chặn comment khi đã kết thúc
        ReviewStatus rs = assignment.getStatus();
        if (rs == ReviewStatus.DONE || rs == ReviewStatus.CANCELLED) {
            throw new AppException("Không thể bình luận khi quy trình review đã kết thúc hoặc bị hủy", HttpStatus.BAD_REQUEST);
        }

        // 3. Kiểm tra đúng chủ sở hữu (403 Forbidden)
        if (!assignment.getReviewer().getId().equals(lecturerId)) {
            throw new AppException("Bạn không có quyền bình luận trên phân công này", HttpStatus.FORBIDDEN);
        }

        Syllabus syllabus = assignment.getSyllabus();
        if (syllabus.getStatus() != SyllabusStatus.DRAFT) {
            throw new AppException("Chỉ được bình luận khi Syllabus đang ở trạng thái DRAFT", HttpStatus.BAD_REQUEST);
        }

        User commenter = userRepo.findById(lecturerId)
                .orElseThrow(() -> new AppException("Người dùng không tồn tại", HttpStatus.NOT_FOUND));

        SyllabusComment c = new SyllabusComment();
        c.setSyllabus(syllabus);
        c.setAssignment(assignment);
        c.setCommenter(commenter);
        c.setContent(content);

        return toDTO(commentRepo.save(c));
    }

    @Override
    public List<CommentResponse> getComments(Long syllabusId) {
        return commentRepo
                .findBySyllabus_IdAndStatusOrderByCreatedAtAsc(syllabusId, CommentStatus.ACTIVE)
                .stream()
                .map(this::toDTO)
                .toList();
    }

    @Override
    public List<CommentResponse> getCommentsForOwner(Long syllabusId, Long lecturerId) {

        boolean ok = syllabusRepo.existsByIdAndCreatedBy_Id(syllabusId, lecturerId);
        if (!ok) {
            throw new RuntimeException("Bạn không có quyền xem review của syllabus này");
        }

        return commentRepo
                .findBySyllabus_IdAndStatusOrderByCreatedAtAsc(syllabusId, CommentStatus.ACTIVE)
                .stream()
                .map(this::toDTO)
                .toList();
    }




    @Override
    public List<CommentResponse> getCommentsByAssignment(Long assignmentId) {
        return commentRepo
                .findByAssignment_IdAndStatusOrderByCreatedAtAsc(assignmentId, CommentStatus.ACTIVE)
                .stream()
                .map(this::toDTO)
                .toList();
    }

    @Override
    public CommentResponse updateComment(Long commentId, Long lecturerId, String content) {
        SyllabusComment c = commentRepo.findById(commentId)
                .orElseThrow(() -> new AppException("Bình luận không tồn tại", HttpStatus.NOT_FOUND));

        // Kiểm tra quyền sửa (Chỉ chủ nhân comment mới được sửa)
        if (!c.getCommenter().getId().equals(lecturerId)) {
            throw new AppException("Bạn không có quyền chỉnh sửa bình luận của người khác", HttpStatus.FORBIDDEN);
        }

        // Khóa sửa nếu Review đã xong
        if (c.getAssignment() != null) {
            ReviewStatus rs = c.getAssignment().getStatus();
            if (rs == ReviewStatus.DONE || rs == ReviewStatus.CANCELLED) {
                throw new AppException("Quy trình review đã đóng, không thể chỉnh sửa bình luận", HttpStatus.BAD_REQUEST);
            }
        }

        c.setContent(content);
        return toDTO(commentRepo.save(c));
    }

    @Override
    public void deleteComment(Long commentId, Long lecturerId) {
        SyllabusComment c = commentRepo.findById(commentId)
                .orElseThrow(() -> new AppException("Bình luận không tồn tại", HttpStatus.NOT_FOUND));

        if (!c.getCommenter().getId().equals(lecturerId)) {
            throw new AppException("Bạn không có quyền xóa bình luận này", HttpStatus.FORBIDDEN);
        }

        if (c.getAssignment() != null) {
            ReviewStatus rs = c.getAssignment().getStatus();
            if (rs == ReviewStatus.DONE || rs == ReviewStatus.CANCELLED) {
                throw new AppException("Không thể xóa bình luận sau khi review đã hoàn thành", HttpStatus.BAD_REQUEST);
            }
        }

        c.setStatus(CommentStatus.DELETED);
        commentRepo.save(c);
    }

    private CommentResponse toDTO(SyllabusComment c) {
        CommentResponse dto = new CommentResponse();
        dto.setId(c.getId());
        dto.setContent(c.getContent());
        dto.setCommenterId(c.getCommenter().getId());
        dto.setCommenterName(c.getCommenter().getFullName());
        dto.setCreatedAt(c.getCreatedAt());
        dto.setUpdatedAt(c.getUpdatedAt());

        // optional: thêm assignmentId cho FE nếu bạn muốn mở rộng DTO
        // dto.setAssignmentId(c.getAssignment() != null ? c.getAssignment().getId() : null);

        return dto;
    }
}
