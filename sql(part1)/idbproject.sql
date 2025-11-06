-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 06, 2025 at 07:19 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `idbproject`
--

-- --------------------------------------------------------

--
-- Table structure for table `building`
--

CREATE TABLE `building` (
  `building` varchar(25) NOT NULL,
  `dept_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `building`
--

INSERT INTO `building` (`building`, `dept_name`) VALUES
('Louve', 'Art'),
('Rick', 'Biology'),
('Carl', 'Computer Science'),
('Performance Center', 'Music'),
('Smith', 'Physics');

-- --------------------------------------------------------

--
-- Table structure for table `classroom`
--

CREATE TABLE `classroom` (
  `room` int(11) NOT NULL,
  `building` varchar(25) NOT NULL,
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classroom`
--

INSERT INTO `classroom` (`room`, `building`, `capacity`) VALUES
(12, 'Louve', 50),
(101, 'Rick', 28),
(190, 'Performance Center', 120),
(222, 'Smith', 100),
(246, 'Carl', 30),
(344, 'Smith', 45),
(9999, 'Carl', 99);

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `course_id` varchar(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  `dept_name` varchar(30) DEFAULT NULL,
  `credits` int(2) NOT NULL DEFAULT 0,
  `prereq` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`course_id`, `title`, `dept_name`, `credits`, `prereq`) VALUES
('ART-121', 'Art 1', 'Art', 3, NULL),
('BIO-101', 'Intro to Biology', 'Biology', 3, NULL),
('BIO-111', 'Oceanography', 'Biology', 2, NULL),
('BIO-311', 'Botany', 'Biology', 3, 'BIO-111'),
('BIO-401', 'All About Frogs', 'Biology', 4, 'BIO-311'),
('CS-101', 'Computer Science A', 'Computer Science', 3, NULL),
('CS-102', 'Computer Science A Lab', 'Computer Science', 3, NULL),
('CS-333', 'Intro to Databases', 'Computer Science', 3, 'CS-101'),
('MUS-111', 'Modern Music', 'Music', 2, NULL),
('PHY-101', 'Intro to Physics', 'Physics', 3, NULL),
('PHY-108', 'Physics of Pianos', 'Physics', 4, NULL),
('PHY-421', 'Quantum Physics', 'Physics', 4, 'PHY-101');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `dept_name` varchar(30) NOT NULL,
  `building` varchar(25) NOT NULL,
  `budget` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`dept_name`, `building`, `budget`) VALUES
('Art', 'Louve', 650000),
('Biology', 'Rick', 1250000),
('Computer Science', 'Carl', 1000000),
('Music', 'Performance Center', 900000),
('Physics', 'Smith', 1333000);

-- --------------------------------------------------------

--
-- Table structure for table `instructor`
--

CREATE TABLE `instructor` (
  `ID` int(5) NOT NULL,
  `name` varchar(25) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT 0,
  `dept_name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `instructor`
--

INSERT INTO `instructor` (`ID`, `name`, `salary`, `dept_name`) VALUES
(10946, 'Emily Davis', 85000, 'Biology'),
(12125, 'Sarah Adams', 82000, 'Art'),
(12225, 'John Johnson', 90000, 'Computer Science'),
(12345, 'John Johnson', 90000, 'Computer Science'),
(12353, 'Sophia Green', 80000, 'Art'),
(14837, 'Rick Smith', 100000, 'Music'),
(15245, 'John Johnson', 90000, 'Computer Science'),
(17547, 'Mark Lee', 78000, 'Music'),
(55559, 'James Johnson', 95000, 'Physics'),
(59282, 'Bob Roberts', 120000, 'Biology');

-- --------------------------------------------------------

--
-- Table structure for table `section`
--

CREATE TABLE `section` (
  `course_id` varchar(10) NOT NULL,
  `sec_id` int(1) NOT NULL,
  `semester` varchar(7) NOT NULL,
  `year` int(4) NOT NULL,
  `building` varchar(25) DEFAULT NULL,
  `room_number` int(11) DEFAULT NULL,
  `time_slot_id` varchar(1) DEFAULT 'A',
  `teacher` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `section`
--

INSERT INTO `section` (`course_id`, `sec_id`, `semester`, `year`, `building`, `room_number`, `time_slot_id`, `teacher`) VALUES
('BIO-101', 1, 'Fall', 2025, 'Rick', 101, 'E', 59282),
('BIO-101', 2, 'Spring', 2025, 'Rick', 101, 'F', 10946),
('BIO-111', 1, 'Fall', 2025, 'Rick', 101, 'C', 59282),
('BIO-111', 2, 'Spring', 2025, 'Rick', 101, 'D', 15245),
('CS-101', 1, 'Fall', 2025, 'Carl', 246, 'A', 12345),
('CS-101', 2, 'Spring', 2025, 'Carl', 9999, 'B', 12225),
('CS-102', 1, 'Fall', 2025, 'Carl', 246, 'C', 15245),
('CS-102', 2, 'Spring', 2025, 'Carl', 9999, 'D', 12345),
('MUS-111', 1, 'Fall', 2025, 'Performance Center', 190, 'I', 14837),
('MUS-111', 2, 'Spring', 2025, 'Performance Center', 190, 'A', 17547),
('PHY-101', 1, 'Fall', 2025, 'Smith', 344, 'E', 55559),
('PHY-101', 2, 'Spring', 2025, 'Smith', 344, 'F', 14837),
('PHY-108', 1, 'Fall', 2025, 'Smith', 344, 'G', 15245),
('PHY-108', 2, 'Spring', 2025, 'Smith', 344, 'H', 12125);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `ID` int(5) NOT NULL,
  `name` varchar(25) NOT NULL,
  `tot_credits` int(3) NOT NULL DEFAULT 0,
  `advisor_id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`ID`, `name`, `tot_credits`, `advisor_id`) VALUES
(10294, 'James', 19, 12353),
(10592, 'Mort', 119, 10946),
(11111, 'Carl', 61, 14837),
(12589, 'Bob', 71, 15245),
(12629, 'Andy', 89, 59282),
(12950, 'Billy', 56, 17547),
(19284, 'Timmy', 10, 12345),
(19285, 'Tommy', 10, 12345),
(26092, 'Bort', 1, 12345),
(46703, 'Sam', 98, 12125),
(61486, 'Boris', 44, 10946);

-- --------------------------------------------------------

--
-- Table structure for table `takes`
--

CREATE TABLE `takes` (
  `ID` int(5) NOT NULL,
  `course_id` varchar(10) NOT NULL,
  `sec_id` int(1) NOT NULL,
  `semester` varchar(7) NOT NULL,
  `year` int(4) NOT NULL,
  `grade` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `takes`
--

INSERT INTO `takes` (`ID`, `course_id`, `sec_id`, `semester`, `year`, `grade`) VALUES
(10294, 'PHY-108', 1, 'Fall', 2025, 'C'),
(10592, 'MUS-111', 1, 'Fall', 2025, 'B'),
(11111, 'PHY-101', 1, 'Fall', 2025, 'A'),
(12589, 'CS-102', 1, 'Fall', 2025, 'A'),
(12950, 'BIO-101', 1, 'Fall', 2025, 'C'),
(19284, 'CS-101', 1, 'Fall', 2025, 'A'),
(19285, 'CS-101', 2, 'Spring', 2025, 'B'),
(46703, 'BIO-111', 1, 'Fall', 2025, 'B');

-- --------------------------------------------------------

--
-- Table structure for table `time_slot`
--

CREATE TABLE `time_slot` (
  `time_slot_id` varchar(1) NOT NULL,
  `day` varchar(1) NOT NULL,
  `start_hr` int(2) NOT NULL,
  `start_min` int(2) NOT NULL,
  `end_hr` int(2) NOT NULL,
  `end_min` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `time_slot`
--

INSERT INTO `time_slot` (`time_slot_id`, `day`, `start_hr`, `start_min`, `end_hr`, `end_min`) VALUES
('A', 'M', 9, 30, 11, 0),
('B', 'M', 12, 0, 1, 30),
('C', 'T', 9, 15, 10, 45),
('D', 'T', 12, 30, 2, 0),
('E', 'W', 9, 30, 11, 0),
('F', 'W', 12, 0, 1, 30),
('G', 'H', 9, 15, 10, 45),
('H', 'H', 11, 30, 12, 30),
('I', 'F', 9, 0, 10, 15);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(5) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varbinary(20) NOT NULL,
  `permission_level` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `username`, `password`, `permission_level`) VALUES
(10006, 'Man', 0x00453f743f3f427e673f3f250e3f3f3f, 0),
(10007, 'balls', 0x00453f743f3f427e673f3f250e3f3f3f, 0),
(10008, 'boy', 0x1a12eebf964e3f3f183f2e3f3f3f275e, 0),
(10009, 'stick', 0x0c33f5db9285393fe83a05fe7c0937eb, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `building`
--
ALTER TABLE `building`
  ADD PRIMARY KEY (`building`),
  ADD KEY `buildingdept_deptdept` (`dept_name`),
  ADD KEY `building` (`building`);

--
-- Indexes for table `classroom`
--
ALTER TABLE `classroom`
  ADD PRIMARY KEY (`room`,`building`),
  ADD KEY `building` (`building`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `dept_name` (`dept_name`),
  ADD KEY `prereq_courseidd` (`prereq`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`dept_name`),
  ADD KEY `building` (`building`);

--
-- Indexes for table `instructor`
--
ALTER TABLE `instructor`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `dept_name` (`dept_name`);

--
-- Indexes for table `section`
--
ALTER TABLE `section`
  ADD PRIMARY KEY (`course_id`,`sec_id`,`semester`,`year`),
  ADD KEY `building` (`building`,`room_number`),
  ADD KEY `time_slot_id` (`time_slot_id`),
  ADD KEY `course_id` (`course_id`,`sec_id`,`semester`,`year`),
  ADD KEY `sectionteacher_teacherid` (`teacher`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `advisorid_instructorid` (`advisor_id`);

--
-- Indexes for table `takes`
--
ALTER TABLE `takes`
  ADD PRIMARY KEY (`ID`,`course_id`,`sec_id`,`semester`,`year`),
  ADD KEY `takescourse_coursecourse` (`course_id`,`sec_id`,`semester`,`year`);

--
-- Indexes for table `time_slot`
--
ALTER TABLE `time_slot`
  ADD PRIMARY KEY (`time_slot_id`),
  ADD UNIQUE KEY `time_slot_id` (`time_slot_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`,`username`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `building`
--
ALTER TABLE `building`
  ADD CONSTRAINT `buildingdept_deptdept` FOREIGN KEY (`dept_name`) REFERENCES `department` (`dept_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `classroom`
--
ALTER TABLE `classroom`
  ADD CONSTRAINT `b_bb` FOREIGN KEY (`building`) REFERENCES `building` (`building`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_dept-dept` FOREIGN KEY (`dept_name`) REFERENCES `department` (`dept_name`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `prereq_courseidd` FOREIGN KEY (`prereq`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `instructor`
--
ALTER TABLE `instructor`
  ADD CONSTRAINT `dept_dept` FOREIGN KEY (`dept_name`) REFERENCES `department` (`dept_name`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `section`
--
ALTER TABLE `section`
  ADD CONSTRAINT `sectionbuilding_classroombuilding` FOREIGN KEY (`building`) REFERENCES `classroom` (`building`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `sectioncid_coursecid` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sectionteacher_teacherid` FOREIGN KEY (`teacher`) REFERENCES `instructor` (`ID`),
  ADD CONSTRAINT `sectiontimeslot_timeslottimeslot` FOREIGN KEY (`time_slot_id`) REFERENCES `time_slot` (`time_slot_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `advisorid_instructorid` FOREIGN KEY (`advisor_id`) REFERENCES `instructor` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `takes`
--
ALTER TABLE `takes`
  ADD CONSTRAINT `takescourse_coursecourse` FOREIGN KEY (`course_id`,`sec_id`,`semester`,`year`) REFERENCES `section` (`course_id`, `sec_id`, `semester`, `year`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `takesid_studentid` FOREIGN KEY (`ID`) REFERENCES `student` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
