# Databases to create in docker-compose mysql service
# Only runs once on clean startup

CREATE DATABASE IF NOT EXISTS `essi_dev`;
GRANT ALL ON `essi_dev`.* TO 'essi'@'%';

CREATE DATABASE IF NOT EXISTS `essi_test`;
GRANT ALL ON `essi_test`.* TO 'essi'@'%';
