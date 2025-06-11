<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../common/header.jsp" />

<h2 class="page-title">Book List</h2>

<div id="dynamicAlertPlaceholder" class="mb-3"></div>

<c:if test="${not empty borrowErrorMsg}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert" id="serverErrorPopup">
            ${fn:escapeXml(borrowErrorMsg)}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<table class="table table-striped table-bordered table-hover">
    <thead class="table-dark">
    <tr>
        <th>Book ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Quantity</th>
        <th>Description</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="book" items="${books}">
        <tr>
            <td>${fn:escapeXml(book.bookId)}</td>
            <td>${fn:escapeXml(book.title)}</td>
            <td>${fn:escapeXml(book.author)}</td>
            <td id="quantity-${fn:escapeXml(book.bookId)}">${book.quantity}</td>
            <td>${fn:escapeXml(book.description)}</td>
            <td class="action-buttons">
                <button type="button" class="btn btn-sm
                        <c:choose>
                            <c:when test='${book.quantity > 0}'>btn-success</c:when>
                            <c:otherwise>btn-secondary</c:otherwise>
                        </c:choose>"
                        onclick="handleBorrowClick('${book.bookId}', ${book.quantity})">
                    Borrow
                </button>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty books}">
        <tr>
            <td colspan="6" class="text-center">No books available in the library.</td>
        </tr>
    </c:if>
    </tbody>
</table>

<script>
    function showAlert(message, type = 'danger') {
        var alertPlaceholder = document.getElementById('dynamicAlertPlaceholder');
        var wrapper = document.createElement('div');
        wrapper.innerHTML = [
            '<div class="alert alert-' + type + ' alert-dismissible" role="alert">',
            '   <div>' + message + '</div>',
            '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>',
            '</div>'
        ].join('');

        while (alertPlaceholder.firstChild) {
            alertPlaceholder.removeChild(alertPlaceholder.firstChild);
        }
        alertPlaceholder.append(wrapper);

        setTimeout(function() {
            var alertInstance = bootstrap.Alert.getInstance(wrapper.firstChild);
            if (alertInstance) {
                alertInstance.close();
            } else if (wrapper.firstChild) {
                if (wrapper.firstChild.parentNode) {
                    wrapper.firstChild.parentNode.removeChild(wrapper.firstChild);
                }
            }
        }, 7000);
    }

    function handleBorrowClick(bookId, currentQuantity) {
        console.log("Borrow clicked for bookId: " + bookId + ", quantity: " + currentQuantity);
        if (currentQuantity > 0) {
            window.location.href = '${pageContext.request.contextPath}/borrow?action=prepare&bookId=' + bookId;
        } else {
            showAlert('This book is temporarily out of stock. Please choose another book.', 'warning');
        }
    }

    if (document.getElementById('serverErrorPopup')) {
        setTimeout(function() {
            var errorPopupElement = document.getElementById('serverErrorPopup');
            if (errorPopupElement) {
                var bsAlert = bootstrap.Alert.getInstance(errorPopupElement);
                if(bsAlert) {
                    bsAlert.close();
                } else {
                    var alertParent = errorPopupElement.parentNode;
                    if(alertParent) alertParent.removeChild(errorPopupElement);
                }
            }
        }, 7000);
    }
</script>

<jsp:include page="../common/footer.jsp" />