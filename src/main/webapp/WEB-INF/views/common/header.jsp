<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { font-family: Arial, sans-serif; padding-top: 20px; }
        .container { max-width: 1140px; }
        .table th, .table td { vertical-align: middle; }
        .action-buttons .btn { margin-right: 5px; }
        .navbar-brand { font-weight: bold; }
        .page-title { margin-bottom: 20px; text-align: center; font-size: 1.75rem; font-weight: 500;}
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/books">Devfromzk Library</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link <c:if test="${pageContext.request.servletPath.endsWith('/books') || pageContext.request.servletPath eq '/'}">active</c:if>" aria-current="page" href="${pageContext.request.contextPath}/books">Book List</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${pageContext.request.servletPath.endsWith('/borrowed-items')}">active</c:if>" href="${pageContext.request.contextPath}/borrowed-items?action=list">Borrowed Items</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">