package com.example.LTJava.syllabus.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.LTJava.auth.security.CustomUserDetails;
import com.example.LTJava.syllabus.entity.Course;
import com.example.LTJava.syllabus.entity.Syllabus;
import com.example.LTJava.syllabus.repository.CourseRepository;
import com.example.LTJava.syllabus.service.SyllabusService;

@RestController
@RequestMapping("/api/student/syllabus")
@PreAuthorize("hasRole('STUDENT')")
public class StudentSyllabusController {

    private final SyllabusService syllabusService;
    private final CourseRepository courseRepository;

    public StudentSyllabusController(SyllabusService syllabusService, CourseRepository courseRepository) {
        this.syllabusService = syllabusService;
        this.courseRepository = courseRepository;
    }

    // NEW: danh sách course mà student đã subscribe/đăng ký
    @GetMapping("/my-courses")
    public ResponseEntity<?> myCourses(@AuthenticationPrincipal CustomUserDetails currentUser) {
        Long userId = currentUser.getUser().getId();
        return ResponseEntity.ok(syllabusService.getMySubscribedCourses(userId));
    }

    @GetMapping("/available")
    public ResponseEntity<List<Course>> availableCourses(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @RequestParam(required = false) String academicYear,
            @RequestParam(required = false) String semester
    ) {
        Long userId = currentUser.getUser().getId();
        return ResponseEntity.ok(
                courseRepository.findAvailableCoursesForStudent(userId, academicYear, semester)
        );
    }

    // NEW: syllabus public của 1 course (chỉ cho phép nếu student đã subscribe course đó)
    @GetMapping("/course/{courseId}")
    public ResponseEntity<List<Syllabus>> publishedByCourse(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @PathVariable Long courseId
    ) {
        Long userId = currentUser.getUser().getId();
        return ResponseEntity.ok(syllabusService.getPublishedByCourseForStudent(userId, courseId));
    }

    @GetMapping("/search")
    public ResponseEntity<List<Syllabus>> search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String academicYear,
            @RequestParam(required = false) String semester
    ) {
        // NOTE: nếu muốn search cũng chỉ giới hạn trong course đã đăng ký,
        // thì đổi sang syllabusService.searchMySubscribedSyllabus(userId, keyword, academicYear, semester)
        return ResponseEntity.ok(syllabusService.searchSyllabus(keyword, academicYear, semester));
    }

    @GetMapping("/{id:\\d+}")
    public ResponseEntity<Syllabus> detail(@PathVariable Long id) {
        return ResponseEntity.ok(syllabusService.getSyllabusDetailPublic(id));
    }


    @PostMapping("/subscribe/{courseId}")
    public ResponseEntity<String> subscribe(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @PathVariable Long courseId
    ) {
        syllabusService.subscribeCourse(currentUser.getUser().getId(), courseId);
        return ResponseEntity.ok("Đăng ký nhận thông báo thành công!");
    }

    //hủy đăng ký nhận syllabus của course
    @DeleteMapping("/subscribe/{courseId}")
    public ResponseEntity<?> unsubscribe(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @PathVariable Long courseId
    ) {
        syllabusService.unsubscribeCourse(currentUser.getUser().getId(), courseId);
        return ResponseEntity.ok("Đã hủy đăng ký khóa học");
    }


    @GetMapping("/notifications")
    public ResponseEntity<?> notifications(@AuthenticationPrincipal CustomUserDetails currentUser) {
        return ResponseEntity.ok(syllabusService.getMyNotifications(currentUser.getUser().getId()));
    }
    
    //unread count
    @GetMapping("/notifications/unread-count")
    public ResponseEntity<Long> unreadCount(@AuthenticationPrincipal CustomUserDetails currentUser) {
        return ResponseEntity.ok(syllabusService.countUnread(currentUser.getUser().getId()));
    }

    //mark 1 notification as read
    @PatchMapping("/notifications/{id}/read")
    public ResponseEntity<?> markRead(
            @AuthenticationPrincipal CustomUserDetails currentUser,
            @PathVariable Long id
    ) {
        syllabusService.markNotificationRead(currentUser.getUser().getId(), id);
        return ResponseEntity.ok().build();
    }

    //mark all as read
    @PostMapping("/notifications/read-all")
    public ResponseEntity<?> readAll(@AuthenticationPrincipal CustomUserDetails currentUser) {
        syllabusService.readAllNotifications(currentUser.getUser().getId());
        return ResponseEntity.ok().build();
    }
}
