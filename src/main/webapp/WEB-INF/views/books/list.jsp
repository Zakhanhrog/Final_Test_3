<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../common/header.jsp" />

<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h1 class="page-title mb-0 fs-5"><i class="bi bi-journals me-2"></i>Book Inventory</h1>
    </div>
    <div class="card-body">
        <div id="dynamicAlertPlaceholder" class="mb-3"></div>
        <c:if test="${not empty borrowErrorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert" id="serverErrorPopup">
                <i class="bi bi-exclamation-triangle-fill"></i>${fn:escapeXml(borrowErrorMsg)}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="table-responsive">
            <table class="table table-hover table-bordered"> <%-- Removed table-striped for cleaner look, added table-bordered --%>
                <thead>
                <tr>
                    <th class="text-center" style="width: 10%;">ID</th>
                    <th style="width: 25%;">Title</th>
                    <th style="width: 20%;">Author</th>
                    <th class="text-center" style="width: 10%;">Quantity</th>
                    <th style="width: 25%;">Description</th>
                    <th class="text-center" style="width: 10%;">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="book" items="${books}">
                    <tr>
                        <td class="text-center small">${fn:escapeXml(book.bookId)}</td>
                        <td>${fn:escapeXml(book.title)}</td>
                        <td class="small">${fn:escapeXml(book.author)}</td>
                        <td class="text-center fw-bold">${book.quantity}</td>
                        <td class="small">${fn:escapeXml(book.description)}</td>
                        <td class="text-center action-buttons">
                            <button type="button" class="btn btn-sm
                                    <c:choose>
                                        <c:when test='${book.quantity > 0}'>btn-outline-primary</c:when>
                                        <c:otherwise>btn-outline-secondary disabled</c:otherwise> <%-- Added disabled for clarity --%>
                                    </c:choose>"
                                    onclick="handleBorrowClick('${book.bookId}', ${book.quantity})">
                                <i class="bi bi-hand-index-thumb"></i> Borrow
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty books}">
                    <tr>
                        <td colspan="6" class="text-center fst-italic p-4 text-muted">No books available in the library at the moment.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function showAlert(message, type = 'danger') {
        var alertPlaceholder = document.getElementById('dynamicAlertPlaceholder');
        var iconClass = type === 'warning' ? 'bi-exclamation-triangle-fill' : (type === 'success' ? 'bi-check-circle-fill' : 'bi-info-circle-fill');
        var wrapper = document.createElement('div');
        wrapper.innerHTML = [
            '<div class="alert alert-' + type + ' alert-dismissible fade show d-flex align-items-center" role="alert">',
            '   <i class="bi ' + iconClass + ' flex-shrink-0"></i>',
            '   <div class="ms-2">' + message + '</div>',
            '   <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>',
            '</div>'
        ].join('');

        while (alertPlaceholder.firstChild) {
            alertPlaceholder.removeChild(alertPlaceholder.firstChild);
        }
        alertPlaceholder.append(wrapper.firstChild);

        setTimeout(function() {
            var alertElement = alertPlaceholder.querySelector('.alert');
            if(alertElement) {
                var bsAlert = bootstrap.Alert.getInstance(alertElement);
                if (bsAlert) {
                    bsAlert.close();
                } else if (alertElement.parentNode) {
                    alertElement.parentNode.removeChild(alertElement);
                }
            }
        }, 5000);
    }

    function handleBorrowClick(bookId, currentQuantity) {
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
        }, 5000);
    }
</script>
<jsp:include page="../common/footer.jsp" />