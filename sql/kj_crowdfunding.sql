-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 03, 2019 at 09:04 AM
-- Server version: 10.1.30-MariaDB
-- PHP Version: 7.2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kj_crowdfunding`
--

-- --------------------------------------------------------

--
-- Table structure for table `donations`
--

CREATE TABLE `donations` (
  `sponsor_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `internships`
--

CREATE TABLE `internships` (
  `sponsor_id` int(11) DEFAULT NULL,
  `internship_id` int(11) DEFAULT NULL,
  `internship_name` varchar(255) DEFAULT NULL,
  `internship_description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `invest`
--

CREATE TABLE `invest` (
  `user_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `amount` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `project_id` int(11) NOT NULL,
  `project_name` varchar(255) NOT NULL,
  `category` enum('IT Solutions','Security') NOT NULL,
  `phase` int(11) NOT NULL,
  `cost` decimal(10,0) NOT NULL,
  `start_date` date NOT NULL,
  `complete_date` date NOT NULL,
  `project_type` enum('Product','Event') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`project_id`, `project_name`, `category`, `phase`, `cost`, `start_date`, `complete_date`, `project_type`) VALUES
(1, 'Blockchain emulator', 'IT Solutions', 1, '100000', '2019-02-01', '2019-02-28', 'Product'),
(2, 'Workshop on Internet Privacy and Security', 'Security', 2, '10000', '2019-02-07', '2019-02-19', 'Event');

-- --------------------------------------------------------

--
-- Table structure for table `project_members`
--

CREATE TABLE `project_members` (
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `project_members`
--

INSERT INTO `project_members` (`user_id`, `project_id`) VALUES
(1, 1),
(1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `sponsor`
--

CREATE TABLE `sponsor` (
  `user_id` int(11) NOT NULL,
  `company` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sponsor`
--

INSERT INTO `sponsor` (`user_id`, `company`) VALUES
(3, 'Cap');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `user_id` int(11) NOT NULL,
  `college_name` varchar(255) NOT NULL,
  `year` int(11) NOT NULL,
  `branch` varchar(31) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`user_id`, `college_name`, `year`, `branch`) VALUES
(1, 'VJTI', 3, 'CS');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `full_name` varchar(127) NOT NULL,
  `password_hash` varchar(128) NOT NULL,
  `blockchain` varchar(63) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_name`, `full_name`, `password_hash`, `blockchain`) VALUES
(1, 'vineet', 'Vineet Rao', 'pbkdf2:sha256:50000$Q0QYDWSO$3e0f3111a85e68368972cac8f0bb62911b688dfe335c2df5261dbed38902fff6', 'ABCD'),
(3, 'abcd', 'Vineet Rao', 'pbkdf2:sha256:50000$FugfVIZ7$3814b2dd03a297efc229936a80b36b3cbf7db51e4e607c377ce610e59da0fa79', 'ABCD');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `donations`
--
ALTER TABLE `donations`
  ADD PRIMARY KEY (`sponsor_id`,`student_id`),
  ADD KEY `sponsor_id` (`sponsor_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `invest`
--
ALTER TABLE `invest`
  ADD KEY `sponsor_invest` (`user_id`),
  ADD KEY `project_invest` (`project_id`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`project_id`);

--
-- Indexes for table `project_members`
--
ALTER TABLE `project_members`
  ADD PRIMARY KEY (`user_id`,`project_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id_2` (`user_id`),
  ADD KEY `project_id_2` (`project_id`);

--
-- Indexes for table `sponsor`
--
ALTER TABLE `sponsor`
  ADD KEY `user_sponsor` (`user_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD KEY `user_student` (`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_name` (`user_name`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `donations`
--
ALTER TABLE `donations`
  ADD CONSTRAINT `donations_ibfk_1` FOREIGN KEY (`sponsor_id`) REFERENCES `sponsor` (`user_id`),
  ADD CONSTRAINT `donations_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student` (`user_id`);

--
-- Constraints for table `invest`
--
ALTER TABLE `invest`
  ADD CONSTRAINT `project_invest` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `sponsor_invest` FOREIGN KEY (`user_id`) REFERENCES `sponsor` (`user_id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `project_members`
--
ALTER TABLE `project_members`
  ADD CONSTRAINT `project_members_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `student` (`user_id`),
  ADD CONSTRAINT `project_members_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`);

--
-- Constraints for table `sponsor`
--
ALTER TABLE `sponsor`
  ADD CONSTRAINT `user_sponsor` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `user_student` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
