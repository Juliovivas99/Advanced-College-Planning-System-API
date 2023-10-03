-- MySQL dump 10.13  Distrib 8.1.0, for macos13 (x86_64)
--
-- Host: localhost    Database: DCU
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `DCU`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `DCU` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `DCU`;

--
-- Table structure for table `course_rooms`
--

DROP TABLE IF EXISTS `course_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_rooms` (
  `course_id` int NOT NULL,
  `room_id` int NOT NULL,
  PRIMARY KEY (`course_id`,`room_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `course_rooms_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT,
  CONSTRAINT `course_rooms_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_rooms`
--

LOCK TABLES `course_rooms` WRITE;
/*!40000 ALTER TABLE `course_rooms` DISABLE KEYS */;
INSERT INTO `course_rooms` VALUES (1,1),(2,1),(3,2),(4,2),(5,3),(6,3),(7,4),(8,4),(9,5),(10,5);
/*!40000 ALTER TABLE `course_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_teachers`
--

DROP TABLE IF EXISTS `course_teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_teachers` (
  `course_id` int NOT NULL,
  `teacher_id` int NOT NULL,
  PRIMARY KEY (`course_id`,`teacher_id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `course_teachers_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT,
  CONSTRAINT `course_teachers_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_teachers`
--

LOCK TABLES `course_teachers` WRITE;
/*!40000 ALTER TABLE `course_teachers` DISABLE KEYS */;
INSERT INTO `course_teachers` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
/*!40000 ALTER TABLE `course_teachers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_course_teachers` BEFORE INSERT ON `course_teachers` FOR EACH ROW BEGIN
   DECLARE teacher_count INT DEFAULT 0;

   SELECT COUNT(*) INTO teacher_count 
   FROM course_teachers 
   WHERE teacher_id = NEW.teacher_id;

   IF teacher_count >= 10 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A teacher can only teach 10 classes max';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_teacher_dblbooked` BEFORE INSERT ON `course_teachers` FOR EACH ROW BEGIN
   DECLARE v_start_time TIME;
   DECLARE v_end_time TIME;
   DECLARE v_day_of_week INT;
   DECLARE has_conflict INT DEFAULT 0;

   -- Get the schedule for the course being inserted
   SELECT day_of_week, start_time, end_time INTO v_day_of_week, v_start_time, v_end_time 
   FROM schedule 
   WHERE course_id = NEW.course_id;

   -- Check if there is a conflicting schedule
   SELECT COUNT(*) INTO has_conflict
   FROM schedule s
   JOIN course_teachers ct ON ct.course_id = s.course_id
   WHERE ct.teacher_id = NEW.teacher_id
   AND s.day_of_week = v_day_of_week
   AND (
      (s.start_time BETWEEN v_start_time AND v_end_time)
      OR
      (s.end_time BETWEEN v_start_time AND v_end_time)
      OR
      (v_start_time BETWEEN s.start_time AND s.end_time)
   );

   IF has_conflict > 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This teacher is already assigned to another course at the same time';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `course_name` varchar(255) NOT NULL,
  `course_description` text,
  `credits` int DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_name` (`course_name`),
  CONSTRAINT `courses_chk_1` CHECK ((`credits` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Mathematics','Explore the foundational principles of arithmetic, algebra, geometry, and calculus.',4),(2,'Physics','Dive into the study of matter, energy, and the fundamental forces of the universe.',3),(3,'Biology','Discover the intricacies of life forms, from the smallest cells to complex organisms.',5),(4,'Chemistry','Examine the substances that make up our world and the reactions they undergo.',4),(5,'History','Journey through time to learn about key events and civilizations that shaped our world.',2),(6,'Geography','Study the diverse landscapes, cultures, and socio-political structures across our planet.',3),(7,'Music','Experience the art of sound and learn about its theory, history, and various forms.',1),(8,'Physical Education','Enhance physical fitness, coordination, and understand the principles of team sports.',2),(9,'Computer Science','Delve into the world of algorithms, programming, and computational theory.',5),(10,'Art','Express yourself through various mediums and study the works of historical and contemporary artists.',2);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`course_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE RESTRICT,
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (1,1),(2,1),(3,1),(5,1),(10,1),(1,2),(3,2),(6,2),(7,2),(2,3),(3,3),(7,3),(2,4),(3,4),(8,4),(4,5),(7,5),(10,5),(4,6),(8,6),(10,6),(4,7),(7,7),(5,8),(8,8),(5,9),(9,9),(6,10),(9,10),(10,10);
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_enrollments` BEFORE INSERT ON `enrollments` FOR EACH ROW BEGIN
   DECLARE student_count INT DEFAULT 0;

   SELECT COUNT(*) INTO student_count 
   FROM enrollments 
   WHERE student_id = NEW.student_id;

   IF student_count >= 5 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A student can only enroll in 5 classes max';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_enrolled_max` BEFORE INSERT ON `enrollments` FOR EACH ROW BEGIN
   DECLARE current_enrollment_count INT DEFAULT 0;
   DECLARE room_capacity INT DEFAULT 0;

   -- Calculate current number of students enrolled in the course
   SELECT COUNT(student_id) INTO current_enrollment_count
   FROM enrollments
   WHERE course_id = NEW.course_id;

   -- Get the capacity of the room where the course is held
   SELECT r.capacity INTO room_capacity
   FROM rooms r
   JOIN course_rooms cr ON cr.room_id = r.room_id
   WHERE cr.course_id = NEW.course_id;

   -- Check if adding one more student will exceed room capacity
   IF current_enrollment_count + 1 > room_capacity THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This course is already at room capacity. Enrollment not allowed';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `room_name` varchar(255) NOT NULL,
  `building` varchar(255) NOT NULL,
  `capacity` int DEFAULT NULL,
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `room_name` (`room_name`,`building`),
  CONSTRAINT `rooms_chk_1` CHECK (((`capacity` > 0) and (`capacity` <= 30)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'A101','Main Building',30),(2,'B202','Science Block',30),(3,'C303','Arts Block',30),(4,'D404','Tech Block',30),(5,'E505','Main Building',30);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,1,'Monday','08:00:00','12:00:00'),(2,2,'Monday','13:00:00','17:00:00'),(3,3,'Tuesday','08:00:00','12:00:00'),(4,4,'Tuesday','13:00:00','17:00:00'),(5,5,'Wednesday','08:00:00','12:00:00'),(6,6,'Wednesday','13:00:00','17:00:00'),(7,7,'Thursday','08:00:00','12:00:00'),(8,8,'Thursday','13:00:00','17:00:00'),(9,9,'Friday','08:00:00','12:00:00'),(10,10,'Friday','13:00:00','17:00:00');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_schedule` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
   DECLARE conflicting_course_id INT;
   DECLARE new_room_id INT;

   -- Get the room ID for the new course schedule to be inserted
   SELECT room_id INTO new_room_id FROM course_rooms WHERE course_id = NEW.course_id;

   -- Check for conflicting schedules with the same room
   SELECT s.course_id INTO conflicting_course_id
   FROM schedule s
   JOIN course_rooms cr ON cr.course_id = s.course_id AND cr.room_id = new_room_id
   WHERE s.day_of_week = NEW.day_of_week
   AND (
      NEW.start_time < s.end_time
      AND
      s.start_time < NEW.end_time
   );

   IF conflicting_course_id IS NOT NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This room is already booked for another course at the same time';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `first_name` (`first_name`,`last_name`,`date_of_birth`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'Alice','Johnson','2000-01-01','2023-10-03'),(2,'Bob','Smith','1995-05-10','2023-10-03'),(3,'Charlie','Brown','1989-12-15','2023-10-03'),(4,'Diana','White','2002-08-20','2023-10-03'),(5,'Eva','Green','1998-07-30','2023-10-03'),(6,'Frank','Black','1996-02-28','2023-10-03'),(7,'Grace','Hill','2001-04-05','2023-10-03'),(8,'Henry','Wright','1990-06-12','2023-10-03'),(9,'Ivy','Clark','1999-09-09','2023-10-03'),(10,'Jack','Hall','1997-03-23','2023-10-03');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `teacher_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  `date_of_hire` date DEFAULT NULL,
  PRIMARY KEY (`teacher_id`),
  UNIQUE KEY `first_name` (`first_name`,`last_name`,`specialization`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (1,'Karen','Mills','Mathematics','2018-01-15'),(2,'Leo','Ford','Physics','2017-05-20'),(3,'Monica','Brooks','Biology','2016-08-30'),(4,'Nathan','Bennett','Chemistry','2019-02-05'),(5,'Olivia','Ross','History','2018-10-10'),(6,'Paul','Peters','Geography','2017-04-01'),(7,'Quincy','James','Music','2020-11-11'),(8,'Rachel','Reyes','Physical Education','2018-03-15'),(9,'Steve','Martin','Computer Science','2015-06-25'),(10,'Tina','Turner','Art','2019-07-07');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-03 17:02:21
