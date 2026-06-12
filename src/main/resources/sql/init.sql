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

CREATE TABLE IF NOT EXISTS system_configs (
    config_key VARCHAR(50) PRIMARY KEY,
    config_value VARCHAR(100) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO system_configs (config_key, config_value)
VALUES ('registration_fee', '20.00')
ON DUPLICATE KEY UPDATE config_value = VALUES(config_value);

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

UPDATE users SET real_name = '张明', role = 'doctor' WHERE username = 'doctor';
UPDATE users SET real_name = '药剂师李娜', role = 'pharmacist' WHERE username = 'pharmacist';

INSERT INTO users (username, password, real_name, role)
VALUES ('doctor_lihua', '123456', '李华', 'doctor'),
('doctor_wangqiang', '123456', '王强', 'doctor'),
('doctor_zhaolei', '123456', '赵磊', 'doctor'),
('doctor_chenjing', '123456', '陈静', 'doctor'),
('doctor_liumin', '123456', '刘敏', 'doctor'),
('doctor_zhoufang', '123456', '周芳', 'doctor'),
('doctor_sunli', '123456', '孙丽', 'doctor'),
('doctor_wubin', '123456', '吴斌', 'doctor'),
('doctor_zhengwei', '123456', '郑伟', 'doctor')
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

DELETE FROM doctors;
DELETE FROM departments;

INSERT INTO departments (name, description) VALUES
('内科', '常见内科疾病诊疗'),
('外科', '外科疾病诊疗与术后随访'),
('儿科', '儿童常见病与保健'),
('妇产科', '妇科与产科门诊服务'),
('中医科', '中医辨证诊疗与调理');

INSERT INTO doctors (name, department, title, phone, email) VALUES
('张明', '内科', '主任医师', '13800010001', 'zhangming@hospital.test'),
('李华', '内科', '副主任医师', '13800010002', 'lihua@hospital.test'),
('王强', '外科', '主任医师', '13800020001', 'wangqiang@hospital.test'),
('赵磊', '外科', '主治医师', '13800020002', 'zhaolei@hospital.test'),
('陈静', '儿科', '主任医师', '13800030001', 'chenjing@hospital.test'),
('刘敏', '儿科', '主治医师', '13800030002', 'liumin@hospital.test'),
('周芳', '妇产科', '副主任医师', '13800040001', 'zhoufang@hospital.test'),
('孙丽', '妇产科', '主治医师', '13800040002', 'sunli@hospital.test'),
('吴斌', '中医科', '主任医师', '13800050001', 'wubin@hospital.test'),
('郑伟', '中医科', '主治医师', '13800050002', 'zhengwei@hospital.test');

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

DELETE FROM medicines;

INSERT INTO medicines (name, specification, stock, price) VALUES
('阿莫西林胶囊', '0.25g*24粒', 120, 18.50),
('布洛芬片', '0.2g*20片', 100, 12.00),
('感冒灵颗粒', '10g*9袋', 80, 19.80),
('蒙脱石散', '3g*10袋', 90, 16.00),
('藿香正气口服液', '10ml*10支', 70, 22.50);

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
