ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS forum;
USE forum;

DROP TABLE IF EXISTS posts, users, logs;

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    content TEXT,
    attachment VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_text TEXT
);

-- Sample users (unused in app logic, for realism)
INSERT INTO users (username, password) VALUES
('admin', 'supersecret'),
('hacker', '1234'),
('guest', 'guest');

-- -- Sample posts
-- INSERT INTO posts (username, content, attachment) VALUES
-- -- ('hacker', '<script>alert("XSS from hacker")</script>', ''),
-- ('guest', 'This is a regular post. Try searching!', '');
INSERT INTO posts (username, content, attachment) VALUES
('guest', 'This is a regular post. Try searching!', ''),
('alice', 'Just enjoying the sunny weather today.', ''),
('bob', 'Does anyone know how to fix a broken bike?', ''),
('charlie', 'Looking for recommendations for a good book.', ''),
('dave', 'PHP is fun, but I love Python more.', ''),
('eve', 'Can someone explain SQL injection simply?', ''),
('frank', 'I uploaded some files here, check them out!', 'example.jpg'),
('grace', 'Started learning guitar yesterday, fingers hurt!', ''),
('heidi', 'The new movie was awesome, highly recommend.', ''),
('ivan', 'Who else is up late coding?', ''),
('judy', 'Remember to sanitize your inputs always.', '');

