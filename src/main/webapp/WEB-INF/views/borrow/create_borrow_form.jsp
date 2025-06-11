<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../common/header.jsp" />

<h2 class="page-title">Borrow Book</h2>

<div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
        <form method="POST" action="${pageContext.request.contextPath}/borrow">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="bookId" value="${book.bookId}">
            <input type="hidden" name="borrowDateSql" value="${currentDateSql}">

            <div class="mb-3">
                <label for="borrowId" class="form-label">Borrow ID:</label>
                <input type="text" class="form-control" id="borrowId" name="borrowId" value="${newBorrowId}" readonly>
            </div>

            <div class="mb-3">
                <label for="bookTitle" class="form-label">Book Title:</label>
                <input type="text" class="form-control" id="bookTitle" value="${book.title}" readonly>
            </div>

            <div class="mb-3">
                <label for="studentId" class="form-label">Student Name:</label>
                <select class="form-select" id="studentId" name="studentId" required>
                    <option value="">-- Select Student --</option>
                    <c:forEach var="student" items="${students}">
                        <option value="${student.studentId}">${student.fullName} - ${student.className}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label for="borrowDateDisplay" class="form-label">Borrow Date:</label>
                <input type="text" class="form-control" id="borrowDateDisplay" value="${currentDateDisplay}" readonly>
            </div>

            <div class="mb-3">
                <label for="dueDate" class="form-label">Due Date:</label>
                <input type="date" class="form-control" id="dueDate" name="dueDate" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Status:</label>
                <input type="text" class="form-control" value="Borrowed" readonly>
            </div>

            <div class="d-flex justify-content-end">
                <button type="submit" class="btn btn-primary me-2">Borrow Book</button>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary" onclick="return confirmCancellation();">Cancel</a>
            </div>
        </form>
    </div>
</div>
<script>
    function confirmCancellation() {
        return confirm("Are you sure you want to return to the list and cancel the borrowing process?");
    }
    document.addEventListener('DOMContentLoaded', function () {
        var today = new Date().toISOString().split('T')[0];
        var dueDateInput = document.getElementById('dueDate');
        dueDateInput.setAttribute('min', today);

        var borrowDateSqlInput = document.querySelector('input[name="borrowDateSql"]');
        if (borrowDateSqlInput && borrowDateSqlInput.value) {
            var minDueDate = new Date(borrowDateSqlInput.value);
            minDueDate.setDate(minDueDate.getDate() + 1);
            dueDateInput.setAttribute('min', minDueDate.toISOString().split('T')[0]);
        }
    });
</script>
<jsp:include page="../common/footer.jsp" />