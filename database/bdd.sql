-- Création de la base de données
CREATE DATABASE IF NOT EXISTS pfa;
USE pfa;

-- Table admin
CREATE TABLE admin (
  id INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  prenom VARCHAR(20) NOT NULL,
  email VARCHAR(30) NOT NULL,
  password VARCHAR(20) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table niveau
CREATE TABLE niveau (
  id INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  listestudent VARCHAR(500) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table prof
CREATE TABLE prof (
  id INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  prenom VARCHAR(20) NOT NULL,
  email VARCHAR(30) NOT NULL,
  password VARCHAR(20) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table module
CREATE TABLE module (
  id INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  id_niveau INT NOT NULL,
  salle VARCHAR(20) NOT NULL,
  description VARCHAR(100) NOT NULL,
  email_prof VARCHAR(30) NOT NULL,
  PRIMARY KEY (id),
  KEY id_niveau (id_niveau),
  CONSTRAINT module_ibfk_1 FOREIGN KEY (id_niveau) REFERENCES niveau (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_prof_email FOREIGN KEY (email_prof) REFERENCES prof (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table codeqr
CREATE TABLE codeqr (
  id INT NOT NULL AUTO_INCREMENT,
  id_prof INT NOT NULL,
  id_module INT NOT NULL,
  date DATETIME NOT NULL,
  id_niveau INT NOT NULL,
  salle VARCHAR(20) NOT NULL,
  PRIMARY KEY (id),
  KEY id_prof (id_prof),
  KEY id_niveau (id_niveau),
  KEY id_module (id_module),
  CONSTRAINT id_prof FOREIGN KEY (id_prof) REFERENCES prof (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT id_niveau FOREIGN KEY (id_niveau) REFERENCES niveau (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT id_module FOREIGN KEY (id_module) REFERENCES module (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table student
CREATE TABLE student (
  id INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  prenom VARCHAR(20) NOT NULL,
  email VARCHAR(30) NOT NULL,
  password VARCHAR(20) NOT NULL,
  niveau VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table scanner
CREATE TABLE scanner (
  id INT NOT NULL AUTO_INCREMENT,
  id_student INT NOT NULL,
  id_codeqr INT NOT NULL,
  statut VARCHAR(20) NOT NULL DEFAULT 'present(e)',
  date DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY unique_idx (id_student,id_codeqr),
  KEY id_codeqr (id_codeqr),
  CONSTRAINT id_student FOREIGN KEY (id_student) REFERENCES student (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT id_codeqr FOREIGN KEY (id_codeqr) REFERENCES codeqr (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table user
CREATE TABLE user (
  id INT NOT NULL AUTO_INCREMENT,
  nom VARCHAR(20) NOT NULL,
  prenom VARCHAR(20) NOT NULL,
  email VARCHAR(30) NOT NULL,
  password VARCHAR(20) NOT NULL,
  role VARCHAR(20) NOT NULL,
  first_login TINYINT(1) DEFAULT 1,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table user_devices
CREATE TABLE user_devices (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT DEFAULT NULL,
  device_id VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY user_id (user_id,device_id),
  CONSTRAINT user_devices_ibfk_1 FOREIGN KEY (user_id) REFERENCES user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table logout_timestamps
CREATE TABLE logout_timestamps (
  user_id INT NOT NULL,
  device_id VARCHAR(255) NOT NULL,
  logout_time DATETIME DEFAULT NULL,
  PRIMARY KEY (user_id,device_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;