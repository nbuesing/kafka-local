
CREATE DATABASE BACKUP;

GRANT ALL PRIVILEGES ON BACKUP.* TO 'user'@'%';

USE BACKUP;

DROP TABLE IF EXISTS `EXAMPLE`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EXAMPLE` (
                           `KEY` varchar(20) NOT NULL,
                           `VALUE` varchar(250),
                           PRIMARY KEY (`KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
