USE DCU;

CREATE TABLE `students` (
  `student_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `date_of_birth` DATE,
  `enrollment_date` DATE,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `student_unique` (`first_name`,`last_name`,`date_of_birth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `courses` (
  `course_id` INT NOT NULL AUTO_INCREMENT,
  `course_name` VARCHAR(255) NOT NULL,
  `course_description` TEXT,
  `credits` INT,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_name` (`course_name`),
  CHECK (credits > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `rooms` (
  `room_id` INT NOT NULL AUTO_INCREMENT,
  `room_name` VARCHAR(255) NOT NULL,
  `building` VARCHAR(255) NOT NULL,
  `capacity` INT,
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `room_building` (`room_name`, `building`),
  CHECK (capacity > 0 AND capacity <= 30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `teachers` (
  `teacher_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `specialization` VARCHAR(255),
  `date_of_hire` DATE,
  PRIMARY KEY (`teacher_id`),
  UNIQUE KEY `teacher_unique` (`first_name`,`last_name`,`specialization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `enrollments` (
  `student_id` INT,
  `course_id` INT,
  PRIMARY KEY (`student_id`, `course_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `course_rooms` (
  `course_id` INT,
  `room_id` INT,
  PRIMARY KEY (`course_id`, `room_id`),
  FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`room_id`) REFERENCES `rooms`(`room_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `course_teachers` (
  `course_id` INT,
  `teacher_id` INT,
  PRIMARY KEY (`course_id`, `teacher_id`),
  FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`teacher_id`) REFERENCES `teachers`(`teacher_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
