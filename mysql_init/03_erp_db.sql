-- ERP System (Complex - BCNF)
-- Creates `erp_db` with departments, employees, projects, warehouses, inventory, purchase orders, accounting entries, and sample procedures/triggers

CREATE DATABASE IF NOT EXISTS erp_db;
USE erp_db;

DROP TABLE IF EXISTS journal_lines;
DROP TABLE IF EXISTS journal_entries;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS po_line_items;
DROP TABLE IF EXISTS purchase_orders;
DROP TABLE IF EXISTS warehouse_stock;
DROP TABLE IF EXISTS inventory_items;
DROP TABLE IF EXISTS warehouses;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS project_assignments;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
	id INT AUTO_INCREMENT PRIMARY KEY,
	department_id INT,
	manager_id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	hire_date DATE,
	email VARCHAR(100) UNIQUE,
	salary DECIMAL(12,2),
	FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
	FOREIGN KEY (manager_id) REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE projects (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(200),
	start_date DATE,
	end_date DATE
);

CREATE TABLE project_assignments (
	project_id INT NOT NULL,
	employee_id INT NOT NULL,
	role VARCHAR(100),
	allocation_percent INT DEFAULT 100,
	PRIMARY KEY (project_id, employee_id),
	FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
	FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE TABLE attendance (
	id INT AUTO_INCREMENT PRIMARY KEY,
	employee_id INT NOT NULL,
	date DATE NOT NULL,
	status ENUM('present','absent','remote') DEFAULT 'present',
	FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE TABLE suppliers (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(200),
	contact VARCHAR(200)
);

CREATE TABLE warehouses (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(200),
	location VARCHAR(200)
);

CREATE TABLE inventory_items (
	id INT AUTO_INCREMENT PRIMARY KEY,
	sku VARCHAR(100) NOT NULL UNIQUE,
	description VARCHAR(255),
	unit_cost DECIMAL(10,2)
);

CREATE TABLE warehouse_stock (
	warehouse_id INT NOT NULL,
	item_id INT NOT NULL,
	quantity INT NOT NULL DEFAULT 0,
	quantity_available INT AS (quantity) VIRTUAL,
	PRIMARY KEY (warehouse_id, item_id),
	FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE CASCADE,
	FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE CASCADE
);

CREATE TABLE purchase_orders (
	id INT AUTO_INCREMENT PRIMARY KEY,
	supplier_id INT,
	order_date DATE,
	status ENUM('open','received','closed') DEFAULT 'open',
	FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);

CREATE TABLE po_line_items (
	po_id INT NOT NULL,
	item_id INT NOT NULL,
	qty INT NOT NULL,
	unit_price DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (po_id, item_id),
	FOREIGN KEY (po_id) REFERENCES purchase_orders(id) ON DELETE CASCADE,
	FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE RESTRICT
);

CREATE TABLE accounts (
	id INT AUTO_INCREMENT PRIMARY KEY,
	account_code VARCHAR(50) NOT NULL UNIQUE,
	name VARCHAR(200)
);

CREATE TABLE journal_entries (
	id INT AUTO_INCREMENT PRIMARY KEY,
	entry_date DATE,
	description VARCHAR(500)
);

CREATE TABLE journal_lines (
	id INT AUTO_INCREMENT PRIMARY KEY,
	journal_id INT NOT NULL,
	account_id INT NOT NULL,
	debit DECIMAL(12,2) DEFAULT 0.00,
	credit DECIMAL(12,2) DEFAULT 0.00,
	FOREIGN KEY (journal_id) REFERENCES journal_entries(id) ON DELETE CASCADE,
	FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE RESTRICT
);

-- Sample procedural element: simple stored procedure to create a journal entry with lines
DELIMITER $$
CREATE PROCEDURE create_journal_entry(IN p_date DATE, IN p_desc VARCHAR(500))
BEGIN
	INSERT INTO journal_entries (entry_date, description) VALUES (p_date, p_desc);
END$$
DELIMITER ;

-- Sample trigger: update stock on purchase order line insert
DELIMITER $$
CREATE TRIGGER trg_po_line_insert AFTER INSERT ON po_line_items
FOR EACH ROW
BEGIN
	INSERT INTO journal_entries (entry_date, description) VALUES (CURDATE(), CONCAT('PO received line for PO=', NEW.po_id));
END$$
DELIMITER ;

-- Views
CREATE OR REPLACE VIEW employee_hierarchy AS
SELECT e.id, e.first_name, e.last_name, m.id AS manager_id, CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

CREATE OR REPLACE VIEW inventory_overview AS
SELECT i.id AS item_id, i.sku, i.description, SUM(ws.quantity) AS total_on_hand
FROM inventory_items i
LEFT JOIN warehouse_stock ws ON i.id = ws.item_id
GROUP BY i.id, i.sku, i.description;

-- Sample data: departments, employees (12), projects (3), warehouses (4), items (7), purchase orders (3)
INSERT INTO departments (name) VALUES ('HR'),('Engineering'),('Finance'),('Ops');

INSERT INTO employees (department_id,manager_id,first_name,last_name,hire_date,email,salary) VALUES
(2,NULL,'Alice','Manager','2015-01-10','alice.manager@example.com',90000.00),
(2,1,'Bob','Dev','2018-05-20','bob.dev@example.com',70000.00),
(2,1,'Carol','Dev','2019-07-15','carol.dev@example.com',70000.00),
(3,NULL,'Dave','CFO','2012-03-01','dave.cfo@example.com',120000.00),
(3,4,'Eve','Accountant','2016-09-10','eve.accountant@example.com',65000.00),
(1,NULL,'Frank','HRLead','2014-11-05','frank.hr@example.com',80000.00),
(4,NULL,'Grace','OpsLead','2013-06-30','grace.ops@example.com',85000.00),
(2,1,'Heidi','Dev','2020-02-20','heidi.dev@example.com',68000.00),
(2,2,'Ivan','Dev','2021-08-01','ivan.dev@example.com',65000.00),
(2,3,'Judy','Dev','2022-10-12','judy.dev@example.com',64000.00),
(4,7,'Mallory','Ops','2017-04-22','mallory.ops@example.com',60000.00),
(2,1,'Neil','Dev','2018-12-05','neil.dev@example.com',66000.00);

INSERT INTO projects (name,start_date,end_date) VALUES ('Project A','2024-01-01','2024-12-31'),('Project B','2024-03-01','2024-09-30'),('Project C','2024-06-01',NULL);

INSERT INTO warehouses (name,location) VALUES ('WH-East','New York'),('WH-West','San Francisco'),('WH-Central','Chicago'),('WH-Europe','Amsterdam');

INSERT INTO inventory_items (sku,description,unit_cost) VALUES
('ITEM-001','Bolt M8',0.10),('ITEM-002','Nut M8',0.05),('ITEM-003','Widget A',2.50),('ITEM-004','Widget B',3.75),('ITEM-005','Sensor X',15.00),('ITEM-006','Cable 1m',1.20),('ITEM-007','Bearing',0.80);

INSERT INTO warehouse_stock (warehouse_id,item_id,quantity) VALUES
(1,1,100),(1,3,50),(2,3,30),(2,4,60),(3,5,20),(4,6,200),(1,7,150);

INSERT INTO suppliers (name,contact) VALUES ('Acme Supply','acme@example.com'),('Global Parts','parts@example.com'),('Sensors Inc','sales@sensors.example');

INSERT INTO purchase_orders (supplier_id,order_date,status) VALUES (1,'2024-02-01','open'),(2,'2024-03-05','received'),(3,'2024-04-10','open');

INSERT INTO po_line_items (po_id,item_id,qty,unit_price) VALUES (1,1,500,0.08),(1,2,500,0.04),(2,5,50,12.00),(3,6,300,1.00);

-- Accounting sample accounts and journal entries
INSERT INTO accounts (account_code,name) VALUES ('1000','Cash'),('2000','Accounts Payable'),('4000','Revenue'),('5000','COGS');

INSERT INTO journal_entries (entry_date,description) VALUES ('2024-02-01','Initial stock purchase');
-- account_id values must reference the inserted account rows (ids 1..4).
-- accounts inserted above were: ('1000'),('2000'),('4000'),('5000') => ids 1,2,3,4
INSERT INTO journal_lines (journal_id,account_id,debit,credit) VALUES (1,4,100.00,0.00),(1,2,0.00,100.00);

