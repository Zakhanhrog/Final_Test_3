package com.example.library.model;

import java.sql.Date;

public class BorrowRecord {
    private String borrowId;
    private String bookId;
    private String studentId;
    private boolean isBorrowed;
    private Date borrowDate;
    private Date dueDate;

    private Book book;
    private Student student;

    public BorrowRecord() {
    }

    public BorrowRecord(String borrowId, String bookId, String studentId, boolean isBorrowed, Date borrowDate, Date dueDate) {
        this.borrowId = borrowId;
        this.bookId = bookId;
        this.studentId = studentId;
        this.isBorrowed = isBorrowed;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
    }

    public String getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(String borrowId) {
        this.borrowId = borrowId;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public boolean isBorrowed() {
        return isBorrowed;
    }

    public void setBorrowed(boolean borrowed) {
        isBorrowed = borrowed;
    }

    public Date getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Date borrowDate) {
        this.borrowDate = borrowDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }
}