-- CSDL cho dự án E-Learning (dựa trên cấu trúc MVC)
-- Sử dụng InnoDB để hỗ trợ Foreign Keys và Transactions
SET NAMES utf8mb4;
SET time_zone = '+07:00';

--
-- 1. Bảng `users` (Tài khoản)
-- Bảng trung tâm cho việc xác thực (AuthController, UserModel, UserController)
--
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'Lưu mật khẩu đã băm (hashed)',
  `full_name` VARCHAR(255) NOT NULL,
  `role` ENUM('student', 'teacher', 'admin') NOT NULL DEFAULT 'student',
  `avatar_url` VARCHAR(512) NULL COMMENT 'Đường dẫn ảnh đại diện (cho Profile)',
  `bio` TEXT NULL COMMENT 'Tiểu sử (cho Profile)',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 2. Bảng `teachers` (Giáo viên)
-- Lưu thông tin mở rộng cho giáo viên (TeacherController, TeacherModel)
-- Liên kết 1-1 với bảng `users`
--
CREATE TABLE IF NOT EXISTS `teachers` (
  `teacher_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL UNIQUE COMMENT 'Khóa ngoại liên kết đến users.user_id',
  `teacher_code` VARCHAR(50) UNIQUE NULL COMMENT 'Mã giáo viên, ví dụ: "GV001"',
  `specialization` VARCHAR(255) NULL COMMENT 'Chuyên môn (ví dụ: "Web Development", "Data Science")',
  `experience_years` INT DEFAULT 0,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 3. Bảng `students` (Sinh viên)
-- Lưu thông tin mở rộng cho sinh viên (StudentController, StudentModel)
-- Liên kết 1-1 với bảng `users`
--
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL UNIQUE COMMENT 'Khóa ngoại liên kết đến users.user_id',
  `student_code` VARCHAR(50) UNIQUE NULL COMMENT 'Mã sinh viên, ví dụ: "SV001"',
  `date_of_birth` DATE NULL,
  `phone_number` VARCHAR(20) NULL,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 4. Bảng `courses` (Khóa học)
-- Lưu thông tin các khóa học (CourseController, CourseModel)
--
CREATE TABLE IF NOT EXISTS `courses` (
  `course_id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `teacher_id` INT NOT NULL COMMENT 'Khóa ngoại liên kết đến teachers.teacher_id',
  `thumbnail_url` VARCHAR(512) NULL COMMENT 'Ảnh đại diện cho khóa học',
  `price` DECIMAL(10, 2) DEFAULT 0.00,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`teacher_id`) REFERENCES `teachers`(`teacher_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 5. Bảng `lessons` (Bài học / Video)
-- Lưu các bài học (video) thuộc về một khóa học (CourseController - Xem Video)
--
CREATE TABLE IF NOT EXISTS `lessons` (
  `lesson_id` INT AUTO_INCREMENT PRIMARY KEY,
  `course_id` INT NOT NULL COMMENT 'Khóa ngoại liên kết đến courses.course_id',
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `video_url` VARCHAR(512) NOT NULL COMMENT 'Đường dẫn file video hoặc link (Youtube, Vimeo...)',
  `duration_minutes` INT DEFAULT 0 COMMENT 'Thời lượng bài học (tính bằng phút)',
  `order_index` INT DEFAULT 0 COMMENT 'Thứ tự bài học trong khóa học',
  FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 6. Bảng `enrollments` (Ghi danh)
-- Bảng trung gian (Many-to-Many) liên kết sinh viên và khóa học
--
CREATE TABLE IF NOT EXISTS `enrollments` (
  `enrollment_id` INT AUTO_INCREMENT PRIMARY KEY,
  `student_id` INT NOT NULL COMMENT 'Khóa ngoại liên kết đến students.student_id',
  `course_id` INT NOT NULL COMMENT 'Khóa ngoại liên kết đến courses.course_id',
  `enrollment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `progress_percent` TINYINT DEFAULT 0 COMMENT 'Tiến độ hoàn thành (0-100)',
  UNIQUE KEY `uk_student_course` (`student_id`, `course_id`), -- Mỗi sinh viên chỉ ghi danh 1 khóa học 1 lần
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 7. Bảng `lesson_completions` (Tiến độ bài học)
-- Bảng ghi lại việc sinh viên đã hoàn thành bài học nào
--
CREATE TABLE IF NOT EXISTS `lesson_completions` (
  `completion_id` INT AUTO_INCREMENT PRIMARY KEY,
  `student_id` INT NOT NULL,
  `lesson_id` INT NOT NULL,
  `completed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_student_lesson` (`student_id`, `lesson_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`lesson_id`) REFERENCES `lessons`(`lesson_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- =================================================================
-- DỮ LIỆU MẪU (SAMPLE DATA)
-- =================================================================
--

-- Mật khẩu cho tất cả user mẫu là 'password123'
-- Hashed: $2y$10$iGgB6..B9gS/O3qKjS4bI.Q.tqXGktylYPsxY6kKU6.XGLD0KBtQO
SET @sample_pass = '$2y$10$iGgB6..B9gS/O3qKjS4bI.Q.tqXGktylYPsxY6kKU6.XGLD0KBtQO';

-- 1. Tạo 1 Admin
INSERT INTO `users` (`username`, `email`, `password_hash`, `full_name`, `role`)
VALUES ('admin', 'admin@example.com', @sample_pass, 'Quản Trị Viên', 'admin');

-- 2. Tạo 1 Giáo viên
INSERT INTO `users` (`username`, `email`, `password_hash`, `full_name`, `role`)
VALUES ('teacher.john', 'john.doe@example.com', @sample_pass, 'John Doe', 'teacher');
SET @teacher_user_id = LAST_INSERT_ID();

INSERT INTO `teachers` (`user_id`, `teacher_code`, `specialization`, `experience_years`)
VALUES (@teacher_user_id, 'GV001', 'Lập trình Web PHP', 5);
SET @teacher_id = LAST_INSERT_ID();

-- 3. Tạo 1 Sinh viên
INSERT INTO `users` (`username`, `email`, `password_hash`, `full_name`, `role`)
VALUES ('student.jane', 'jane.smith@example.com', @sample_pass, 'Jane Smith', 'student');
SET @student_user_id = LAST_INSERT_ID();

INSERT INTO `students` (`user_id`, `student_code`, `date_of_birth`, `phone_number`)
VALUES (@student_user_id, 'SV001', '2002-05-10', '0901234567');
SET @student_id = LAST_INSERT_ID();

-- 4. Tạo 1 Khóa học bởi Giáo viên John Doe
INSERT INTO `courses` (`title`, `description`, `teacher_id`, `price`)
VALUES
('Khóa học lập trình PHP MVC từ A-Z', 'Học cách xây dựng một ứng dụng web PHP theo mô hình MVC giống như dự án này.', @teacher_id, 199.99),
('Nhập môn Lập trình Javascript', 'Khóa học cơ bản về Javascript cho người mới bắt đầu.', @teacher_id, 99.00);
SET @course_id_php = 1; -- Giả định ID là 1
SET @course_id_js = 2; -- Giả định ID là 2

-- 5. Tạo Bài học cho khóa PHP
INSERT INTO `lessons` (`course_id`, `title`, `video_url`, `duration_minutes`, `order_index`)
VALUES
(@course_id_php, 'Bài 1: Giới thiệu về MVC', 'https://www.youtube.com/watch?v=video1', 15, 1),
(@course_id_php, 'Bài 2: Cài đặt Cấu trúc Thư mục', 'https://www.youtube.com/watch?v=video2', 25, 2),
(@course_id_php, 'Bài 3: Xây dựng Bộ định tuyến (Router)', 'https://www.youtube.com/watch?v=video3', 45, 3);

-- 6. Ghi danh Sinh viên Jane Smith vào khóa PHP
INSERT INTO `enrollments` (`student_id`, `course_id`)
VALUES (@student_id, @course_id_php);sqlsvqlsvqlsvshop_dbhop_db