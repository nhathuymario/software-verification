package com.example.LTJava.review.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.example.LTJava.syllabus.entity.Notification;
import com.example.LTJava.syllabus.repository.NotificationRepository;
import com.example.LTJava.syllabus.service.AIService;
import com.example.LTJava.user.exception.AppException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.LTJava.review.entity.ReviewAssignment;
import com.example.LTJava.review.entity.ReviewStatus;
import com.example.LTJava.review.repository.ReviewAssignmentRepository;
import com.example.LTJava.syllabus.entity.Syllabus;
import com.example.LTJava.syllabus.entity.SyllabusStatus;
import com.example.LTJava.syllabus.repository.SyllabusRepository;
import com.example.LTJava.user.entity.User;
import com.example.LTJava.user.repository.UserRepository;

@Service
@Transactional
public class ReviewAssignmentServiceImpl implements ReviewAssignmentService {

    private final ReviewAssignmentRepository repo;
    private final SyllabusRepository syllabusRepository;
    private final UserRepository userRepository;
    private final NotificationRepository notificationRepository;
    private final AIService aiService;

    public ReviewAssignmentServiceImpl(
            ReviewAssignmentRepository repo,
            SyllabusRepository syllabusRepository,
            UserRepository userRepository,
            NotificationRepository notificationRepository,
            AIService aiService
    ) {
        this.repo = repo;
        this.syllabusRepository = syllabusRepository;
        this.userRepository = userRepository;
        this.notificationRepository = notificationRepository;
        this.aiService = aiService;
    }

    // 1. Triển khai listForSyllabus (Cái bạn đang bị báo lỗi)
    @Override
    @Transactional(readOnly = true)
    public List<ReviewAssignment> listForSyllabus(Long syllabusId) {
        return repo.findBySyllabus_IdOrderByCreatedAtDesc(syllabusId);
    }

    // 2. Triển khai assignByUsernames với AppException
    @Override
    public List<ReviewAssignment> assignByUsernames(
            Long hodId,
            Long syllabusId,
            List<String> reviewerUsernames,
            LocalDateTime dueAt
    ) {
        if (reviewerUsernames == null || reviewerUsernames.isEmpty()) {
            throw new AppException("Danh sách người đánh giá không được trống", HttpStatus.BAD_REQUEST);
        }
        if (dueAt == null || !dueAt.isAfter(LocalDateTime.now())) {
            throw new AppException("Hạn chót phải lớn hơn thời gian hiện tại", HttpStatus.BAD_REQUEST);
        }

        Syllabus syllabus = syllabusRepository.findById(syllabusId)
                .orElseThrow(() -> new AppException("Syllabus không tồn tại", HttpStatus.NOT_FOUND));

        if (syllabus.getStatus() != SyllabusStatus.DRAFT) {
            throw new AppException("Chỉ có thể phân công khi Syllabus ở trạng thái DRAFT", HttpStatus.BAD_REQUEST);
        }

        User hod = userRepository.findById(hodId)
                .orElseThrow(() -> new AppException("HOD không tồn tại", HttpStatus.NOT_FOUND));

        List<ReviewAssignment> created = new ArrayList<>();
        for (String raw : reviewerUsernames) {
            if (raw == null || raw.trim().isEmpty()) continue;
            String username = raw.trim();

            User reviewer = userRepository.findByUsername(username)
                    .orElseThrow(() -> new AppException("Reviewer " + username + " không tồn tại", HttpStatus.NOT_FOUND));

            var existingOpt = repo.findBySyllabus_IdAndReviewer_Id(syllabusId, reviewer.getId());

            ReviewAssignment assignment;
            if (existingOpt.isPresent()) {
                assignment = existingOpt.get();
                if (assignment.getStatus() == ReviewStatus.ASSIGNED || assignment.getStatus() == ReviewStatus.IN_REVIEW) {
                    continue; // Đang làm rồi thì bỏ qua
                }
                // Reset để làm lại
                assignment.setAssignedBy(hod);
                assignment.setDueAt(dueAt);
                assignment.setStatus(ReviewStatus.ASSIGNED);
                assignment.setStartedAt(null);
                assignment.setCompletedAt(null);
            } else {
                assignment = new ReviewAssignment();
                assignment.setSyllabus(syllabus);
                assignment.setReviewer(reviewer);
                assignment.setAssignedBy(hod);
                assignment.setDueAt(dueAt);
                assignment.setStatus(ReviewStatus.ASSIGNED);
            }

            ReviewAssignment saved = repo.save(assignment);
            created.add(saved);
            sendNotification(reviewer, syllabus, dueAt);
        }
        return created;
    }

    // 3. Triển khai myAssignments
    @Override
    @Transactional(readOnly = true)
    public List<ReviewAssignment> myAssignments(Long reviewerId, ReviewStatus statusOrNull) {
        if (statusOrNull == null) {
            return repo.findByReviewer_IdOrderByDueAtAsc(reviewerId);
        }
        return repo.findByReviewer_IdAndStatusOrderByDueAtAsc(reviewerId, statusOrNull);
    }

    // 4. Triển khai start
    @Override
    public ReviewAssignment start(Long reviewerId, Long assignmentId) {
        ReviewAssignment a = repo.findByIdAndReviewer_Id(assignmentId, reviewerId)
                .orElseThrow(() -> new AppException("Phân công không tồn tại", HttpStatus.NOT_FOUND));

        if (a.getStatus() == ReviewStatus.CANCELLED) throw new AppException("Đã bị hủy", HttpStatus.BAD_REQUEST);


        if (a.getStatus() == ReviewStatus.DONE) {
            throw new AppException("Đánh giá này đã được bắt đầu từ trước", HttpStatus.CONFLICT);
        }

        a.setStatus(ReviewStatus.IN_REVIEW);
        if (a.getStartedAt() == null) a.setStartedAt(LocalDateTime.now());
        return repo.save(a);
    }

    // 5. Triển khai done
    @Override
    public ReviewAssignment done(Long reviewerId, Long assignmentId) {
        // 1. Kiểm tra tồn tại
        ReviewAssignment a = repo.findByIdAndReviewer_Id(assignmentId, reviewerId)
                .orElseThrow(() -> new AppException("Phân công không tồn tại", HttpStatus.NOT_FOUND));

        // 2. Kiểm tra nếu đã bị hủy
        if (a.getStatus() == ReviewStatus.CANCELLED) {
            throw new AppException("Không thể hoàn thành vì phân công này đã bị hủy", HttpStatus.BAD_REQUEST);
        }

        // 3. Kiểm tra logic "vô lý": Chưa bắt đầu (Start) mà đã bấm hoàn thành (Done)
        if (a.getStatus() == ReviewStatus.IN_REVIEW || a.getStartedAt() == null) {
            throw new AppException("Bạn phải bắt đầu đánh giá trước khi bấm hoàn thành", HttpStatus.BAD_REQUEST);
        }

        // 4. Kiểm tra nếu đã hoàn thành trước đó rồi (Tránh bấm nhầm 2 lần)
        if (a.getStatus() == ReviewStatus.DONE) {
            throw new AppException("Đánh giá này đã được hoàn thành từ trước", HttpStatus.CONFLICT);
        }

        // 5. Kiểm tra thời hạn (Nếu dự án của bạn có cột dueAt)
    /*
    if (a.getDueAt() != null && a.getDueAt().isBefore(LocalDateTime.now())) {
        throw new AppException("Đã quá hạn nộp đánh giá", HttpStatus.BAD_REQUEST);
    }
    */

        // 6. Thực hiện cập nhật nếu mọi thứ hợp lệ
        a.setStatus(ReviewStatus.DONE);
        a.setCompletedAt(LocalDateTime.now());

        return repo.save(a);
    }

    // 6. Triển khai cancel
    @Override
    public void cancel(Long hodId, Long assignmentId) {
        // 1. Tìm bản phân công
        ReviewAssignment a = repo.findById(assignmentId)
                .orElseThrow(() -> new AppException("Phân công không tồn tại", HttpStatus.NOT_FOUND));

        // 2. Kiểm tra nếu đã bị hủy rồi (Chống spam/logic thừa)
        if (a.getStatus() == ReviewStatus.CANCELLED) {
            throw new AppException("Bản phân công này đã được hủy trước đó rồi.", HttpStatus.CONFLICT);
        }

        // 3. (Tùy chọn) Chặn hủy nếu đã hoàn thành (DONE)
        if (a.getStatus() == ReviewStatus.DONE) {
            throw new AppException("Không thể hủy bản phân công đã hoàn thành.", HttpStatus.BAD_REQUEST);
        }

        // 4. Thực hiện hủy
        a.setStatus(ReviewStatus.CANCELLED);
        repo.save(a);
        throw new AppException("Hủy phân công đánh giá thành công!", HttpStatus.OK);

    }

    // 7. Triển khai listAllForHod (Search)
    @Override
    @Transactional(readOnly = true)
    public List<ReviewAssignment> listAllForHod(
            Long courseId, Long syllabusId, ReviewStatus status,
            String reviewer, LocalDateTime fromDue, LocalDateTime toDue
    ) {
        return repo.searchForHod(courseId, syllabusId, status, reviewer, fromDue, toDue);
    }

    // Hàm phụ trợ gửi Notification
    private void sendNotification(User reviewer, Syllabus syllabus, LocalDateTime dueAt) {
        String msg = aiService.createRoleNotificationMessage(
                "REVIEWER", "Phân công review giáo trình",
                syllabus.getCourse().getName(), syllabus.getTitle(),
                syllabus.getVersion(), "Hạn: " + dueAt, syllabus.getId()
        );
        Notification n = new Notification();
        n.setUser(reviewer);
        n.setMessage(msg);
        n.setRead(false);
        n.setCreatedAt(LocalDateTime.now());
        notificationRepository.save(n);
    }
}
