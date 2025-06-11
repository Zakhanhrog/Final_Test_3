<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../common/header.jsp" />

<h2 class="page-title">Borrowed Books Report</h2>

<form method="GET" action="${pageContext.request.contextPath}/borrowed-items" class="row gx-3 gy-2 align-items-center mb-4">
    <input type="hidden" name="action" value="list">
    <div class="col-sm-4">
        <label class="visually-hidden" for="searchBookTitle">Book Title</label>
        <input type="text" class="form-control" id="searchBookTitle" name="searchBookTitle" placeholder="Book Title" value="${fn:escapeXml(searchBookTitle)}">
    </div>
    <div class="col-sm-4">
        <label class="visually-hidden" for="searchStudentName">Student Name</label>
        <input type="text" class="form-control" id="searchStudentName" name="searchStudentName" placeholder="Student Name" value="${fn:escapeXml(searchStudentName)}">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-info">Search</button>
    </div>
</form>

<table class="table table-striped table-bordered table-hover">
    <thead class="table-dark">
    <tr>
        <th>Borrow ID</th>
        <th>Book Title</th>
        <th>Author</th>
        <th>Student Name</th>
        <th>Class</th>
        <th>Borrow Date</th>
        <th>Due Date</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${borrowedItems}" varStatus="loop">
        <tr>
            <td>${fn:escapeXml(item.borrowId)}</td>
            <td>${fn:escapeXml(item.book.title)}</td>
            <td>${fn:escapeXml(item.book.author)}</td>
            <td>${fn:escapeXml(item.student.fullName)}</td>
            <td>${fn:escapeXml(item.student.className)}</td>
            <td><fmt:formatDate value="${item.borrowDate}" pattern="dd/MM/yyyy" /></td>
            <td><fmt:formatDate value="${item.dueDate}" pattern="dd/MM/yyyy" /></td>
            <td class="action-buttons">
                <button type="button" class="btn btn-warning btn-sm return-book-btn"
                        id="returnBtn-${loop.index}"
                        data-bs-toggle="modal"
                        data-bs-target="#returnConfirmModal"
                        data-borrow-id="${fn:escapeXml(item.borrowId)}"
                        data-book-id="${fn:escapeXml(item.book.bookId)}"
                        data-student-name="${fn:escapeXml(item.student.fullName)}"
                        data-book-title="${fn:escapeXml(item.book.title)}">
                    Return Book
                </button>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty borrowedItems}">
        <tr>
            <td colspan="8" class="text-center">No books are currently borrowed.</td>
        </tr>
    </c:if>
    </tbody>
</table>

<!-- Return Book Confirmation Modal -->
<div class="modal fade" id="returnConfirmModal" tabindex="-1" aria-labelledby="returnConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="returnConfirmModalLabel">Confirm Book Return</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Student <strong id="modalStudentNameText"></strong> to return book <strong id="modalBookNameText"></strong>?
            </div>
            <div class="modal-footer">
                <form id="returnBookForm" method="POST" action="${pageContext.request.contextPath}/borrowed-items">
                    <input type="hidden" name="action" value="returnBook">
                    <input type="hidden" id="modalFormBorrowId" name="borrowId">
                    <input type="hidden" id="modalFormBookId" name="bookId">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="submit" class="btn btn-primary">Return Book</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var returnConfirmModalElement = document.getElementById('returnConfirmModal');

        if (returnConfirmModalElement) {
            console.log("DEBUG: Modal element #returnConfirmModal found in the DOM.");

            returnConfirmModalElement.addEventListener('show.bs.modal', function (event) {
                console.log("DEBUG: 'show.bs.modal' event triggered for #returnConfirmModal");

                var button = event.relatedTarget;

                if (!button) {
                    console.error("DEBUG: event.relatedTarget is NULL or undefined. This is unexpected when modal is triggered by a data-bs-toggle button.");
                    var activeElement = document.activeElement;
                    if (activeElement && activeElement.matches('[data-bs-toggle="modal"]')) {
                        console.log("DEBUG: Fallback: using document.activeElement as button:", activeElement);
                        button = activeElement;
                    } else {
                        console.error("DEBUG: Could not determine the triggering button. Modal data will not be populated.");
                        return;
                    }
                } else {
                    console.log("DEBUG: Triggering button (event.relatedTarget):", button);
                    console.log("DEBUG: Button ID:", button.id);
                }

                var borrowId = button.getAttribute('data-borrow-id');
                var bookId = button.getAttribute('data-book-id');
                var studentName = button.getAttribute('data-student-name');
                var bookTitle = button.getAttribute('data-book-title');

                console.log("DEBUG: Data from button attributes: borrowId='" + borrowId + "', bookId='" + bookId + "', studentName='" + studentName + "', bookTitle='" + bookTitle + "'");

                var modalStudentNameElement = returnConfirmModalElement.querySelector('#modalStudentNameText');
                var modalBookNameElement = returnConfirmModalElement.querySelector('#modalBookNameText');
                var modalFormBorrowIdElement = returnConfirmModalElement.querySelector('#modalFormBorrowId');
                var modalFormBookIdElement = returnConfirmModalElement.querySelector('#modalFormBookId');

                if(modalStudentNameElement) {
                    modalStudentNameElement.textContent = studentName;
                    console.log("DEBUG: Successfully set student name in modal: '" + studentName + "'");
                } else {
                    console.error("DEBUG: Element #modalStudentNameText NOT found in modal.");
                }

                if(modalBookNameElement) {
                    modalBookNameElement.textContent = bookTitle;
                    console.log("DEBUG: Successfully set book title in modal: '" + bookTitle + "'");
                } else {
                    console.error("DEBUG: Element #modalBookNameText NOT found in modal.");
                }

                if(modalFormBorrowIdElement) {
                    modalFormBorrowIdElement.value = borrowId;
                    console.log("DEBUG: Successfully set borrowId in modal form: '" + borrowId + "'");
                } else {
                    console.error("DEBUG: Element #modalFormBorrowId (for form input) NOT found in modal.");
                }

                if(modalFormBookIdElement) {
                    modalFormBookIdElement.value = bookId;
                    console.log("DEBUG: Successfully set bookId in modal form: '" + bookId + "'");
                } else {
                    console.error("DEBUG: Element #modalFormBookId (for form input) NOT found in modal.");
                }
            });

            console.log("DEBUG: Event listener for 'show.bs.modal' attached to #returnConfirmModal.");

        } else {
            console.error("DEBUG: Modal element #returnConfirmModal NOT found in the DOM. Cannot attach event listener.");
        }

        var allReturnButtons = document.querySelectorAll('.return-book-btn');
        console.log("DEBUG: Found " + allReturnButtons.length + " '.return-book-btn' elements.");
        allReturnButtons.forEach(function(btn, index) {
            console.log("DEBUG: Button " + index + ": ID=" + btn.id + ", data-bs-target=" + btn.getAttribute('data-bs-target'));
        });

    });
</script>

<jsp:include page="../common/footer.jsp" />