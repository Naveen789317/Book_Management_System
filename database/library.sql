-- =====================================================
--  DC Library Management System - Complete Database
--  Run this whole file in MySQL (phpMyAdmin or CLI)
-- =====================================================

CREATE DATABASE IF NOT EXISTS dc_library_ai;
USE dc_library_ai;

-- -----------------------------------------------------
-- Table: users (admins + normal users)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    email    VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,           -- stored as MD5 hash
    role     VARCHAR(20) DEFAULT 'user'       -- 'admin' or 'user'
);

-- -----------------------------------------------------
-- Table: books (with image_url)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS books (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    title     VARCHAR(200) NOT NULL,
    author    VARCHAR(100),
    price     DECIMAL(10,2) NOT NULL,
    quantity  INT DEFAULT 0,
    image_url VARCHAR(500)
);

-- -----------------------------------------------------
-- Table: cart (user's shopping cart)
-- ON DELETE CASCADE => deleting a book also removes
-- it from every user's cart automatically
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cart (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL,
    book_id  INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: orders (purchase history)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    book_id    INT NOT NULL,
    quantity   INT DEFAULT 1,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- =====================================================
--  SAMPLE / SEED DATA
-- =====================================================

-- Admin users (login: admin@gmail.com / admin123 or naveen@gmail.com / Naveen@123)
INSERT INTO users (name, email, password, role) VALUES
('Admin', 'admin@gmail.com', 'admin123', 'admin'),
('Naveen', 'naveen@gmail.com', 'Naveen@123', 'admin');

-- Sample normal user (login: john@gmail.com / john123)
INSERT INTO users (name, email, password, role) VALUES
('John Doe', 'john@gmail.com', 'john123', 'user');

-- Books with Google-style image URLs (picsum works 100%)
INSERT INTO books
(title, author, price, quantity, image_url)
VALUES
(
    'Java Programming',
    'John Doe',
    500.00,
    9,
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt7MC2BfVnW_YRk3okt3iux3wa70VGSDEa-KibpNu9HQ&s=10'
),
(
    'Data Structures',
    'Narasimha',
    650.00,
    7,
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6bDrVsCSgO6Enl7toh4dU1Z_lP1xw1n0QaDNpmzU2EQ&s=10'
),
(
    'MySQL',
    'Adam Aspin',
    400.00,
    0,
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQdtNflbFucTmx4m3gFUGO_R4IzhqfwMBJrvMxuAiCkg&s=10'
);

-- Sample cart entry (so John has something in his cart to test)
-- (works only if John got id=2 and a book got id=1 — see note below)
INSERT INTO cart (user_id, book_id, quantity)
SELECT u.id, b.id, 2 FROM users u, books b
WHERE u.email = 'john@gmail.com' AND b.title = 'Java Programming';

-- =====================================================
--  QUICK VERIFICATION QUERIES (optional, run to test)
-- =====================================================

-- SELECT * FROM users;
-- SELECT * FROM books;
-- SELECT * FROM cart;
-- SELECT * FROM orders;