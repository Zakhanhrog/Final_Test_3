<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="common/header.jsp" />

<div class="alert alert-danger" role="alert">
    <h4 class="alert-heading">An Error Occurred!</h4>
    <p>Sorry, an error occurred while processing your request.</p>
    <hr>
    <p class="mb-0">Please try again later or contact the administrator.</p>
    <c:if test="${not empty exception}">
        <p>Error details: ${pageContext.errorData.throwable.message}</p>
    </c:if>
    <c:if test="${not empty requestScope['javax.servlet.error.message']}">
        <p>Error: ${requestScope['javax.servlet.error.message']}</p>
    </c:if>
</div>

<jsp:include page="common/footer.jsp" />