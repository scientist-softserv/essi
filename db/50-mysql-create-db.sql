# Databases to create in docker-compose mysql service
# Only runs once on clean startup

CREATE USER 'essi'@'%' IDENTIFIED WITH mysql_native_password BY 'essi';

CREATE DATABASE IF NOT EXISTS `essi_dev` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT ALL ON `essi_dev`.* TO 'essi'@'%';

CREATE DATABASE IF NOT EXISTS `essi_test` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT ALL ON `essi_test`.* TO 'essi'@'%';
