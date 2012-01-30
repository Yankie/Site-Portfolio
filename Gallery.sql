CREATE DATABASE IF NOT EXISTS `PhotoGalleryDB` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

USE `PhotoGalleryDB`;

DROP TABLE IF EXISTS `gallery`;
CREATE TABLE `gallery` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gid` int,
  `title` varchar(255) NOT NULL,
  `mime` varchar(255) NOT NULL,
  `uploaded` datetime NOT NULL,
  `path` text,
  `description` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `cutter` text,
  `description` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

INSERT INTO `articles` VALUES
	(NULL, NULL, NULL, 'Test','This is test message','This is test message continues...');


INSERT INTO `gallery` VALUES
	(NULL, 'Портреты', 'Портреты друзей и не только...'),
	(NULL, 'B & W', 'Немного черного и белого...'),
	(NULL, 'Пейзажи', '');
	
USE `mysql`;
INSERT INTO mysql.user (Host,User,Password) VALUES ('localhost','pg','4rtyuehe') ON DUPLICATE KEY UPDATE User='pg';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON PhotoGalleryDB.* TO 'pg' @localhost IDENTIFIED BY '4rtyuehe';
