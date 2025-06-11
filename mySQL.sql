CREATE DATABASE IF NOT EXISTS library_management_app_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_management_app_db;

CREATE TABLE Book (
                      book_id VARCHAR(50) PRIMARY KEY,
                      title VARCHAR(255) NOT NULL,
                      author VARCHAR(255),
                      description TEXT,
                      quantity INT DEFAULT 0
);

CREATE TABLE Student (
                         student_id VARCHAR(50) PRIMARY KEY,
                         full_name VARCHAR(255) NOT NULL,
                         class_name VARCHAR(50)
);

CREATE TABLE BorrowRecord (
                              borrow_id VARCHAR(50) PRIMARY KEY,
                              book_id VARCHAR(50),
                              student_id VARCHAR(50),
                              is_borrowed BOOLEAN,
                              borrow_date DATE,
                              due_date DATE,
                              FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE SET NULL ON UPDATE CASCADE,
                              FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO Book (book_id, title, author, description, quantity) VALUES
                                                                     ('B-0001', 'Mystery', 'Vu Trong Phung', 'The main character is Xuan Toc Do and...', 10),
                                                                     ('B-0002', 'The Tale of Kieu', 'Nguyen Du', 'The life of Thuy Kieu...', 15),
                                                                     ('B-0003', 'Lao Hac', 'Nam Cao', 'A touching story about humanity.', 5),
                                                                     ('B-0004', 'Diary of a Cricket', 'To Hoai', 'The adventures of De Men.', 0),
                                                                     ('B-0005', 'Red Luck', 'Vu Trong Phung', 'A famous satirical work.', 8);

INSERT INTO Student (student_id, full_name, class_name) VALUES
                                                            ('S-001', 'Nguyen Van A', '10A1'),
                                                            ('S-002', 'Tran Thi B', '11B2'),
                                                            ('S-003', 'Le Van C', '12C3');

INSERT INTO BorrowRecord (borrow_id, book_id, student_id, is_borrowed, borrow_date, due_date) VALUES
                                                                                                  ('BR-0001', 'B-0003', 'S-001', true, '2023-10-10', '2023-10-25'),
                                                                                                  ('BR-0002', 'B-0005', 'S-002', true, '2023-10-12', '2023-10-28');