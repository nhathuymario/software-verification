-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 11, 2026 at 08:48 AM
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
(6, '2024-2025', 'IT1765', 4, 'IT', 2, '111111111111', 'Cơ sở dữ liệu 4msa', 'HK3'),
(7, '2025-2026', 'IT4127', 3, 'SE', 2, '111111111111', 'Cơ sở dữ liệu tmx4pd', 'HK3');

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
(4, '2026-03-23 13:24:45.343549', 'Kính gửi Trưởng bộ môn, hệ thống có syllabus mới cần duyệt (SUBMITTED).\nMôn học: Cơ sở dữ liệu 4yctwj\nSyllabus: Spring Boot 4195, v1, syllabusId=4\nVui lòng kiểm tra và thực hiện phê duyệt trên hệ thống.', b'0', 3),
(6, '2026-03-23 13:24:57.104209', 'Kính gửi Trưởng bộ môn,\nHệ thống ghi nhận syllabus mới cần duyệt:\nMôn: Cơ sở dữ liệu 4yctwj\nSyllabus: Web Development 888, v1 (ID: 5)\nTrạng thái: SUBMITTED\nTrân trọng kính mời thầy/cô truy cập hệ thống để kiểm tra và thực hiện phê duyệt.', b'0', 3),
(8, '2026-03-23 13:25:00.139934', '[HOD] Có syllabus mới cần duyệt (SUBMITTED) - Cơ sở dữ liệu 4yctwj (v1), syllabusId=6', b'0', 3),
(10, '2026-04-04 05:24:00.985037', 'Thông báo phân công thẩm định môn Cơ sở dữ liệu 4yctwj (Syllabus: Auto syllabus 60204, v1, ID: 1). Thời hạn hoàn thành: 2026-04-04T23:59:59. Đề nghị Reviewer thực hiện đánh giá đúng tiến độ quy định.', b'0', 7),
(16, '2026-04-05 14:45:49.746525', 'Thông báo phân công phản biện giáo trình môn Cơ sở dữ liệu 4yctwj.\nSyllabus: \'Updated syllabus 53682\', v1, syllabusId=2.\nHạn hoàn thành: 2026-04-15T23:59:59.\nĐề nghị Reviewer tiến hành rà soát và phản hồi kết quả đúng quy định.', b'0', 7);

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
(1, NULL, '2026-03-14 16:33:03.541758', '2026-04-04 16:59:59.000000', NULL, 'ASSIGNED', '2026-04-04 05:24:54.329950', 3, 7, 1),
(4, '2026-04-05 15:10:38.376077', '2026-04-05 14:45:11.266451', '2026-04-15 16:59:59.000000', '2026-04-05 14:54:09.197953', 'DONE', '2026-04-05 15:10:38.391335', 3, 7, 2);

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
(6, NULL, 'Lỗi xử lý AI', '2026-03-23 13:24:59.893243', 'Testing modern software', NULL, 'syllabus', NULL, 'SUBMITTED', 'Cloud Computing 6224', '2026-03-23 13:25:00.009250', 1, 1, 7),
(7, NULL, 'Học phần này tập trung nghiên cứu kiến trúc và các nguyên tắc cốt lõi trong thiết kế giao diện lập trình ứng dụng nhằm hỗ trợ quá trình xây dựng chiến lược kiểm thử tối ưu. Việc thấu hiểu cấu trúc API cho phép chuyên gia kiểm định đánh giá chính xác tính tương tác, hiệu năng và độ bảo mật của các hệ thống phần mềm phức hợp.', '2026-04-04 12:45:48.510569', 'Understand API design', NULL, 'API Design, Interface Specification, Integration Testing, Data Validation, Software Architecture', NULL, 'DRAFT', 'Software Testing 8566', '2026-04-04 12:45:48.510569', 1, 1, 2),
(8, NULL, 'Học phần tập trung nghiên cứu các nguyên tắc thiết kế hệ thống phân tán theo mô hình dịch vụ nhỏ nhằm tối ưu hóa khả năng mở rộng linh hoạt. Người học sẽ tiếp cận các phương pháp xây dựng hạ tầng phần mềm hiện đại để đáp ứng nhu cầu xử lý hiệu năng cao trong doanh nghiệp.', '2026-04-04 12:46:19.896483', 'Learn scalable architecture', NULL, 'Microservices, Khả năng mở rộng, Hệ thống phân tán, Kiến trúc phần mềm, Hiệu năng', NULL, 'DRAFT', 'Microservices 702', '2026-04-04 12:46:19.896483', 1, 1, 2),
(9, NULL, 'Nội dung tập trung nghiên cứu các phương pháp kiểm thử tiên tiến nhằm đảm bảo độ tin cậy và khả năng vận hành tối ưu của ứng dụng trong môi trường điện toán đám mây. Người học sẽ tiếp cận các kỹ thuật kiểm soát chất lượng tự động giúp thích ứng với sự thay đổi liên tục của các hệ thống phần mềm hiện đại.', '2026-04-04 12:47:06.397691', 'Testing modern software', NULL, 'Kiểm thử phần mềm, Điện toán đám mây, Tự động hóa, Độ tin cậy hệ thống, CI/CD', NULL, 'DRAFT', 'Cloud Computing 7616', '2026-04-04 12:47:06.397691', 1, 7, 2),
(10, NULL, 'Học phần cung cấp những nền tảng cốt lõi về tư duy logic và kỹ thuật lập trình cơ bản nhằm thiết lập cơ sở vững chắc cho quá trình phát triển ứng dụng. Thông qua việc làm quen với các cấu trúc mã nguồn, người học xây dựng kỹ năng cần thiết để tiếp cận và triển khai các kiến trúc hệ thống phức tạp hơn.', '2026-04-04 12:47:50.585361', 'Introduction to programming', NULL, 'Lập trình cơ bản, Tư duy thuật toán, Cú pháp ngôn ngữ, Phát triển phần mềm, Kiến trúc hệ thống', NULL, 'DRAFT', 'Microservices 729', '2026-04-04 12:47:50.585361', 1, 1, 2);

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
(11, b'1', '239332805541', '2000-01-01', 'Bulk User 3VLXMG', '$2a$10$1r8yacbBEOc7VkXHAbrBpeSCNbhqmaNsBEWrAgKIlP17YXSrOQGzi', '239332805541'),
(13, b'1', '115738933100', '2000-01-01', 'Bulk User 99ROT', '$2a$10$bCaq0BSBNoTqU9k36YVfMO543AWLHjdulrBnOH1p5sinQ1dCDcBXK', '115738933100'),
(14, b'0', '931630311083', '2000-01-01', 'Auto User A3D8HN', '$2a$10$bljlNJu.i8Ht6TCDnlzEfO/.h2b.YLmjx056XDY8dIF5h6sdj99AG', '931630311083'),
(15, b'1', '637069808099', '2000-01-01', 'Auto User AKJCSU', '$2a$10$Heu.6AU4ix2Fum2ml9Uy0OmdAKQ1TiF7rmIFh2kxz4KPwy3zgY/Ei', '637069808099'),
(16, b'1', '980991315421', '2000-01-01', 'Auto User 39KFN', '$2a$10$NRqsHLZ3HLi/bL.suTQR4O1bMoLEondUz7XnY8Ou4oeI094zEvoYW', '980991315421'),
(17, b'1', '746673858089', '2000-01-01', 'Auto User U7Y2HC', '$2a$10$cwm0U7z7W/di0Ldp4nfg4./B5s3RYmahYJsmbqpGJm4H4ybrztk9K', '746673858089'),
(18, b'1', '851687736944', '2000-01-01', 'Auto User EBI0ZG', '$2a$10$506QDtRQ8Yw5gk07jTweLOXtxBDgQUUsLgoWH6y2WPGVILfLvXov.', '851687736944'),
(19, b'1', '834598382222', '2000-01-01', 'Auto User W1SCR', '$2a$10$xaEujL1Wwo4gP5AETHbh..tcUo1poFJAb3WGPTV7JIztaQUAqfbg6', '834598382222'),
(20, b'1', '592648861734', '2000-01-01', 'Auto User PD172K', '$2a$10$TNSnT5VU8QBHacstBnOZL.nfwTTl2wWtsyaU.BZr2B5zwJ.iqaiZe', '592648861734'),
(21, b'1', '704851281064', '2000-01-01', 'Auto User 10FJLA', '$2a$10$zuuvB9n/BU.vsJSVWtOEOeYapmrgyktnQwu1saebehyC1kQlKHSRO', '704851281064'),
(22, b'1', '343329446181', '2000-01-01', 'Auto User 4MC76S', '$2a$10$ukBzQaPEUpOIrigHWHhcxOhkye3c9eV4EOJOrP60bGEnOz8MQRUHy', '343329446181'),
(23, b'1', '144796223152', '2000-01-01', 'Auto User 09FPD', '$2a$10$iM9jdmvJ73W/ioXNNh/1nOij2UuQnGbk.GZpZM4giXPGWkskg91ue', '144796223152'),
(24, b'1', '112345678911', '1999-08-15', 'Nguyễn Văn dat', '$2a$10$i95XezxbJS5TC4D7JpRBJuSxj01HRgWhPAOCeqTnNAGeMESG6izO.', '112345678911'),
(25, b'1', '112345678922', '1985-01-03', 'Trần Văn ho', '$2a$10$ThEv6DKup4iNAFek2ZvEw.TwI/A6kePdGwtD1XbN409BvqUGJhcqa', '112345678922'),
(26, b'1', '112345678933', '2000-12-20', 'Lê Thị h', '$2a$10$.U.TL9qB8SuUnE3w3bNYeOyldAhrrhEQQpo7pS67TG04AqEnzsLPO', '112345678933'),
(27, b'1', '366503016838', '2000-01-01', 'Bulk User 8P6KVX', '$2a$10$hQw78p71oJspz/7Xqh2V5uWckRL0fNvb1o1G6.xtO/SuqsPT9FEAu', '366503016838'),
(28, b'1', '086931420980', '2000-01-01', 'Bulk User V4NMNT', '$2a$10$9NS/iLBWRD90JNGxAiADwu3Ifc/q4Pa/uycLjwcsi2Runz7Y5XdzW', '086931420980'),
(29, b'1', '212779638761', '2000-01-01', 'Bulk User 2XUFGQ', '$2a$10$EU87Hvwzf/eUhELFoe8ADuasLYjHTfZDGcUPyEDwV3x6tc2DtnYxK', '212779638761'),
(30, b'1', '484513889226', '2000-01-01', 'Bulk User DGCMD', '$2a$10$QcALvgw69QmvvhzpnHD9te/uffsNLeXMmgZs9mndFEyl88L8VgGCy', '484513889226'),
(31, b'1', '632731917092', '2000-01-01', 'Bulk User V5PWID', '$2a$10$Ywh.y.8h.VGYeCVvZKUDjehjLFJrOjz80vaaWc0nGC36ihA6DA9zO', '632731917092'),
(32, b'1', '951369503995', '2000-01-01', 'Bulk User Y24BT', '$2a$10$PrydRrCA0bniaShhax5Qf.2tS8xR7anlLRS9cjaHg0mvzyvlZ4oN2', '951369503995'),
(33, b'1', '912535583309', '2000-01-01', 'Bulk User 51ZLSD', '$2a$10$9UQ5vUtAolr2tdq5zG05tO7gCtWXmVLrE.1xDF70zn9PBmrq9iHWy', '912535583309'),
(34, b'1', '472076705194', '2000-01-01', 'Bulk User X0VXP6', '$2a$10$8oh8nYOo.KYD16T9FlXyLeRHBw9H.KcTCLtEuwkOdgsh5TAWSBmYu', '472076705194'),
(35, b'1', '690343854310', '2000-01-01', 'Bulk User R36WAE', '$2a$10$kIW12svz/DGHMXsRp6.OWOeCB8ArCT.I9CbvrNkapg.AnuiHlj2VS', '690343854310'),
(36, b'1', '452213758616', '2000-01-01', 'Bulk User M79BA', '$2a$10$DkO5WqMWugA5OdvNLFr27OnuCHkgaUDR0W8WxY5tkF1DyIQ2uyVi2', '452213758616'),
(37, b'1', '994791983768', '2000-01-01', 'Bulk User 8FTWAE', '$2a$10$EJ7jr9OZu4a88UqkxtwGHu1JVKgr5Fs2VXRpq1VaZ9ff4kPGRRwoW', '994791983768'),
(38, b'1', '108176962462', '2000-01-01', 'Bulk User L33DA', '$2a$10$3/2EjBmRdgINeVxjjqtpWe9HKMs0GLrYh4s5At6FzHZIzH9F83jpi', '108176962462'),
(39, b'1', '200709840885', '2000-01-01', 'Bulk User XT7ADU', '$2a$10$f38oQJmRFhhFNnX0iGm9Ae83g5wxMmM8fuufpO18VPNQbJjoABL2W', '200709840885'),
(40, b'1', '502987716322', '2000-01-01', 'Bulk User G990S', '$2a$10$UYfnXArQe39bf1St0hRLb.As8ord12lPyhfjm8aRU2jkYHkQ65hZW', '502987716322'),
(41, b'1', '220467634504', '2000-01-01', 'Bulk User BC53P', '$2a$10$vAhiwih2CZPvmTpQZKZnRuFBJF9kuWIfzjohysbuH.8DIFLo/wpUS', '220467634504'),
(42, b'1', '163892683931', '2000-01-01', 'Auto User F3JIS', '$2a$10$ivpURZE9vux.tsKosXzcNeW5Cuxnk/2SSskUqCPWRSR.ZFkOr8BW6', '163892683931'),
(43, b'1', '0355153716464', '2000-01-01', 'Bulk User SVIB2F', '$2a$10$DMoT6qxQw4D9OpXYy2LSW.oMpAnCGsBYrdE1fApuQAsgYqABv0imy', '0355153716464'),
(44, b'1', '0405850211974', '2000-01-01', 'Bulk User UMBCKI', '$2a$10$iEWIDLNrebEtc7svda6ZouiRCNJdz5esVwLxAOxWn89FCFj.wIIUu', '0405850211974'),
(45, b'1', '0280666403266', '2000-01-01', 'Bulk User K9ULGT', '$2a$10$MxfRWjxUIcL5F6dGu/9PGO27oyi2e.pqD8TDeMZ1t8qBrzAgzx1VC', '0280666403266'),
(46, b'1', '0802527498819', '2000-01-01', 'Bulk User BJKQGA', '$2a$10$nqvjfJCdu7Lkk.uaNuZfGOevSRarRwZGCWABGlCpgO0LxZsR/gJ4i', '0802527498819'),
(47, b'1', '0488868456295', '2000-01-01', 'Bulk User U9EST4', '$2a$10$8yRB6r.nd6KJqW14hL3cvOM44IggDmTgGdcHtKcRHvqkaPS/V3D/O', '0488868456295'),
(48, b'1', '0153062664968', '2000-01-01', 'Bulk User J99YB', '$2a$10$nx5NVuQvardo782GrU6Gd..CZoDkR5GdVjiIIscLYp3pgZETagPr6', '0153062664968'),
(49, b'1', '0757227910131', '2000-01-01', 'Bulk User GXLG8', '$2a$10$9A.QHHaMAE6oD4f2VwgzleeZe2RSPE0yk2FLxKdeNAdXutdlfPpo6', '0757227910131'),
(50, b'1', '0450380961407', '2000-01-01', 'Bulk User 607FFI', '$2a$10$7sgNBwRD9h8wkrteuyQDCOXrL2P35H2YS/NH60egg5LicBtgUzeFO', '0450380961407'),
(51, b'1', '0116477586357', '2000-01-01', 'Bulk User ONUSP9', '$2a$10$mPiiygvNDTOWD3GERvC9ZuWOSNOIDdhZQYUbRooIJgV21Fy8gTH8C', '0116477586357'),
(52, b'1', '0808975381075', '2000-01-01', 'Bulk User 41U2DO', '$2a$10$VLfwL19fFpqHPbG/M.HW9ejQcItdZ3CtODn72HMiWx5KTxLsHntGm', '0808975381075'),
(53, b'1', '0249823068718', '2000-01-01', 'Bulk User P3S4HJ', '$2a$10$hiEC9deVTb43rfSq73AvwOS4v44wXfFW62miym5p5zbqRPHTPGMBe', '0249823068718');

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
(2, 'Ha Noi', NULL, 'Backend Engineer', 'user7734@gmail.com', '0919373951'),
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
(11, 1),
(20, 1),
(33, 1),
(34, 1),
(40, 1),
(41, 1),
(46, 1),
(50, 1),
(53, 1),
(2, 2),
(7, 2),
(17, 2),
(24, 2),
(26, 2),
(28, 2),
(32, 2),
(37, 2),
(39, 2),
(44, 2),
(52, 2),
(3, 3),
(16, 3),
(21, 3),
(23, 3),
(25, 3),
(27, 3),
(31, 3),
(45, 3),
(47, 3),
(48, 3),
(51, 3),
(4, 4),
(22, 4),
(29, 4),
(35, 4),
(43, 4),
(5, 5),
(14, 5),
(15, 5),
(19, 5),
(38, 5),
(49, 5),
(6, 6),
(13, 6),
(18, 6),
(30, 6),
(36, 6),
(42, 6);

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `plo`
--
ALTER TABLE `plo`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review_assignments`
--
ALTER TABLE `review_assignments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

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
