package com.example.library.controller;

import com.example.library.dao.BookDAO;
import com.example.library.dao.BorrowRecordDAO;
import com.example.library.dao.StudentDAO;
import com.example.library.model.Book;
import com.example.library.model.BorrowRecord;
import com.example.library.model.Student;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "BorrowServlet", urlPatterns = "/borrow")
public class BorrowServlet extends HttpServlet {
    private BookDAO bookDAO;
    private StudentDAO studentDAO;
    private BorrowRecordDAO borrowRecordDAO;
    private final DateTimeFormatter SQL_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private final DateTimeFormatter DISPLAY_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    public void init() {
        bookDAO = new BookDAO();
        studentDAO = new StudentDAO();
        borrowRecordDAO = new BorrowRecordDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "prepare";
        }

        switch (action) {
            case "prepare":
                showBorrowForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/books");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        if ("create".equals(action)) {
            createBorrowRecord(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    private void showBorrowForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        if (bookId == null || bookId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books?borrowError=nobookid");
            return;
        }

        Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/books?borrowError=notfound");
            return;
        }

        if (book.getQuantity() <= 0) {
            response.sendRedirect(request.getContextPath() + "/books?borrowError=outofstock");
            return;
        }

        List<Student> students = studentDAO.getAllStudents();
        String newBorrowId = borrowRecordDAO.generateNewBorrowId();
        String currentDateDisplay = LocalDate.now().format(DISPLAY_DATE_FORMATTER);
        String currentDateSql = LocalDate.now().format(SQL_DATE_FORMATTER);


        request.setAttribute("book", book);
        request.setAttribute("students", students);
        request.setAttribute("newBorrowId", newBorrowId);
        request.setAttribute("currentDateDisplay", currentDateDisplay);
        request.setAttribute("currentDateSql", currentDateSql);


        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/borrow/create_borrow_form.jsp");
        dispatcher.forward(request, response);
    }

    private void createBorrowRecord(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String borrowId = request.getParameter("borrowId");
        String bookId = request.getParameter("bookId");
        String studentId = request.getParameter("studentId");
        String borrowDateStr = request.getParameter("borrowDateSql"); // from hidden input
        String dueDateStr = request.getParameter("dueDate");

        Book book = bookDAO.getBookById(bookId);
        if (book == null || book.getQuantity() <= 0) {
            response.sendRedirect(request.getContextPath() + "/books?borrowError=outofstock_on_submit");
            return;
        }

        Date borrowDate = Date.valueOf(LocalDate.parse(borrowDateStr, SQL_DATE_FORMATTER));
        Date dueDate = Date.valueOf(LocalDate.parse(dueDateStr, SQL_DATE_FORMATTER));


        BorrowRecord borrowRecord = new BorrowRecord(borrowId, bookId, studentId, true, borrowDate, dueDate);

        boolean success = borrowRecordDAO.saveBorrowRecord(borrowRecord);
        if (success) {
            bookDAO.updateBookQuantity(bookId, book.getQuantity() - 1);
        }

        response.sendRedirect(request.getContextPath() + "/books");
    }
}