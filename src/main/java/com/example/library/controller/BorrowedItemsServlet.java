package com.example.library.controller;

import com.example.library.dao.BookDAO;
import com.example.library.dao.BorrowRecordDAO;
import com.example.library.model.Book;
import com.example.library.model.BorrowRecord;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BorrowedItemsServlet", urlPatterns = "/borrowed-items")
public class BorrowedItemsServlet extends HttpServlet {
    private BorrowRecordDAO borrowRecordDAO;
    private BookDAO bookDAO;

    @Override
    public void init() {
        borrowRecordDAO = new BorrowRecordDAO();
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("list".equals(action)) {
            listBorrowedItems(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("returnBook".equals(action)) {
            returnBook(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/borrowed-items?action=list");
        }
    }

    private void listBorrowedItems(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchBookTitle = request.getParameter("searchBookTitle");
        String searchStudentName = request.getParameter("searchStudentName");

        List<BorrowRecord> borrowedItems = borrowRecordDAO.getActiveBorrowRecords(searchBookTitle, searchStudentName);
        request.setAttribute("borrowedItems", borrowedItems);
        request.setAttribute("searchBookTitle", searchBookTitle);
        request.setAttribute("searchStudentName", searchStudentName);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/borrow/list_borrowed_items.jsp");
        dispatcher.forward(request, response);
    }

    private void returnBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String borrowId = request.getParameter("borrowId");
        String bookId = request.getParameter("bookId");

        BorrowRecord record = borrowRecordDAO.getBorrowRecordById(borrowId);

        if (record != null && record.isBorrowed()) {
            boolean statusUpdated = borrowRecordDAO.updateBorrowRecordStatus(borrowId, false);
            if (statusUpdated) {
                Book book = bookDAO.getBookById(bookId);
                if (book != null) {
                    bookDAO.updateBookQuantity(bookId, book.getQuantity() + 1);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/borrowed-items?action=list");
    }
}