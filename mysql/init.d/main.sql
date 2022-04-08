
CREATE DATABASE MAIN;

GRANT ALL PRIVILEGES ON MAIN.* TO 'user'@'%' with grant option;

GRANT SUPER ON *.* TO 'user'@'%';

USE MAIN;

DROP TABLE IF EXISTS `EXAMPLE`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EXAMPLE` (
  `KEY` varchar(20) NOT NULL,
  `VALUE` varchar(250),
  PRIMARY KEY (`KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `SEQ_EXAMPLE`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SEQ_EXAMPLE` (
  `ID` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `VALUE` varchar(250),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
