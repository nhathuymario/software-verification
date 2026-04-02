-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2026 at 06:12 AM
-- Server version: 9.1.0
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ltjavatest`
--

-- --------------------------------------------------------

--
-- Table structure for table `clo`
--

CREATE TABLE `clo` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `syllabus_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clo_plo_map`
--

CREATE TABLE `clo_plo_map` (
  `id` bigint NOT NULL,
  `level` tinyint DEFAULT NULL,
  `clo_id` bigint NOT NULL,
  `plo_id` bigint NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` bigint NOT NULL,
  `academic_year` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `credits` int DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `lecturer_id` bigint NOT NULL,
  `lecturer_username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `semester` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `academic_year`, `code`, `credits`, `department`, `lecturer_id`, `lecturer_username`, `name`, `semester`) VALUES
(1, '2023-2024', 'IT1310', 4, 'SE', 2, '111111111111', 'Cơ sở dữ liệu 4yctwj', 'HK2'),
(2, '2024-2025', 'IT8381', 2, 'IT', 2, '111111111111', 'Mạng máy tính 3tqr4e', 'HK1'),
(3, '2023-2024', 'IT2658', 2, 'SE', 2, '111111111111', 'Lập trình Java hj8aje', 'HK2'),
(4, '2023-2024', 'IT1513', 4, 'IT', 2, '111111111111', 'Cấu trúc dữ liệu gm14h', 'HK3'),
(5, '2025-2026', 'IT9614', 3, 'IS', 2, '111111111111', 'Phát triển Web 8w5r28', 'HK2'),
(6, '2024-2025', 'IT1765', 4, 'IT', 2, '111111111111', 'Cơ sở dữ liệu 4msa', 'HK3');

-- --------------------------------------------------------

--
-- Table structure for table `course_parallel`
--

CREATE TABLE `course_parallel` (
  `course_id` bigint NOT NULL,
  `parallel_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course_prerequisites`
--

CREATE TABLE `course_prerequisites` (
  `course_id` bigint NOT NULL,
  `prerequisite_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course_supplementary`
--

CREATE TABLE `course_supplementary` (
  `course_id` bigint NOT NULL,
  `supplementary_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `is_read` bit(1) DEFAULT NULL,
  `user_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `created_at`, `message`, `is_read`, `user_id`) VALUES
(1, '2026-03-14 16:33:07.873475', 'Thông báo phân công thẩm định giáo trình môn Cơ sở dữ liệu 4yctwj. Tên giáo trình: Auto syllabus 60204, phiên bản v1 (ID: 1). Vui lòng hoàn tất quy trình kiểm duyệt trước thời hạn: 23:59:59 ngày 20/03/2026.', b'1', 7),
(2, '2026-03-23 13:24:31.442664', 'Kính gửi Trưởng bộ môn,\n\nSyllabus \"Microservices 8521\" (v1, ID: 3) thuộc môn Cơ sở dữ liệu 4yctwj đã được nộp và đang chờ duyệt. Kính mời Anh/Chị truy cập hệ thống để kiểm tra và thực hiện phê duyệt.', b'0', 3),
(3, '2026-03-23 13:24:31.453061', 'Kính gửi Trưởng bộ môn,\n\nSyllabus \"Microservices 8521\" (v1, ID: 3) thuộc môn Cơ sở dữ liệu 4yctwj đã được nộp và đang chờ duyệt. Kính mời Anh/Chị truy cập hệ thống để kiểm tra và thực hiện phê duyệt.', b'0', 8),
(4, '2026-03-23 13:24:45.343549', 'Kính gửi Trưởng bộ môn, hệ thống có syllabus mới cần duyệt (SUBMITTED).\nMôn học: Cơ sở dữ liệu 4yctwj\nSyllabus: Spring Boot 4195, v1, syllabusId=4\nVui lòng kiểm tra và thực hiện phê duyệt trên hệ thống.', b'0', 3),
(5, '2026-03-23 13:24:45.347952', 'Kính gửi Trưởng bộ môn, hệ thống có syllabus mới cần duyệt (SUBMITTED).\nMôn học: Cơ sở dữ liệu 4yctwj\nSyllabus: Spring Boot 4195, v1, syllabusId=4\nVui lòng kiểm tra và thực hiện phê duyệt trên hệ thống.', b'0', 8),
(6, '2026-03-23 13:24:57.104209', 'Kính gửi Trưởng bộ môn,\nHệ thống ghi nhận syllabus mới cần duyệt:\nMôn: Cơ sở dữ liệu 4yctwj\nSyllabus: Web Development 888, v1 (ID: 5)\nTrạng thái: SUBMITTED\nTrân trọng kính mời thầy/cô truy cập hệ thống để kiểm tra và thực hiện phê duyệt.', b'0', 3),
(7, '2026-03-23 13:24:57.108442', 'Kính gửi Trưởng bộ môn,\nHệ thống ghi nhận syllabus mới cần duyệt:\nMôn: Cơ sở dữ liệu 4yctwj\nSyllabus: Web Development 888, v1 (ID: 5)\nTrạng thái: SUBMITTED\nTrân trọng kính mời thầy/cô truy cập hệ thống để kiểm tra và thực hiện phê duyệt.', b'0', 8),
(8, '2026-03-23 13:25:00.139934', '[HOD] Có syllabus mới cần duyệt (SUBMITTED) - Cơ sở dữ liệu 4yctwj (v1), syllabusId=6', b'0', 3),
(9, '2026-03-23 13:25:00.145935', '[HOD] Có syllabus mới cần duyệt (SUBMITTED) - Cơ sở dữ liệu 4yctwj (v1), syllabusId=6', b'0', 8);

-- --------------------------------------------------------

--
-- Table structure for table `plo`
--

CREATE TABLE `plo` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `scope_key` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `review_assignments`
--

CREATE TABLE `review_assignments` (
  `id` bigint NOT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `due_at` datetime(6) NOT NULL,
  `started_at` datetime(6) DEFAULT NULL,
  `status` enum('ASSIGNED','CANCELLED','DONE','IN_REVIEW') NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `assigned_by_id` bigint NOT NULL,
  `reviewer_id` bigint NOT NULL,
  `syllabus_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `review_assignments`
--

INSERT INTO `review_assignments` (`id`, `completed_at`, `created_at`, `due_at`, `started_at`, `status`, `updated_at`, `assigned_by_id`, `reviewer_id`, `syllabus_id`) VALUES
(1, NULL, '2026-03-14 16:33:03.541758', '2026-03-20 16:59:59.000000', NULL, 'ASSIGNED', '2026-03-14 16:33:03.541758', 3, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(4, 'AA'),
(3, 'HOD'),
(2, 'LECTURER'),
(6, 'PRINCIPAL'),
(5, 'STUDENT'),
(1, 'SYSTEM_ADMIN');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint NOT NULL,
  `course_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `syllabus`
--

CREATE TABLE `syllabus` (
  `id` bigint NOT NULL,
  `academic_year` varchar(20) DEFAULT NULL,
  `ai_summary` text,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `edit_note` text,
  `keywords` text,
  `semester` varchar(20) DEFAULT NULL,
  `status` enum('AA_APPROVED','DRAFT','HOD_APPROVED','PRINCIPAL_APPROVED','PUBLISHED','REJECTED','REQUESTEDIT','SUBMITTED') NOT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `version` int DEFAULT NULL,
  `course_id` bigint NOT NULL,
  `created_by` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `syllabus`
--

INSERT INTO `syllabus` (`id`, `academic_year`, `ai_summary`, `created_at`, `description`, `edit_note`, `keywords`, `semester`, `status`, `title`, `updated_at`, `version`, `course_id`, `created_by`) VALUES
(1, NULL, 'Chương trình đào tạo tập trung vào việc thiết lập hệ thống kiểm thử tự động nhằm tối ưu hóa quy trình kiểm định chất lượng phần mềm. Người học sẽ được trang bị kỹ năng xây dựng kịch bản và vận hành các công cụ tự động hóa để nâng cao hiệu suất trong các dự án công nghệ.', '2026-03-14 16:24:13.604426', 'Automation test 60204', NULL, 'kiểm thử tự động, kịch bản kiểm thử, đảm bảo chất lượng, tối ưu hóa quy trình, công cụ kiểm thử', NULL, 'DRAFT', 'Auto syllabus 60204', '2026-03-14 16:24:13.604426', 1, 1, 2),
(2, NULL, 'Học phần cung cấp hệ thống kiến thức được cập nhật toàn diện nhằm tối ưu hóa tiến trình tiếp cận các khái niệm chuyên sâu và kỹ năng thực hành trong lĩnh vực 53682. Nội dung giáo trình tập trung vào việc chuẩn hóa khung lý thuyết và trang bị năng lực thích ứng cao cho người học trước những yêu cầu mới của ngành.', '2026-03-16 02:46:58.674768', 'Updated desc 53682', NULL, 'cập nhật giáo trình, khung năng lực, chuẩn hóa kiến thức, ứng dụng thực tiễn, học phần 53682', NULL, 'DRAFT', 'Updated syllabus 53682', '2026-03-16 02:47:19.164088', 1, 1, 2),
(3, NULL, 'Học phần nghiên cứu chuyên sâu về quy trình thiết kế và triển khai các hệ thống web dựa trên nền tảng kiến trúc vi dịch vụ hiện đại. Sinh viên sẽ tập trung xây dựng các thành phần độc lập nhằm tối ưu hóa khả năng mở rộng và hiệu quả vận hành trong môi trường điện toán phân tán.', '2026-03-23 13:24:27.744304', 'Build web applications', NULL, 'Kiến trúc vi dịch vụ, Hệ thống phân tán, Khả năng mở rộng, Phát triển Web, Tính module', NULL, 'SUBMITTED', 'Microservices 8521', '2026-03-23 13:24:27.896912', 1, 1, 7),
(4, NULL, 'Học phần này phân tích các phương pháp kiểm thử phần mềm tiên tiến và chiến lược bảo đảm chất lượng trong quy trình phát triển ứng dụng hiện đại. Người học sẽ tiếp cận các kỹ thuật triển khai khung kiểm thử tự động nhằm tối ưu hóa độ tin cậy của hệ thống trên nền tảng Spring Boot.', '2026-03-23 13:24:39.257942', 'Testing modern software', NULL, 'kiểm thử phần mềm, Spring Boot, tự động hóa, bảo đảm chất lượng, kiểm thử tích hợp', NULL, 'SUBMITTED', 'Spring Boot 4195', '2026-03-23 13:24:39.369421', 1, 1, 7),
(5, NULL, 'Học phần này nghiên cứu các phương pháp kiểm định phần mềm đương đại nhằm nâng cao độ tin cậy và hiệu năng cho các ứng dụng web phức tạp. Sinh viên sẽ được trang bị những chiến lược đảm bảo chất lượng tiên tiến và kỹ thuật tối ưu hóa trong môi trường phát triển linh hoạt.', '2026-03-23 13:24:53.959213', 'Testing modern software', NULL, 'Kiểm thử phần mềm, Đảm bảo chất lượng, Tự động hóa, Web Development, Hiệu năng hệ thống', NULL, 'SUBMITTED', 'Web Development 888', '2026-03-23 13:24:54.071159', 1, 1, 7),
(6, NULL, 'Lỗi xử lý AI', '2026-03-23 13:24:59.893243', 'Testing modern software', NULL, 'syllabus', NULL, 'SUBMITTED', 'Cloud Computing 6224', '2026-03-23 13:25:00.009250', 1, 1, 7);

-- --------------------------------------------------------

--
-- Table structure for table `syllabus_comments`
--

CREATE TABLE `syllabus_comments` (
  `id` bigint NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `status` enum('ACTIVE','DELETED') NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `assignment_id` bigint DEFAULT NULL,
  `commenter_id` bigint NOT NULL,
  `syllabus_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `syllabus_comments`
--

INSERT INTO `syllabus_comments` (`id`, `content`, `created_at`, `status`, `updated_at`, `assignment_id`, `commenter_id`, `syllabus_id`) VALUES
(1, 'Review nội dung: cy80m', '2026-03-14 16:37:56.524760', 'ACTIVE', '2026-03-14 16:37:56.524760', 1, 7, 1),
(2, 'Review nội dung: ld12g9', '2026-03-14 16:40:46.877580', 'ACTIVE', '2026-03-14 16:40:51.339162', 1, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `syllabus_contents`
--

CREATE TABLE `syllabus_contents` (
  `id` bigint NOT NULL,
  `assessment_methods` longtext,
  `clo_mappings` longtext,
  `course_learning_outcomes` longtext,
  `course_objectives` longtext,
  `course_outline_table` longtext,
  `description` longtext,
  `general_info` longtext,
  `student_duties` longtext,
  `teaching_plan` longtext,
  `syllabus_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `syllabus_history`
--

CREATE TABLE `syllabus_history` (
  `id` bigint NOT NULL,
  `academic_year` varchar(255) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `semester` varchar(255) DEFAULT NULL,
  `status` enum('AA_APPROVED','DRAFT','HOD_APPROVED','PRINCIPAL_APPROVED','PUBLISHED','REJECTED','REQUESTEDIT','SUBMITTED') NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `version` int DEFAULT NULL,
  `syllabus_id` bigint NOT NULL,
  `updated_by` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `syllabus_history`
--

INSERT INTO `syllabus_history` (`id`, `academic_year`, `description`, `semester`, `status`, `title`, `updated_at`, `version`, `syllabus_id`, `updated_by`) VALUES
(1, NULL, 'Build web applications', NULL, 'DRAFT', 'Microservices 8521', '2026-03-23 13:24:27.888744', 1, 3, 7),
(2, NULL, 'Testing modern software', NULL, 'DRAFT', 'Spring Boot 4195', '2026-03-23 13:24:39.363700', 1, 4, 7),
(3, NULL, 'Testing modern software', NULL, 'DRAFT', 'Web Development 888', '2026-03-23 13:24:54.064802', 1, 5, 7),
(4, NULL, 'Testing modern software', NULL, 'DRAFT', 'Cloud Computing 6224', '2026-03-23 13:25:00.003137', 1, 6, 7);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `cccd` varchar(20) NOT NULL,
  `date_of_birth` date NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `active`, `cccd`, `date_of_birth`, `full_name`, `password`, `username`) VALUES
(1, b'1', '000000000000', '2000-01-01', 'System Admin', '$2a$10$j3Bv9VjCMuZDTjLUqzFdv.1yX.eZz5SE0rkgIZH0xSn12T/qOM.1C', '000000000000'),
(2, b'1', '111111111111', '2000-01-01', 'Lecturer User', '$2a$10$SbcOaVNJHNZcZ8J3UuiwOuXw5QXUE0Jcx/Kzuo.ytoGPmbSCnwT16', '111111111111'),
(3, b'1', '222222222222', '2000-01-01', 'HOD User', '$2a$10$0SpoH3TLbDsWt/8c4Irnr.BsVKugMbujuTS20wldtbDc8HQ4lfotC', '222222222222'),
(4, b'1', '333333333333', '2000-01-01', 'AA User', '$2a$10$DIFho2ZA6SLMZZV175s2zuBhWe.9B3kN.41oe/uc.l9zK5OceN8TG', '333333333333'),
(5, b'1', '444444444444', '2000-01-01', 'Student User', '$2a$10$2LcwlpvHaId0ADi4OBSWFOSXrr7xkM4AODKC8XohVGszrKSEt4LFu', '444444444444'),
(6, b'1', '555555555555', '2000-01-01', 'Principal User', '$2a$10$UI6OoDam7jU.aTxUC1xSD.vUXs8xI6dFRBQ8Jo1TzBYJtE1nmMKCa', '555555555555'),
(7, b'1', '666666666666', '2000-01-01', 'Lecturer User', '$2a$10$wVCoF5PZ.yjbF6T/KMXV3Onj.Fvs21OAwz9y.qLiiY1TrSpdnl48G', '666666666666'),
(8, b'1', '223288495819', '2000-01-01', 'Auto User ER76TN', '$2a$10$SlrVfZI7YytahxnOeQYG5eHqw7RKM3GOYF2sBU5g9iprIyBjhPAdm', '223288495819'),
(9, b'1', '296475442489', '2000-01-01', 'Bulk User 6QN18', '$2a$10$OWGzoUtyvpcPj3MB1IQJVOZmvxmINX5uqDBjDhTT4junZFy9wmub.', '296475442489'),
(10, b'1', '217798212253', '2000-01-01', 'Bulk User 4JH4GP', '$2a$10$xQaAogIWPHdJ4nNmYrEB6OX3zMx0sd8oO6PtyxU6z8uAyyMo0ZqIe', '217798212253'),
(11, b'1', '239332805541', '2000-01-01', 'Bulk User 3VLXMG', '$2a$10$1r8yacbBEOc7VkXHAbrBpeSCNbhqmaNsBEWrAgKIlP17YXSrOQGzi', '239332805541'),
(12, b'1', '831638777678', '2000-01-01', 'Bulk User YNR28P', '$2a$10$G43.XLtgwVcn5.dkWfOp5OzKZo.IVgN1fLFeyMIefw/uaiKc9iVJ2', '831638777678'),
(13, b'1', '115738933100', '2000-01-01', 'Bulk User 99ROT', '$2a$10$bCaq0BSBNoTqU9k36YVfMO543AWLHjdulrBnOH1p5sinQ1dCDcBXK', '115738933100');

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `user_id` bigint NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `bio` varchar(1000) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`user_id`, `address`, `avatar_url`, `bio`, `email`, `phone`) VALUES
(7, 'Ha Noi', '/uploads/avatars/a586c157-b326-426a-b1da-1fd461d8bc6b.jpg', 'Backend Engineer', 'user87@gmail.com', '0975487743');

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(1, 1),
(9, 1),
(11, 1),
(2, 2),
(7, 2),
(10, 2),
(3, 3),
(8, 3),
(4, 4),
(5, 5),
(6, 6),
(12, 6),
(13, 6);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `clo`
--
ALTER TABLE `clo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_clo_syllabus_code` (`syllabus_id`,`code`);

--
-- Indexes for table `clo_plo_map`
--
ALTER TABLE `clo_plo_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_map_clo_plo` (`clo_id`,`plo_id`),
  ADD KEY `FKj4y0d9du8557kp41sbvvkxbfh` (`plo_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK61og8rbqdd2y28rx2et5fdnxd` (`code`);

--
-- Indexes for table `course_parallel`
--
ALTER TABLE `course_parallel`
  ADD PRIMARY KEY (`course_id`,`parallel_id`),
  ADD KEY `FKf2k7oqkliid1ccayftxea4dyx` (`parallel_id`);

--
-- Indexes for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD PRIMARY KEY (`course_id`,`prerequisite_id`),
  ADD KEY `FK2w3n61668a1jqt1y4w7we9pn0` (`prerequisite_id`);

--
-- Indexes for table `course_supplementary`
--
ALTER TABLE `course_supplementary`
  ADD PRIMARY KEY (`course_id`,`supplementary_id`),
  ADD KEY `FKsfv483l7p3ujvgqw5f6scikg6` (`supplementary_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK9y21adhxn0ayjhfocscqox7bh` (`user_id`);

--
-- Indexes for table `plo`
--
ALTER TABLE `plo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_plo_scope_code` (`scope_key`,`code`);

--
-- Indexes for table `review_assignments`
--
ALTER TABLE `review_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKaj78mgv6icb9hgcx2vbhkgs22` (`syllabus_id`,`reviewer_id`),
  ADD KEY `FKfw4vcg2ini18ktrf8qlybvo62` (`assigned_by_id`),
  ADD KEY `FKo8634faa93dgn4hqqjnft918s` (`reviewer_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKofx66keruapi6vyqpv6f2or37` (`name`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK9f5yugfr9ro4r0x5ltfr2pb0f` (`course_id`),
  ADD KEY `FKhro52ohfqfbay9774bev0qinr` (`user_id`);

--
-- Indexes for table `syllabus`
--
ALTER TABLE `syllabus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKjvcn63hkhub569g084rgb9hme` (`course_id`),
  ADD KEY `FKbmekouwi699j6ned9gv88g2dr` (`created_by`);

--
-- Indexes for table `syllabus_comments`
--
ALTER TABLE `syllabus_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKi8tqt9e3859irn5y87pwn4ir2` (`assignment_id`),
  ADD KEY `FKovpavo53uf1yt1gn9cjdbfqua` (`commenter_id`),
  ADD KEY `FKadjhehm3kde1tqud4ou106mjj` (`syllabus_id`);

--
-- Indexes for table `syllabus_contents`
--
ALTER TABLE `syllabus_contents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKsymubfura5dw5lktcedm3k09o` (`syllabus_id`);

--
-- Indexes for table `syllabus_history`
--
ALTER TABLE `syllabus_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK83n0ovsleh1tt5mcpplo42w7g` (`syllabus_id`),
  ADD KEY `FKg1osffa1pv89qx13iryjfh0y0` (`updated_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
  ADD UNIQUE KEY `UKc7y24p0ml4htprpuyyrk712uc` (`cccd`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `FKh8ciramu9cc9q3qcqiv4ue8a6` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `clo`
--
ALTER TABLE `clo`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clo_plo_map`
--
ALTER TABLE `clo_plo_map`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `plo`
--
ALTER TABLE `plo`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review_assignments`
--
ALTER TABLE `review_assignments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `syllabus`
--
ALTER TABLE `syllabus`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `syllabus_comments`
--
ALTER TABLE `syllabus_comments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `syllabus_contents`
--
ALTER TABLE `syllabus_contents`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `syllabus_history`
--
ALTER TABLE `syllabus_history`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `clo`
--
ALTER TABLE `clo`
  ADD CONSTRAINT `FKn6qqmpiw4beps9c2lbqyhjp0l` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`);

--
-- Constraints for table `clo_plo_map`
--
ALTER TABLE `clo_plo_map`
  ADD CONSTRAINT `FKht0aw1fxm0yr20newn0uihjqr` FOREIGN KEY (`clo_id`) REFERENCES `clo` (`id`),
  ADD CONSTRAINT `FKj4y0d9du8557kp41sbvvkxbfh` FOREIGN KEY (`plo_id`) REFERENCES `plo` (`id`);

--
-- Constraints for table `course_parallel`
--
ALTER TABLE `course_parallel`
  ADD CONSTRAINT `FKf2k7oqkliid1ccayftxea4dyx` FOREIGN KEY (`parallel_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `FKkjog45mdal3asd9fgmu7ltl6a` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD CONSTRAINT `FK2w3n61668a1jqt1y4w7we9pn0` FOREIGN KEY (`prerequisite_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `FKhh4f1avebuvlv54m3j3l3pp36` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `course_supplementary`
--
ALTER TABLE `course_supplementary`
  ADD CONSTRAINT `FKcc9qvctm2g99ar258b2bou9b` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `FKsfv483l7p3ujvgqw5f6scikg6` FOREIGN KEY (`supplementary_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `FK9y21adhxn0ayjhfocscqox7bh` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `review_assignments`
--
ALTER TABLE `review_assignments`
  ADD CONSTRAINT `FKfw4vcg2ini18ktrf8qlybvo62` FOREIGN KEY (`assigned_by_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKo8634faa93dgn4hqqjnft918s` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKog1mpubk86a6qiqai6eoajnq2` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`);

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `FK9f5yugfr9ro4r0x5ltfr2pb0f` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  ADD CONSTRAINT `FKhro52ohfqfbay9774bev0qinr` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `syllabus`
--
ALTER TABLE `syllabus`
  ADD CONSTRAINT `FKbmekouwi699j6ned9gv88g2dr` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKjvcn63hkhub569g084rgb9hme` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `syllabus_comments`
--
ALTER TABLE `syllabus_comments`
  ADD CONSTRAINT `FKadjhehm3kde1tqud4ou106mjj` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`),
  ADD CONSTRAINT `FKi8tqt9e3859irn5y87pwn4ir2` FOREIGN KEY (`assignment_id`) REFERENCES `review_assignments` (`id`),
  ADD CONSTRAINT `FKovpavo53uf1yt1gn9cjdbfqua` FOREIGN KEY (`commenter_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `syllabus_contents`
--
ALTER TABLE `syllabus_contents`
  ADD CONSTRAINT `FK2ou40so8rllw681eo9m3jb97v` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`);

--
-- Constraints for table `syllabus_history`
--
ALTER TABLE `syllabus_history`
  ADD CONSTRAINT `FK83n0ovsleh1tt5mcpplo42w7g` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus` (`id`),
  ADD CONSTRAINT `FKg1osffa1pv89qx13iryjfh0y0` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `FKjcad5nfve11khsnpwj1mv8frj` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `FKh8ciramu9cc9q3qcqiv4ue8a6` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
