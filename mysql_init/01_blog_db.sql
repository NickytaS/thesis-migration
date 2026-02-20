-- Blog System (Simple - 1NF)
-- Creates `blog_db` with users, posts, comments, and a summary view

CREATE DATABASE IF NOT EXISTS blog_db;
USE blog_db;

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(50) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL,
	display_name VARCHAR(100),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
	title VARCHAR(255) NOT NULL,
	body TEXT,
	status ENUM('draft','published','archived') DEFAULT 'draft',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comments (
	id INT AUTO_INCREMENT PRIMARY KEY,
	post_id INT NOT NULL,
	author VARCHAR(100),
	content TEXT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);

-- Simple view summarizing posts
CREATE OR REPLACE VIEW post_summary AS
SELECT p.id AS post_id, p.title, u.username AS author, p.status, p.created_at
FROM posts p
JOIN users u ON p.user_id = u.id;

-- Sample data (5 users, 7 posts, 9 comments)
INSERT INTO users (username, email, display_name) VALUES
('alice','alice@example.com','Alice'),
('bob','bob@example.com','Bob'),
('carol','carol@example.com','Carol'),
('dave','dave@example.com','Dave'),
('eve','eve@example.com','Eve');

INSERT INTO posts (user_id, title, body, status) VALUES
(1,'Welcome to the blog','First post content','published'),
(2,'Thoughts on SQL','Post about SQL','published'),
(1,'Another post','More content','draft'),
(3,'Product review','Review content','published'),
(4,'Announcements','Announcement text','published'),
(5,'Random notes','Notes','draft'),
(2,'Advanced topics','In-depth article','published');

INSERT INTO comments (post_id, author, content) VALUES
(1,'Bob','Nice post!'),
(1,'Carol','Thanks for sharing'),
(2,'Alice','Great insights'),
(2,'Eve','I disagree'),
(4,'Dave','Useful review'),
(4,'Carol','Agreed'),
(5,'Alice','Congrats'),
(7,'Bob','Good read'),
(7,'Eve','Could be improved');

