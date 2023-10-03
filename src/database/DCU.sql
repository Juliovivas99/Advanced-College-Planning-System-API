CREATE TABLE `students` (
  `student_id` INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `date_of_birth` DATE,
  `enrollment_date` DATE,
  UNIQUE (`first_name`, `last_name`, `date_of_birth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `courses` (
  `course_id` INT PRIMARY KEY AUTO_INCREMENT,
  `course_name` VARCHAR(255) NOT NULL UNIQUE,
  `course_description` TEXT,
  `credits` INT CHECK (`credits` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `rooms` (
  `room_id` INT PRIMARY KEY AUTO_INCREMENT,
  `room_name` VARCHAR(255) NOT NULL,
  `building` VARCHAR(255) NOT NULL,
  `capacity` INT CHECK (`capacity` > 0 AND `capacity` <= 30),
  UNIQUE (`room_name`, `building`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `teachers` (
  `teacher_id` INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `specialization` VARCHAR(255),
  `date_of_hire` DATE,
  UNIQUE (`first_name`, `last_name`, `specialization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `enrollments` (
  `student_id` INT,
  `course_id` INT,
  PRIMARY KEY (`student_id`, `course_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `course_rooms` (
  `course_id` INT,
  `room_id` INT,
  PRIMARY KEY (`course_id`, `room_id`),
  FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `course_teachers` (
  `course_id` INT,
  `teacher_id` INT,
  PRIMARY KEY (`course_id`, `teacher_id`),
  FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `schedule` (
  `schedule_id` INT PRIMARY KEY AUTO_INCREMENT,
  `course_id` INT,
  `day_of_week` ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
  `start_time` TIME,
  `end_time` TIME,
  FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
