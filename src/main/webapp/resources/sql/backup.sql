-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: aptcommunitydb
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chatmessage`
--

DROP TABLE IF EXISTS `chatmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatmessage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomId` int NOT NULL,
  `senderId` varchar(50) NOT NULL,
  `receiverId` varchar(50) NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `isRead` tinyint(1) DEFAULT '0',
  `sentAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `readAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `roomId` (`roomId`),
  CONSTRAINT `chatmessage_ibfk_1` FOREIGN KEY (`roomId`) REFERENCES `chatroom` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatmessage`
--

LOCK TABLES `chatmessage` WRITE;
/*!40000 ALTER TABLE `chatmessage` DISABLE KEYS */;
INSERT INTO `chatmessage` VALUES (1,1,'admin','123','ㅇㅇ',1,'2025-05-01 03:38:30','2025-05-01 03:41:23'),(2,1,'admin','123','ㅇㅇ',0,'2025-05-05 06:58:25',NULL),(3,1,'admin','123','ㄴ',0,'2025-05-05 06:58:27',NULL),(4,3,'admin','222','ㅎㅇ',0,'2025-05-05 07:17:53',NULL);
/*!40000 ALTER TABLE `chatmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatroom`
--

DROP TABLE IF EXISTS `chatroom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatroom` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user1` varchar(50) NOT NULL,
  `user2` varchar(50) NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatroom`
--

LOCK TABLES `chatroom` WRITE;
/*!40000 ALTER TABLE `chatroom` DISABLE KEYS */;
INSERT INTO `chatroom` VALUES (1,'admin','123','2025-05-01 03:38:02','2025-05-05 06:58:27'),(2,'${sessionScope.userId}','222','2025-05-05 07:08:38',NULL),(3,'admin','222','2025-05-05 07:17:49','2025-05-05 07:17:53');
/*!40000 ALTER TABLE `chatroom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refType` varchar(20) NOT NULL,
  `refId` int NOT NULL,
  `parentId` int DEFAULT NULL,
  `userId` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,'post',3,NULL,'admin','댓글','2025-05-01 22:11:46','2025-05-01 22:11:46',0),(2,'post',3,NULL,'admin','댓글 테스트','2025-05-03 15:12:31','2025-05-03 15:12:31',0),(3,'post',3,1,'admin','123','2025-05-03 15:31:07','2025-05-03 15:31:07',0),(4,'product',3,NULL,'admin','123','2025-05-05 19:19:50','2025-05-05 19:19:50',0),(5,'product',3,4,'admin','345','2025-05-05 19:19:56','2025-05-05 19:20:03',1);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventschedule`
--

DROP TABLE IF EXISTS `eventschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `apartmentCode` varchar(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `category` varchar(30) DEFAULT NULL,
  `publicFlag` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventschedule`
--

LOCK TABLES `eventschedule` WRITE;
/*!40000 ALTER TABLE `eventschedule` DISABLE KEYS */;
INSERT INTO `eventschedule` VALUES (1,NULL,'123','123','2025-05-14','2025-05-14','환경',1),(2,NULL,'1','12','2025-05-07','2025-05-07','환경',1),(3,NULL,'12','12','2025-05-08','2025-05-08','환경',1),(4,'APT12345','테스트','테스트','2025-05-09','2025-05-09','환경',1);
/*!40000 ALTER TABLE `eventschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refType` varchar(20) DEFAULT NULL,
  `refId` int DEFAULT NULL,
  `fileName` varchar(255) NOT NULL,
  `uploadedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
INSERT INTO `image` VALUES (1,'post',NULL,'1746437777847.gif','2025-05-05 09:36:17');
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `userId` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `apartmentCode` varchar(50) DEFAULT NULL,
  `roadAddress` varchar(50) DEFAULT NULL,
  `dong` varchar(20) DEFAULT NULL,
  `role` int DEFAULT '0',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `profileImage` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'admin','admin','1234','admin','APT12345',NULL,NULL,3,'2025-04-26 06:19:09','1746252804559.png'),(2,'123','123','123','123',NULL,'','',0,'2025-05-01 03:38:17',NULL),(3,'223','222','222','222',NULL,'','',0,'2025-05-02 08:21:10',NULL),(4,'1112','1112','1112','1112',NULL,'','',0,'2025-05-05 07:24:45',NULL),(5,'333','333','333','333','A64175208','481233328008','4812313300',0,'2025-05-05 08:53:25',NULL),(6,'444','444','444','444','A64175208','481233328008','4812313300',0,'2025-05-05 08:54:41',NULL);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `content` text,
  `category` varchar(50) DEFAULT NULL,
  `userId` varchar(50) DEFAULT NULL,
  `apartmentCode` varchar(20) DEFAULT NULL,
  `dong` varchar(50) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `fileName` varchar(50) DEFAULT NULL,
  `views` int DEFAULT '0',
  `likeCount` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `member` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,'123','<p>123</p>','자유','admin',NULL,NULL,'2025-04-27 11:27:30',NULL,5,1),(2,'테스트2','<p>테스트2</p><p><br></p>','자유','admin',NULL,NULL,'2025-04-30 20:34:04',NULL,1,0),(3,'테스트','<p>123</p>','자유','admin',NULL,NULL,'2025-05-01 22:11:33',NULL,50,0),(5,'테스트13','<p>123</p>','자유','admin','APT12345',NULL,'2025-05-11 22:45:09',NULL,1,0);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `price` int NOT NULL,
  `quantity` int NOT NULL,
  `category` varchar(50) NOT NULL DEFAULT '기타',
  `image` varchar(255) DEFAULT NULL,
  `userId` varchar(50) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `views` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `member` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'새상품','물품1','<p>1</p>',12345,1,'전자제품',NULL,'222','2025-05-02 17:21:41',0),(2,'새상품','물품2','<p>1</p>',123456,1,'생활용품',NULL,'222','2025-05-02 17:21:53',1),(3,'새상품','물품3','<p>12</p>',23456,1,'의류',NULL,'222','2025-05-02 17:22:05',23);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommend`
--

DROP TABLE IF EXISTS `recommend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommend` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) NOT NULL,
  `refType` varchar(20) NOT NULL,
  `refId` bigint NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId` (`userId`,`refType`,`refId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommend`
--

LOCK TABLES `recommend` WRITE;
/*!40000 ALTER TABLE `recommend` DISABLE KEYS */;
INSERT INTO `recommend` VALUES (1,'admin','post',1,'2025-05-01 13:18:59');
/*!40000 ALTER TABLE `recommend` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vote`
--

DROP TABLE IF EXISTS `vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vote` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text,
  `creatorId` varchar(50) NOT NULL,
  `apartmentCode` varchar(20) DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `deadline` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vote`
--

LOCK TABLES `vote` WRITE;
/*!40000 ALTER TABLE `vote` DISABLE KEYS */;
INSERT INTO `vote` VALUES (1,'123','123','admin',NULL,'2025-05-01 12:33:28','2025-05-02 12:33:00');
/*!40000 ALTER TABLE `vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voteoption`
--

DROP TABLE IF EXISTS `voteoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voteoption` (
  `id` int NOT NULL AUTO_INCREMENT,
  `voteId` int NOT NULL,
  `optionText` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `voteId` (`voteId`),
  CONSTRAINT `voteoption_ibfk_1` FOREIGN KEY (`voteId`) REFERENCES `vote` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voteoption`
--

LOCK TABLES `voteoption` WRITE;
/*!40000 ALTER TABLE `voteoption` DISABLE KEYS */;
INSERT INTO `voteoption` VALUES (1,1,'1'),(2,1,'2');
/*!40000 ALTER TABLE `voteoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voteresult`
--

DROP TABLE IF EXISTS `voteresult`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voteresult` (
  `id` int NOT NULL AUTO_INCREMENT,
  `voteId` int NOT NULL,
  `optionId` int NOT NULL,
  `memberId` varchar(50) NOT NULL,
  `votedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_vote_per_user` (`voteId`,`memberId`),
  KEY `optionId` (`optionId`),
  CONSTRAINT `voteresult_ibfk_1` FOREIGN KEY (`voteId`) REFERENCES `vote` (`id`) ON DELETE CASCADE,
  CONSTRAINT `voteresult_ibfk_2` FOREIGN KEY (`optionId`) REFERENCES `voteoption` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voteresult`
--

LOCK TABLES `voteresult` WRITE;
/*!40000 ALTER TABLE `voteresult` DISABLE KEYS */;
/*!40000 ALTER TABLE `voteresult` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` varchar(50) NOT NULL,
  `productId` int NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `productId` (`productId`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `member` (`userId`),
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (11,'admin',2,'2025-05-11 07:22:58');
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-16 23:35:03
