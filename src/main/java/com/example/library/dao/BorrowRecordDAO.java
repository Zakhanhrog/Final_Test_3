package com.example.library.dao;

import com.example.library.config.DatabaseConnector;
import com.example.library.model.Book;
import com.example.library.model.BorrowRecord;
import com.example.library.model.Student;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowRecordDAO {

    public String generateNewBorrowId() {
        String newId = "BR-0001";
        String query = "SELECT borrow_id FROM BorrowRecord WHERE borrow_id LIKE 'BR-%' ORDER BY CAST(SUBSTRING(borrow_id, 4) AS UNSIGNED) DESC LIMIT 1";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("borrow_id");
                try {
                    int num = Integer.parseInt(lastId.substring(3));
                    num++;
                    newId = String.format("BR-%04d", num);
                } catch (NumberFormatException e) {
                    newId = "BR-" + (System.currentTimeMillis() % 10000);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newId;
    }

    public boolean saveBorrowRecord(BorrowRecord record) {
        String query = "INSERT INTO BorrowRecord (borrow_id, book_id, student_id, is_borrowed, borrow_date, due_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, record.getBorrowId());
            ps.setString(2, record.getBookId());
            ps.setString(3, record.getStudentId());
            ps.setBoolean(4, record.isBorrowed());
            ps.setDate(5, record.getBorrowDate());
            ps.setDate(6, record.getDueDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BorrowRecord> getActiveBorrowRecords(String searchBookTitle, String searchStudentName) {
        List<BorrowRecord> borrowedRecords = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder(
                "SELECT br.borrow_id, br.book_id, br.student_id, br.is_borrowed, br.borrow_date, br.due_date, " +
                        "b.title, b.author, b.description AS book_description, b.quantity, " +
                        "st.full_name, st.class_name " +
                        "FROM BorrowRecord br " +
                        "JOIN Book b ON br.book_id = b.book_id " +
                        "JOIN Student st ON br.student_id = st.student_id " +
                        "WHERE br.is_borrowed = true"
        );

        List<Object> params = new ArrayList<>();
        if (searchBookTitle != null && !searchBookTitle.trim().isEmpty()) {
            queryBuilder.append(" AND b.title LIKE ?");
            params.add("%" + searchBookTitle + "%");
        }
        if (searchStudentName != null && !searchStudentName.trim().isEmpty()) {
            queryBuilder.append(" AND st.full_name LIKE ?");
            params.add("%" + searchStudentName + "%");
        }
        queryBuilder.append(" ORDER BY br.borrow_date DESC");


        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(queryBuilder.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRecord record = new BorrowRecord();
                    record.setBorrowId(rs.getString("borrow_id"));
                    record.setBookId(rs.getString("book_id"));
                    record.setStudentId(rs.getString("student_id"));
                    record.setBorrowed(rs.getBoolean("is_borrowed"));
                    record.setBorrowDate(rs.getDate("borrow_date"));
                    record.setDueDate(rs.getDate("due_date"));

                    Book book = new Book();
                    book.setBookId(rs.getString("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setDescription(rs.getString("book_description"));
                    book.setQuantity(rs.getInt("quantity"));
                    record.setBook(book);

                    Student student = new Student();
                    student.setStudentId(rs.getString("student_id"));
                    student.setFullName(rs.getString("full_name"));
                    student.setClassName(rs.getString("class_name"));
                    record.setStudent(student);

                    borrowedRecords.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return borrowedRecords;
    }

    public boolean updateBorrowRecordStatus(String borrowId, boolean isBorrowed) {
        String query = "UPDATE BorrowRecord SET is_borrowed = ? WHERE borrow_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setBoolean(1, isBorrowed);
            ps.setString(2, borrowId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public BorrowRecord getBorrowRecordById(String borrowId) {
        BorrowRecord record = null;
        String query = "SELECT br.borrow_id, br.book_id, br.student_id, br.is_borrowed, br.borrow_date, br.due_date, " +
                "b.title, b.author, b.description AS book_description, b.quantity, " +
                "st.full_name, st.class_name " +
                "FROM BorrowRecord br " +
                "JOIN Book b ON br.book_id = b.book_id " +
                "JOIN Student st ON br.student_id = st.student_id " +
                "WHERE br.borrow_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, borrowId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    record = new BorrowRecord();
                    record.setBorrowId(rs.getString("borrow_id"));
                    record.setBookId(rs.getString("book_id"));
                    record.setStudentId(rs.getString("student_id"));
                    record.setBorrowed(rs.getBoolean("is_borrowed"));
                    record.setBorrowDate(rs.getDate("borrow_date"));
                    record.setDueDate(rs.getDate("due_date"));

                    Book book = new Book();
                    book.setBookId(rs.getString("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setDescription(rs.getString("book_description"));
                    book.setQuantity(rs.getInt("quantity"));
                    record.setBook(book);

                    Student student = new Student();
                    student.setStudentId(rs.getString("student_id"));
                    student.setFullName(rs.getString("full_name"));
                    student.setClassName(rs.getString("class_name"));
                    record.setStudent(student);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return record;
    }
}