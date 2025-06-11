<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../common/header.jsp" />

<div class="card">
    <div class="card-header">
        <h1 class="page-title mb-0 fs-5"><i class="bi bi-card-list me-2"></i>Borrowed Books Report</h1>
    </div>
    <div class="card-body">
        <div class="search-form-container">
            <form method="GET" action="${pageContext.request.contextPath}/borrowed-items" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="list">
                <div class="col-md-5">
                    <label for="searchBookTitle" class="form-label small">Book Title:</label>
                    <input type="text" class="form-control form-control-sm" id="searchBookTitle" name="searchBookTitle" placeholder="Enter book title..." value="${fn:escapeXml(searchBookTitle)}">
                </div>
                <div class="col-md-5">
                    <label for="searchStudentName" class="form-label small">Student Name:</label>
                    <input type="text" class="form-control form-control-sm" id="searchStudentName" name="searchStudentName" placeholder="Enter student name..." value="${fn:escapeXml(searchStudentName)}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary btn-sm w-100">
                        <i class="bi bi-search me-1"></i>Search
                    </button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-hover table-bordered">
                <thead>
                <tr>
                    <th class="text-center" style="width: 10%;">Borrow ID</th>
                    <th style="width: 20%;">Book</th>
                    <th style="width: 18%;">Student</th>
                    <th class="text-center" style="width: 8%;">Class</th>
                    <th class="text-center" style="width: 12%;">Borrowed On</th>
                    <th class="text-center" style="width: 12%;">Return By</th>
                    <th class="text-center" style="width: 10%;">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${borrowedItems}" varStatus="loop">
                    <tr>
                        <td class="text-center small">${fn:escapeXml(item.borrowId)}</td>
                        <td>
                                ${fn:escapeXml(item.book.title)}<br>
                            <small class="text-muted">By: ${fn:escapeXml(item.book.author)}</small>
                        </td>
                        <td>${fn:escapeXml(item.student.fullName)}</td>
                        <td class="text-center small">${fn:escapeXml(item.student.className)}</td>
                        <td class="text-center small"><fmt:formatDate value="${item.borrowDate}" pattern="dd MMM, yyyy" /></td>
                        <td class="text-center small"><fmt:formatDate value="${item.dueDate}" pattern="dd MMM, yyyy" /></td>
                        <td class="text-center action-buttons">
                            <button type="button" class="btn btn-outline-warning btn-sm return-book-btn"
                                    id="returnBtn-${loop.index}"
                                    data-bs-toggle="modal"
                                    data-bs-target="#returnConfirmModal"
                                    data-borrow-id="${fn:escapeXml(item.borrowId)}"
                                    data-book-id="${fn:escapeXml(item.book.bookId)}"
                                    data-student-name="${fn:escapeXml(item.student.fullName)}"
                                    data-book-title="${fn:escapeXml(item.book.title)}">
                                <i class="bi bi-arrow-return-left"></i> Return
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty borrowedItems}">
                    <tr>
                        <td colspan="7" class="text-center fst-italic p-4 text-muted">
                            No books are currently borrowed <c:if test="${not empty searchBookTitle or not empty searchStudentName}">that match your search criteria</c:if>.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="returnConfirmModal" tabindex="-1" aria-labelledby="returnConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title text-dark" id="returnConfirmModalLabel">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Confirm Book Return
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure student <strong id="modalStudentNameText" class="text-decoration-underline"></strong> will return the book <strong id="modalBookNameText" class="text-decoration-underline"></strong>?
            </div>
            <div class="modal-footer">
                <form id="returnBookForm" method="POST" action="${pageContext.request.contextPath}/borrowed-items" class="w-100">
                    <input type="hidden" name="action" value="returnBook">
                    <input type="hidden" id="modalFormBorrowId" name="borrowId">
                    <input type="hidden" id="modalFormBookId" name="bookId">
                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-lg me-1"></i>No, Cancel
                        </button>
                        <button type="submit" class="btn btn-warning">
                            <i class="bi bi-check-lg me-1"></i>Yes, Return Book
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var returnConfirmModalElement = document.getElementById('returnConfirmModal');
        if (returnConfirmModalElement) {
            returnConfirmModalElement.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                if (!button && document.activeElement && document.activeElement.matches('[data-bs-toggle="modal"]')) {
                    button = document.activeElement;
                }
                if (!button) {
                    console.error("DEBUG: Could not determine the triggering button for modal."); return;
                }

                var modalStudentNameElement = returnConfirmModalElement.querySelector('#modalStudentNameText');
                var modalBookNameElement = returnConfirmModalElement.querySelector('#modalBookNameText');
                var modalFormBorrowIdElement = returnConfirmModalElement.querySelector('#modalFormBorrowId');
                var modalFormBookIdElement = returnConfirmModalElement.querySelector('#modalFormBookId');

                if(modalStudentNameElement) modalStudentNameElement.textContent = button.getAttribute('data-student-name');
                if(modalBookNameElement) modalBookNameElement.textContent = button.getAttribute('data-book-title');
                if(modalFormBorrowIdElement) modalFormBorrowIdElement.value = button.getAttribute('data-borrow-id');
                if(modalFormBookIdElement) modalFormBookIdElement.value = button.getAttribute('data-book-id');
            });
        }
    });
</script>
<jsp:include page="../common/footer.jsp" />