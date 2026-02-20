-- E-commerce Platform (Moderate - 2NF/3NF)
-- Creates `ecommerce_db` with categories, customers, products, orders, order_items, reviews, addresses, payment_methods, payments, product_images

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS payment_methods;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
	id INT AUTO_INCREMENT PRIMARY KEY,
	category_id INT,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
	sku VARCHAR(100),
	available BOOLEAN DEFAULT TRUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
	FULLTEXT KEY ft_name_desc (name, description)
);

CREATE TABLE addresses (
	id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT NOT NULL,
	line1 VARCHAR(255),
	city VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE TABLE payment_methods (
	id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT NOT NULL,
	type ENUM('card','paypal','bank') NOT NULL,
	details TEXT,
	FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE TABLE payments (
	id INT AUTO_INCREMENT PRIMARY KEY,
	order_id INT NOT NULL,
	payment_method_id INT,
	amount DECIMAL(10,2) NOT NULL,
	paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL
);

CREATE TABLE orders (
	id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT NOT NULL,
	order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	status ENUM('pending','paid','shipped','cancelled') DEFAULT 'pending',
	total DECIMAL(12,2) DEFAULT 0.00,
	FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NOT NULL DEFAULT 1,
	unit_price DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (order_id, product_id),
	FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

CREATE TABLE reviews (
	id INT AUTO_INCREMENT PRIMARY KEY,
	product_id INT NOT NULL,
	customer_id INT,
	rating INT CHECK (rating BETWEEN 1 AND 5),
	comment TEXT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
	FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE product_images (
	id INT AUTO_INCREMENT PRIMARY KEY,
	product_id INT NOT NULL,
	url VARCHAR(500),
	alt_text VARCHAR(255),
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Sample data: 8 customers, 10 products, 6 orders with items, 6 reviews
INSERT INTO categories (name) VALUES ('Books'),('Electronics'),('Clothing');

INSERT INTO customers (first_name,last_name,email) VALUES
('Alice','Smith','alice.smith@example.com'),
('Bob','Jones','bob.jones@example.com'),
('Carol','Davis','carol.davis@example.com'),
('Dave','Miller','dave.miller@example.com'),
('Eve','Wilson','eve.wilson@example.com'),
('Frank','Moore','frank.moore@example.com'),
('Grace','Taylor','grace.taylor@example.com'),
('Heidi','Anderson','heidi.anderson@example.com');

INSERT INTO products (category_id,name,description,price,sku,available) VALUES
(1,'Learning SQL','Introductory SQL book',29.99,'BOOK-001',TRUE),
(1,'Advanced SQL','Advanced topics',49.99,'BOOK-002',TRUE),
(2,'Wireless Mouse','Ergonomic mouse',19.99,'ELEC-001',TRUE),
(2,'Mechanical Keyboard','Tactile keyboard',89.99,'ELEC-002',TRUE),
(2,'USB-C Hub','4-port hub',24.99,'ELEC-003',TRUE),
(3,'T-Shirt','Cotton t-shirt',14.99,'CLOTH-001',TRUE),
(3,'Jeans','Denim jeans',49.99,'CLOTH-002',TRUE),
(1,'Database Design','Design patterns',39.99,'BOOK-003',TRUE),
(2,'Monitor 24"','1080p monitor',129.99,'ELEC-004',TRUE),
(2,'Webcam','HD webcam',59.99,'ELEC-005',TRUE);

-- Simple orders and items
INSERT INTO orders (customer_id,status,total) VALUES (1,'paid',79.98),(2,'pending',19.99),(3,'paid',49.99),(4,'shipped',144.98),(5,'paid',39.99),(6,'pending',24.99);

INSERT INTO order_items (order_id,product_id,quantity,unit_price) VALUES
(1,1,2,29.99),(2,3,1,19.99),(3,2,1,49.99),(4,9,1,129.99),(4,3,1,19.99),(5,8,1,39.99),(6,5,1,24.99);

INSERT INTO reviews (product_id,customer_id,rating,comment) VALUES
(1,1,5,'Excellent book'),(3,2,4,'Works well'),(2,3,5,'Very detailed'),(9,4,4,'Good monitor'),(8,5,5,'Great content'),(4,6,3,'Keys are stiff');
