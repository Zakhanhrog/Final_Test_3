package com.example.library.controller;

import com.example.library.dao.BookDAO;
import com.example.library.model.Book;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookServlet", urlPatterns = {"/books", ""})
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO;

    @Override
    public void init() {
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books);

        String borrowErrorParam = request.getParameter("borrowError");
        if (borrowErrorParam != null) {
            String errorMessage = "";
            switch (borrowErrorParam) {
                case "outofstock":
                case "outofstock_on_submit":
                    errorMessage = "This book is temporarily out of stock. Please choose another book.";
                    break;
                case "nobookid":
                    errorMessage = "No book ID was provided for borrowing. Please try again.";
                    break;
                case "notfound":
                    errorMessage = "The selected book was not found in the library.";
                    break;
                default:
                    errorMessage = "An unexpected error occurred during the borrow process.";
                    break;
            }
            request.setAttribute("borrowErrorMsg", errorMessage);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/books/list.jsp");
        dispatcher.forward(request, response);
    }
}