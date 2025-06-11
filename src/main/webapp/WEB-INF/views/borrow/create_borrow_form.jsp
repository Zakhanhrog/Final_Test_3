<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../common/header.jsp" />

<div class="row justify-content-center">
    <div class="col-lg-7 col-md-9">
        <div class="card">
            <div class="card-header">
                <h1 class="page-title mb-0 fs-5">
                    <i class="bi bi-journal-plus me-2"></i>Borrow Book: <span class="fw-normal fst-italic">${fn:escapeXml(book.title)}</span>
                </h1>
            </div>
            <div class="card-body p-4">
                <form method="POST" action="${pageContext.request.contextPath}/borrow" id="borrowForm">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="bookId" value="${book.bookId}">
                    <input type="hidden" name="borrowDateSql" value="${currentDateSql}">

                    <div class="row mb-3 align-items-center">
                        <label for="borrowId" class="col-sm-4 col-form-label form-label">Borrow ID:</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control-plaintext ps-0" id="borrowId" name="borrowId" value="${fn:escapeXml(newBorrowId)}" readonly>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label for="bookTitle" class="col-sm-4 col-form-label form-label">Book Title:</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control-plaintext ps-0" id="bookTitle" value="${fn:escapeXml(book.title)}" readonly>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label for="studentId" class="col-sm-4 col-form-label form-label">Student:</label>
                        <div class="col-sm-8">
                            <select class="form-select" id="studentId" name="studentId" required>
                                <option value="" disabled selected>-- Select Student --</option>
                                <c:forEach var="student" items="${students}">
                                    <option value="${student.studentId}">${fn:escapeXml(student.fullName)} (${fn:escapeXml(student.className)})</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label for="borrowDateDisplay" class="col-sm-4 col-form-label form-label">Borrow Date:</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control-plaintext ps-0" id="borrowDateDisplay" value="${fn:escapeXml(currentDateDisplay)}" readonly>
                        </div>
                    </div>

                    <div class="row mb-3 align-items-center">
                        <label for="dueDate" class="col-sm-4 col-form-label form-label">Return By:</label>
                        <div class="col-sm-8">
                            <input type="date" class="form-control" id="dueDate" name="dueDate" required>
                        </div>
                    </div>

                    <div class="row mb-4 align-items-center">
                        <label class="col-sm-4 col-form-label form-label">Status:</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control-plaintext ps-0" value="To be borrowed" readonly>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-secondary" onclick="return confirmCancellation();">
                            <i class="bi bi-x-circle me-1"></i>Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle me-1"></i>Confirm Borrow
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    function confirmCancellation() {
        return confirm("Are you sure you want to cancel and return to the book list?");
    }
    document.addEventListener('DOMContentLoaded', function () {
        var today = new Date();
        var minReturnDate = new Date(today);
        minReturnDate.setDate(today.getDate() + 1);

        var dueDateInput = document.getElementById('dueDate');
        dueDateInput.setAttribute('min', minReturnDate.toISOString().split('T')[0]);

        var borrowDateSqlInputVal = document.querySelector('input[name="borrowDateSql"]').value;
        if (borrowDateSqlInputVal) {
            var borrowDate = new Date(borrowDateSqlInputVal);
            var minDueDateFromBorrow = new Date(borrowDate);
            minDueDateFromBorrow.setDate(borrowDate.getDate() + 1);
            if (minDueDateFromBorrow > minReturnDate) { // if borrow date makes min due date later
                dueDateInput.setAttribute('min', minDueDateFromBorrow.toISOString().split('T')[0]);
            }
        }
    });
</script>
<jsp:include page="../common/footer.jsp" />