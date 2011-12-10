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

DROP TABLE IF EXISTS `media_gallery`;
CREATE TABLE `media_gallery` (
  `media` int REFERENCES media,
  `gallery` int REFERENCES gallery,
  PRIMARY KEY (`media`,`gallery`)
) DEFAULT CHARSET=utf8;


INSERT INTO `gallery` VALUES
	(NULL, 'B & W', 'Some Black and White photos.'),
	(NULL, 'Portriats', 'My friends and other strangers...');

USE `mysql`;
INSERT INTO mysql.user (Host,User,Password) VALUES ('localhost','pg','4rtyuehe') ON DUPLICATE KEY UPDATE User='pg';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON PhotoGalleryDB.* TO 'pg' @localhost IDENTIFIED BY '4rtyuehe';
