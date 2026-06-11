CREATE DATABASE IF NOT EXISTS hospital_sys DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE hospital_sys;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(50),
    role VARCHAR(20) NOT NULL DEFAULT 'admin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, real_name, role)
VALUES ('admin', '123456', '系统管理员', 'admin')
ON DUPLICATE KEY UPDATE real_name = VALUES(real_name), role = VALUES(role);

INSERT INTO users (username, password, real_name, role)
VALUES ('patient', '123456', '测试患者', 'patient')
ON DUPLICATE KEY UPDATE real_name = VALUES(real_name), role = VALUES(role);

INSERT INTO users (username, password, real_name, role)
VALUES ('doctor', '123456', '测试医生', 'doctor')
ON DUPLICATE KEY UPDATE real_name = VALUES(real_name), role = VALUES(role);

INSERT INTO users (username, password, real_name, role)
VALUES ('pharmacist', '123456', '测试药剂师', 'pharmacist')
ON DUPLICATE KEY UPDATE real_name = VALUES(real_name), role = VALUES(role);

CREATE TABLE IF NOT EXISTS patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT NOT NULL DEFAULT 0,
    phone VARCHAR(20),
    address VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    title VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS doctor_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(50) NOT NULL,
    department_name VARCHAR(50),
    work_date DATE NOT NULL,
    time_slot VARCHAR(50),
    room VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT '正常',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS medicines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    specification VARCHAR(100),
    stock INT NOT NULL DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS medicine_dispenses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(50) NOT NULL,
    medicine_id INT NOT NULL,
    medicine_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    pharmacist_name VARCHAR(50),
    dispensed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS registrations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(50) NOT NULL,
    department_name VARCHAR(50),
    doctor_name VARCHAR(50),
    fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT '待就诊',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS medical_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(50) NOT NULL,
    doctor_name VARCHAR(50),
    diagnosis VARCHAR(500),
    treatment VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    phone VARCHAR(20),
    level VARCHAR(50),
    points INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT '正常',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS charges (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(50) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT '未缴费',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
