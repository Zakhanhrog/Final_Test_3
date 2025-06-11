package com.example.library.model;

public class Book {
    private String bookId;
    private String title;
    private String author;
    private String description;
    private int quantity;

    public Book() {
    }

    public Book(String bookId, String title, String author, String description, int quantity) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.description = description;
        this.quantity = quantity;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}