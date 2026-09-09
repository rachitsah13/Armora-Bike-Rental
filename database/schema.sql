-- Armora Bike Rentals (ABR) Database Schema

CREATE DATABASE IF NOT EXISTS armora_db;
USE armora_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'USER') DEFAULT 'USER',
    course VARCHAR(100),
    level VARCHAR(50),
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bikes (Books mapping) Table
-- We use 'isbn' to map the requirement of 'ISBN number' for books to bikes.
CREATE TABLE IF NOT EXISTS bikes (
    bike_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,          -- Model / Title
    isbn_number VARCHAR(50) UNIQUE NOT NULL, -- Serial Number / ISBN equivalent
    genre VARCHAR(50) NOT NULL,           -- Type of bike (Mountain, City, etc.)
    author VARCHAR(100),                  -- Manufacturer / Brand (Mapped to Author)
    published_date DATE,                  -- Manufacturing Date
    rack_number VARCHAR(20),              -- Storage location
    status ENUM('AVAILABLE', 'ISSUED', 'MAINTENANCE') DEFAULT 'AVAILABLE',
    price_per_hour DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Rental price per hour
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Issues Table (Bike Rentals)
CREATE TABLE IF NOT EXISTS issues (
    issue_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    bike_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('ACTIVE', 'RETURNED') DEFAULT 'ACTIVE',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (bike_id) REFERENCES bikes(bike_id) ON DELETE CASCADE
);

-- 4. Wishlist Table
CREATE TABLE IF NOT EXISTS wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    bike_id INT NOT NULL,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (bike_id) REFERENCES bikes(bike_id) ON DELETE CASCADE,
    UNIQUE(user_id, bike_id) -- Prevent duplicate wishlist entries
);

-- Insert Default Admin Account (Password: admin)
-- SHA-256 hash of "admin"
INSERT INTO users (first_name, last_name, email, phone, password_hash, role, is_approved)
VALUES ('Super', 'Admin', 'admin@armora.com', '0000000000', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'ADMIN', TRUE);

-- Insert Bike Price List (with photos)
INSERT INTO bikes (title, isbn_number, genre, author, price_per_hour, image_url, status) VALUES
('BMW S1000RR', 'SN-BMW-S1K', 'Superbike', 'BMW', 8000.00,
 'https://images.unsplash.com/photo-1558981403-c5f97dbbe6ad?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Ducati Panigale V4', 'SN-DUC-V4', 'Superbike', 'Ducati', 9000.00,
 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Aprillia RSv4', 'SN-APR-V4', 'Superbike', 'Aprilia', 7000.00,
 'https://images.unsplash.com/photo-1591637333184-19aa84b3e01f?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Kawasaki Ninja ZX10R', 'SN-KAW-ZX10', 'Superbike', 'Kawasaki', 8000.00,
 'https://images.unsplash.com/photo-1614165939020-f71f168bd2fe?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Yamaha R1M', 'SN-YAM-R1M', 'Superbike', 'Yamaha', 8000.00,
 'https://images.unsplash.com/photo-1547480579-373950f58097?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Honda Fireblade 1000RR', 'SN-HON-CBR', 'Superbike', 'Honda', 8000.00,
 'https://images.unsplash.com/photo-1599819811279-d5ad9cccf838?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE');
