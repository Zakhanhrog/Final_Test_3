package com.example.library.dao;

import com.example.library.config.DatabaseConnector;
import com.example.library.model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String query = "SELECT * FROM Book";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                books.add(new Book(
                        rs.getString("book_id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("description"),
                        rs.getInt("quantity")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public Book getBookById(String bookId) {
        Book book = null;
        String query = "SELECT * FROM Book WHERE book_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    book = new Book(
                            rs.getString("book_id"),
                            rs.getString("title"),
                            rs.getString("author"),
                            rs.getString("description"),
                            rs.getInt("quantity")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return book;
    }

    public boolean updateBookQuantity(String bookId, int newQuantity) {
        String query = "UPDATE Book SET quantity = ? WHERE book_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, newQuantity);
            ps.setString(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}