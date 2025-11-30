-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 21, 2025 at 03:39 AM
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
('Curie', 'Chemistry'),
('Carl', 'Computer Science'),
('Turing', 'Engineering'),
('Galileo', 'History'),
('Newton', 'Mathematics'),
('PerformanceCenter', 'Music'),
('Einstein', 'Philosophy'),
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
(101, 'Louve', 50),
(102, 'Louve', 60),
(201, 'Rick', 40),
(202, 'Rick', 35),
(301, 'Carl', 30),
(302, 'Carl', 25),
(401, 'PerformanceCenter', 100),
(402, 'PerformanceCenter', 120),
(501, 'Smith', 80),
(502, 'Smith', 100),
(601, 'Newton', 40),
(602, 'Newton', 50),
(701, 'Galileo', 60),
(702, 'Galileo', 45),
(801, 'Einstein', 30),
(802, 'Einstein', 40),
(901, 'Curie', 35),
(902, 'Curie', 45),
(1001, 'Turing', 60);

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
('ART-101', 'Intro to Art', 'Art', 3, NULL),
('ART-201', 'Art History', 'Art', 3, 'ART-101'),
('BIO-101', 'Intro to Biology', 'Biology', 3, NULL),
('BIO-102', 'Genetics', 'Biology', 3, 'BIO-101'),
('BIO-201', 'Ecology', 'Biology', 3, 'BIO-101'),
('BIO-301', 'Botany', 'Biology', 4, 'BIO-102'),
('CHEM-101', 'Intro to Chemistry', 'Chemistry', 3, NULL),
('CHEM-102', 'Organic Chemistry', 'Chemistry', 4, 'CHEM-101'),
('CS-101', 'Intro to Computer Science', 'Computer Science', 3, NULL),
('CS-102', 'Data Structures', 'Computer Science', 4, 'CS-101'),
('CS-201', 'Algorithms', 'Computer Science', 4, 'CS-102'),
('CS-301', 'Operating Systems', 'Computer Science', 4, 'CS-201'),
('ENGR-101', 'Intro to Engineering', 'Engineering', 3, NULL),
('ENGR-102', 'Engineering Mechanics', 'Engineering', 4, 'ENGR-101'),
('ENGR-201', 'Electrical Circuits', 'Engineering', 4, 'ENGR-102'),
('MATH-101', 'Calculus I', 'Mathematics', 4, NULL),
('MATH-102', 'Linear Algebra', 'Mathematics', 3, 'MATH-101'),
('MUS-101', 'Intro to Music Theory', 'Music', 3, NULL),
('MUS-102', 'Music History', 'Music', 3, 'MUS-101'),
('MUS-201', 'Advanced Music Theory', 'Music', 4, 'MUS-102'),
('PHY-101', 'Intro to Physics', 'Physics', 3, NULL),
('PHY-102', 'Classical Mechanics', 'Physics', 3, 'PHY-101'),
('PHY-201', 'Electromagnetism', 'Physics', 4, 'PHY-102'),
('PHY-301', 'Quantum Mechanics', 'Physics', 4, 'PHY-201');

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
('Chemistry', 'Curie', 1200000),
('Computer Science', 'Carl', 1000000),
('Engineering', 'Turing', 1500000),
('History', 'Galileo', 600000),
('Mathematics', 'Newton', 850000),
('Music', 'PerformanceCenter', 900000),
('Philosophy', 'Einstein', 450000),
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
(10003, 'Sarah', 85000, 'Computer Science'),
(10006, 'Tommy', 90000, 'Biology'),
(10009, 'Oliver', 95000, 'Mathematics'),
(10012, 'Lily', 88000, 'Physics'),
(10015, 'Daniel', 90000, 'Engineering'),
(10018, 'Zoe', 85000, 'Chemistry'),
(10021, 'Sophie', 90000, 'History'),
(10023, 'Rachel', 95000, 'Philosophy'),
(10026, 'Jack', 87000, 'Music'),
(10029, 'Jameson', 91000, 'Computer Science'),
(10032, 'Ava', 95000, 'Biology'),
(10035, 'Landon', 95000, 'Mathematics'),
(10037, 'Wyatt', 88000, 'Physics'),
(10039, 'Leah', 95000, 'Engineering'),
(10042, 'Quinn', 92000, 'Chemistry'),
(10044, 'Harper', 94000, 'History'),
(10047, 'Julian', 91000, 'Philosophy'),
(10049, 'Madeline', 95000, 'Music'),
(10051, 'Ella', 88000, 'Computer Science');

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
('ART-101', 1, 'Fall', 2025, 'Louve', 12, 'A', 10003),
('ART-201', 1, 'Fall', 2025, 'Louve', 15, 'B', 10006),
('BIO-101', 1, 'Fall', 2025, 'Rick', 101, 'C', 10009),
('BIO-102', 1, 'Spring', 2025, 'Rick', 101, 'D', 10012),
('BIO-201', 1, 'Fall', 2025, 'Rick', 102, 'E', 10015),
('BIO-301', 1, 'Spring', 2025, 'Rick', 103, 'F', 10018),
('CHEM-101', 1, 'Fall', 2025, 'Curie', 120, 'A', 10021),
('CHEM-102', 1, 'Spring', 2025, 'Curie', 120, 'B', 10023),
('CS-101', 1, 'Fall', 2025, 'Carl', 215, 'A', 10026),
('CS-102', 1, 'Spring', 2025, 'Carl', 216, 'B', 10029),
('CS-201', 1, 'Fall', 2025, 'Carl', 245, 'C', 10032),
('CS-301', 1, 'Spring', 2025, 'Carl', 250, 'D', 10035),
('ENGR-101', 1, 'Fall', 2025, 'Turing', 102, 'A', 10037),
('ENGR-102', 1, 'Spring', 2025, 'Turing', 104, 'B', 10039),
('ENGR-201', 1, 'Fall', 2025, 'Turing', 106, 'C', 10042),
('MATH-101', 1, 'Fall', 2025, 'Newton', 150, 'A', 10044),
('MATH-102', 1, 'Spring', 2025, 'Newton', 150, 'B', 10047),
('MUS-101', 1, 'Fall', 2025, 'PerformanceCenter', 200, 'A', 10049),
('MUS-102', 1, 'Spring', 2025, 'PerformanceCenter', 200, 'B', 10051),
('MUS-201', 1, 'Fall', 2025, 'PerformanceCenter', 205, 'C', 10003),
('PHY-101', 1, 'Fall', 2025, 'Smith', 300, 'A', 10006),
('PHY-102', 1, 'Spring', 2025, 'Smith', 301, 'B', 10009),
('PHY-201', 1, 'Fall', 2025, 'Smith', 305, 'C', 10012),
('PHY-301', 1, 'Spring', 2025, 'Smith', 310, 'D', 10015);

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
(10001, 'Emily', 45, 10003),
(10002, 'John', 60, 10006),
(10004, 'Boris', 30, 10012),
(10005, 'James', 75, 10018),
(10007, 'Mark', 45, 10015),
(10008, 'Jessica', 52, 10009),
(10010, 'Lucy', 65, 10026),
(10011, 'Sam', 80, 10039),
(10013, 'Nathan', 50, 10021),
(10014, 'Mia', 55, 10042),
(10016, 'Sophia', 40, 10029),
(10017, 'Lucas', 72, 10032),
(10019, 'Henry', 68, 10047),
(10020, 'Alex', 60, 10044),
(10022, 'George', 48, 10039),
(10024, 'Liam', 62, 10018),
(10025, 'Chloe', 56, 10032),
(10027, 'Emma', 59, 10035),
(10028, 'Oscar', 50, 10012),
(10030, 'Evelyn', 77, 10042),
(10031, 'Benjamin', 85, 10049),
(10033, 'Mason', 65, 10044),
(10034, 'Charlotte', 72, 10015),
(10036, 'Maya', 54, 10047),
(10038, 'Isaac', 58, 10009),
(10040, 'Ella', 67, 10021),
(10041, 'Theo', 66, 10026),
(10043, 'Aidan', 71, 10032),
(10045, 'Caden', 63, 10049),
(10046, 'Ella', 55, 10006),
(10048, 'Nolan', 79, 10039),
(10050, 'Madeline', 64, 10042);

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
  `grade` varchar(2) NOT NULL,
  `submit` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `takes`
--

INSERT INTO `takes` (`ID`, `course_id`, `sec_id`, `semester`, `year`, `grade`, `submit`) VALUES
(10001, 'ART-101', 1, 'Fall', 2025, '', 0),
(10001, 'ART-201', 1, 'Fall', 2025, '', 0),
(10002, 'CS-101', 1, 'Fall', 2025, '', 0),
(10002, 'CS-102', 1, 'Spring', 2025, '', 0),
(10004, 'BIO-101', 1, 'Fall', 2025, '', 0),
(10005, 'ENGR-101', 1, 'Fall', 2025, '', 0),
(10005, 'ENGR-102', 1, 'Spring', 2025, '', 0),
(10007, 'MUS-101', 1, 'Fall', 2025, '', 0),
(10008, 'MATH-101', 1, 'Fall', 2025, '', 0),
(10008, 'MATH-102', 1, 'Spring', 2025, '', 0),
(10010, 'PHY-101', 1, 'Fall', 2025, '', 0),
(10011, 'CHEM-101', 1, 'Fall', 2025, '', 0),
(10011, 'CHEM-102', 1, 'Spring', 2025, '', 0),
(10013, 'ART-201', 1, 'Fall', 2025, '', 0),
(10014, 'BIO-201', 1, 'Fall', 2025, '', 0),
(10016, 'CS-201', 1, 'Fall', 2025, '', 0),
(10017, 'ENGR-201', 1, 'Fall', 2025, '', 0),
(10019, 'MUS-201', 1, 'Fall', 2025, '', 0),
(10020, 'PHY-201', 1, 'Fall', 2025, '', 0),
(10022, 'BIO-102', 1, 'Spring', 2025, '', 0),
(10024, 'CHEM-102', 1, 'Spring', 2025, '', 0),
(10025, 'CS-102', 1, 'Spring', 2025, '', 0),
(10027, 'ENGR-102', 1, 'Spring', 2025, '', 0),
(10028, 'MATH-102', 1, 'Spring', 2025, '', 0),
(10030, 'MUS-102', 1, 'Spring', 2025, '', 0),
(10031, 'PHY-102', 1, 'Spring', 2025, '', 0),
(10033, 'BIO-301', 1, 'Spring', 2025, '', 0),
(10034, 'CS-301', 1, 'Spring', 2025, '', 0),
(10036, 'PHY-301', 1, 'Spring', 2025, '', 0),
(10038, 'ART-101', 1, 'Fall', 2025, '', 0),
(10038, 'ART-201', 1, 'Fall', 2025, '', 0),
(10038, 'BIO-102', 1, 'Spring', 2025, '', 0),
(10038, 'CS-101', 1, 'Fall', 2025, '', 0),
(10038, 'CS-301', 1, 'Spring', 2025, '', 0),
(10038, 'MUS-101', 1, 'Fall', 2025, '', 0),
(10038, 'MUS-201', 1, 'Fall', 2025, '', 0),
(10038, 'PHY-102', 1, 'Spring', 2025, '', 0),
(10038, 'PHY-301', 1, 'Spring', 2025, '', 0),
(10040, 'BIO-101', 1, 'Fall', 2025, '', 0),
(10040, 'BIO-201', 1, 'Fall', 2025, '', 0),
(10040, 'BIO-301', 1, 'Spring', 2025, '', 0),
(10040, 'CHEM-102', 1, 'Spring', 2025, '', 0),
(10040, 'CS-102', 1, 'Spring', 2025, '', 0),
(10040, 'ENGR-101', 1, 'Fall', 2025, '', 0),
(10040, 'PHY-101', 1, 'Fall', 2025, '', 0),
(10040, 'PHY-201', 1, 'Fall', 2025, '', 0),
(10040, 'PHY-301', 1, 'Spring', 2025, '', 0),
(10041, 'ART-201', 1, 'Fall', 2025, '', 0),
(10041, 'CHEM-101', 1, 'Fall', 2025, '', 0),
(10041, 'CHEM-102', 1, 'Spring', 2025, '', 0),
(10041, 'CS-102', 1, 'Spring', 2025, '', 0),
(10041, 'CS-201', 1, 'Fall', 2025, '', 0),
(10041, 'CS-301', 1, 'Spring', 2025, '', 0),
(10041, 'ENGR-102', 1, 'Spring', 2025, '', 0),
(10041, 'MUS-101', 1, 'Fall', 2025, '', 0),
(10043, 'BIO-201', 1, 'Fall', 2025, '', 0),
(10043, 'CS-101', 1, 'Fall', 2025, '', 0),
(10043, 'ENGR-102', 1, 'Spring', 2025, '', 0),
(10043, 'ENGR-201', 1, 'Fall', 2025, '', 0),
(10043, 'MATH-101', 1, 'Fall', 2025, '', 0),
(10043, 'MATH-102', 1, 'Spring', 2025, '', 0),
(10043, 'PHY-101', 1, 'Fall', 2025, '', 0),
(10043, 'PHY-301', 1, 'Spring', 2025, '', 0),
(10045, 'ART-101', 1, 'Fall', 2025, '', 0),
(10045, 'ART-201', 1, 'Fall', 2025, '', 0),
(10045, 'CHEM-102', 1, 'Spring', 2025, '', 0),
(10045, 'CS-201', 1, 'Fall', 2025, '', 0),
(10045, 'ENGR-101', 1, 'Fall', 2025, '', 0),
(10045, 'MATH-102', 1, 'Spring', 2025, '', 0),
(10045, 'MUS-102', 1, 'Spring', 2025, '', 0),
(10045, 'MUS-201', 1, 'Fall', 2025, '', 0),
(10046, 'BIO-101', 1, 'Fall', 2025, '', 0),
(10046, 'BIO-201', 1, 'Fall', 2025, '', 0),
(10046, 'ENGR-102', 1, 'Spring', 2025, '', 0),
(10046, 'ENGR-201', 1, 'Fall', 2025, '', 0),
(10046, 'MATH-101', 1, 'Fall', 2025, '', 0),
(10046, 'MATH-102', 1, 'Spring', 2025, '', 0),
(10046, 'MUS-102', 1, 'Spring', 2025, '', 0),
(10046, 'PHY-102', 1, 'Spring', 2025, '', 0),
(10046, 'PHY-201', 1, 'Fall', 2025, '', 0),
(10048, 'BIO-102', 1, 'Spring', 2025, '', 0),
(10048, 'BIO-301', 1, 'Spring', 2025, '', 0),
(10048, 'CHEM-101', 1, 'Fall', 2025, '', 0),
(10048, 'CS-101', 1, 'Fall', 2025, '', 0),
(10048, 'CS-201', 1, 'Fall', 2025, '', 0),
(10048, 'MUS-101', 1, 'Fall', 2025, '', 0),
(10048, 'MUS-102', 1, 'Spring', 2025, '', 0),
(10048, 'MUS-201', 1, 'Fall', 2025, '', 0),
(10048, 'PHY-102', 1, 'Spring', 2025, '', 0),
(10050, 'BIO-301', 1, 'Spring', 2025, '', 0),
(10050, 'CS-102', 1, 'Spring', 2025, '', 0),
(10050, 'CS-301', 1, 'Spring', 2025, '', 0),
(10050, 'ENGR-101', 1, 'Fall', 2025, '', 0),
(10050, 'ENGR-102', 1, 'Spring', 2025, '', 0),
(10050, 'ENGR-201', 1, 'Fall', 2025, '', 0),
(10050, 'MATH-101', 1, 'Fall', 2025, '', 0),
(10050, 'PHY-101', 1, 'Fall', 2025, '', 0),
(10050, 'PHY-201', 1, 'Fall', 2025, '', 0);

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
('A', 'M', 8, 0, 10, 0),
('B', 'M', 10, 0, 12, 0),
('C', 'M', 13, 0, 15, 0),
('D', 'T', 8, 0, 10, 0),
('E', 'T', 10, 0, 12, 0),
('F', 'T', 13, 0, 15, 0),
('G', 'W', 8, 0, 10, 0),
('H', 'W', 10, 0, 12, 0),
('I', 'W', 13, 0, 15, 0),
('J', 'T', 8, 0, 10, 0),
('K', 'T', 10, 0, 12, 0),
('L', 'T', 13, 0, 15, 0),
('M', 'F', 8, 0, 10, 0),
('N', 'F', 10, 0, 12, 0),
('O', 'F', 13, 0, 15, 0);

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
(0, 'admin', 0x66289ee98e9a558df3e0aa4726c78c58, 2),
(10001, 'Emily', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10002, 'John', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10003, 'Sarah', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10004, 'Boris', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10005, 'James', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10006, 'Tommy', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10007, 'Mark', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10008, 'Jessica', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10009, 'Oliver', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10010, 'Lucy', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10011, 'Sam', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10012, 'Lily', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10013, 'Nathan', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10014, 'Mia', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10015, 'Daniel', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10016, 'Sophia', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10017, 'Lucas', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10018, 'Zoe', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10019, 'Henry', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10020, 'Alex', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10021, 'Sophie', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10022, 'George', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10023, 'Rachel', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10024, 'Liam', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10025, 'Chloe', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10026, 'Jack', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10027, 'Emma', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10028, 'Oscar', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10029, 'Jameson', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10030, 'Evelyn', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10031, 'Benjamin', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10032, 'Ava', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10033, 'Mason', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10034, 'Charlotte', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10035, 'Landon', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10036, 'Maya', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10037, 'Wyatt', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10038, 'Isaac', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10039, 'Leah', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10040, 'Ella', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10041, 'Theo', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10042, 'Quinn', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10043, 'Aidan', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10044, 'Harper', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10045, 'Caden', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10046, 'Ella', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10047, 'Julian', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10048, 'Nolan', 0xce71dc5196d6930a62d4e68d0b268ef9, 0),
(10049, 'Madeline', 0xce71dc5196d6930a62d4e68d0b268ef9, 1),
(10050, 'Ella', 0xce71dc5196d6930a62d4e68d0b268ef9, 0);

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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_semesters_and_years` ()   BEGIN
    SELECT DISTINCT semester, year
    FROM section
    ORDER BY year DESC, 
             FIELD(semester, 'Spring', 'Summer', 'Fall');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_avg_grade_by_dept_param` (IN `deptName` VARCHAR(30))   BEGIN
    SELECT 
        AVG(
            CASE 
                WHEN t.grade = 'A+' THEN 4.3
                WHEN t.grade = 'A'  THEN 4.0
                WHEN t.grade = 'A-' THEN 3.7

                WHEN t.grade = 'B+' THEN 3.3
                WHEN t.grade = 'B'  THEN 3.0
                WHEN t.grade = 'B-' THEN 2.7

                WHEN t.grade = 'C+' THEN 2.3
                WHEN t.grade = 'C'  THEN 2.0
                WHEN t.grade = 'C-' THEN 1.7

                WHEN t.grade = 'D+' THEN 1.3
                WHEN t.grade = 'D'  THEN 1.0
                WHEN t.grade = 'D-' THEN 0.7

                WHEN t.grade = 'F'  THEN 0.0
                ELSE NULL
            END
        ) AS avg_gpa
    FROM department d
    JOIN course c 
        ON c.dept_name = d.dept_name
    JOIN section s 
        ON s.course_id = c.course_id
    JOIN takes t 
        ON t.course_id = s.course_id
       AND t.sec_id   = s.sec_id
       AND t.semester = s.semester
       AND t.year     = s.year
    WHERE d.dept_name = deptName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_avg_grade_for_class_across_semesters` (IN `p_course_id` VARCHAR(10), IN `p_start_semester` VARCHAR(7), IN `p_start_year` INT, IN `p_end_semester` VARCHAR(7), IN `p_end_year` INT)   BEGIN
    SELECT 
        AVG(
            CASE 
                WHEN t.grade = 'A+' THEN 4.3
                WHEN t.grade = 'A'  THEN 4.0
                WHEN t.grade = 'A-' THEN 3.7
                WHEN t.grade = 'B+' THEN 3.3
                WHEN t.grade = 'B'  THEN 3.0
                WHEN t.grade = 'B-' THEN 2.7
                WHEN t.grade = 'C+' THEN 2.3
                WHEN t.grade = 'C'  THEN 2.0
                WHEN t.grade = 'C-' THEN 1.7
                WHEN t.grade = 'D+' THEN 1.3
                WHEN t.grade = 'D'  THEN 1.0
                WHEN t.grade = 'D-' THEN 0.7
                WHEN t.grade = 'F'  THEN 0.0
                ELSE NULL
            END
        ) AS avg_gpa
    FROM takes t
    JOIN section s
        ON t.course_id = s.course_id
       AND t.sec_id = s.sec_id
       AND t.semester = s.semester
       AND t.year = s.year
    WHERE s.course_id = CAST(p_course_id AS CHAR CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci)
      AND (
            (s.year > p_start_year)
            OR (s.year = p_start_year AND
                CASE s.semester
                    WHEN 'Spring' THEN 1
                    WHEN 'Summer' THEN 2
                    WHEN 'Fall'   THEN 3
                END >=
                CASE p_start_semester
                    WHEN 'Spring' THEN 1
                    WHEN 'Summer' THEN 2
                    WHEN 'Fall'   THEN 3
                END
            )
          )
      AND (
            (s.year < p_end_year)
            OR (s.year = p_end_year AND
                CASE s.semester
                    WHEN 'Spring' THEN 1
                    WHEN 'Summer' THEN 2
                    WHEN 'Fall'   THEN 3
                END <=
                CASE p_end_semester
                    WHEN 'Spring' THEN 1
                    WHEN 'Summer' THEN 2
                    WHEN 'Fall'   THEN 3
                END
            )
          );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_best_and_worst_classes` (IN `semester` VARCHAR(7), IN `year` INT)   BEGIN
    -- Declare variables for best and worst class information
    DECLARE best_class VARCHAR(10);
    DECLARE worst_class VARCHAR(10);
    DECLARE best_avg_grade DECIMAL(3,2);
    DECLARE worst_avg_grade DECIMAL(3,2);
    
    -- Query to find the best performing class in the selected semester
    SELECT 
        sec.course_id, 
        AVG(CASE 
                WHEN t.grade = 'A+' THEN 4.3
                WHEN t.grade = 'A' THEN 4.0
                WHEN t.grade = 'A-' THEN 3.7
                WHEN t.grade = 'B+' THEN 3.3
                WHEN t.grade = 'B' THEN 3.0
                WHEN t.grade = 'B-' THEN 2.7
                WHEN t.grade = 'C+' THEN 2.3
                WHEN t.grade = 'C' THEN 2.0
                WHEN t.grade = 'C-' THEN 1.7
                WHEN t.grade = 'D+' THEN 1.3
                WHEN t.grade = 'D' THEN 1.0
                WHEN t.grade = 'D-' THEN 0.7
                WHEN t.grade = 'F' THEN 0.0
            END) AS avg_grade
    INTO best_class, best_avg_grade
    FROM takes t
    JOIN section sec ON t.course_id = sec.course_id AND t.sec_id = sec.sec_id
    WHERE sec.semester = semester AND sec.year = year
    GROUP BY sec.course_id
    ORDER BY avg_grade DESC
    LIMIT 1;

    -- Query to find the worst performing class in the selected semester
    SELECT 
        sec.course_id, 
        AVG(CASE 
                WHEN t.grade = 'A+' THEN 4.3
                WHEN t.grade = 'A' THEN 4.0
                WHEN t.grade = 'A-' THEN 3.7
                WHEN t.grade = 'B+' THEN 3.3
                WHEN t.grade = 'B' THEN 3.0
                WHEN t.grade = 'B-' THEN 2.7
                WHEN t.grade = 'C+' THEN 2.3
                WHEN t.grade = 'C' THEN 2.0
                WHEN t.grade = 'C-' THEN 1.7
                WHEN t.grade = 'D+' THEN 1.3
                WHEN t.grade = 'D' THEN 1.0
                WHEN t.grade = 'D-' THEN 0.7
                WHEN t.grade = 'F' THEN 0.0
            END) AS avg_grade
    INTO worst_class, worst_avg_grade
    FROM takes t
    JOIN section sec ON t.course_id = sec.course_id AND t.sec_id = sec.sec_id
    WHERE sec.semester = semester AND sec.year = year
    GROUP BY sec.course_id
    ORDER BY avg_grade ASC
    LIMIT 1;

    -- Output the results including the selected semester and year
    SELECT 
        semester AS selected_semester,
        year AS selected_year,
        best_class AS best_class,
        best_avg_grade AS best_class_avg_grade,
        worst_class AS worst_class,
        worst_avg_grade AS worst_class_avg_grade;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_total_current_students_by_dept` (IN `deptName` VARCHAR(30))   BEGIN
    SELECT 
        COUNT(DISTINCT s.ID) AS total_current_students
    FROM student s
    JOIN instructor i
        ON s.advisor_id = i.ID
    JOIN takes t
        ON t.ID = s.ID
    WHERE i.dept_name = deptName
      AND t.submit = 0;   -- course in progress, meaning student is "current"
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_total_students_by_dept` (IN `deptName` VARCHAR(30))   BEGIN
    SELECT 
        COUNT(*) AS total_students
    FROM student s
    JOIN instructor i
        ON s.advisor_id = i.ID
    WHERE i.dept_name = deptName;
END$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;