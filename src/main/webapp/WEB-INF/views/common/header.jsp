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
        body {
            font-family: 'Segoe UI', Roboto, "Helvetica Neue", Arial, sans-serif;
            padding-top: 1rem;
            padding-bottom: 1rem;
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-container {
            flex-grow: 1;
        }
        .container-fluid, .container {
            max-width: 1280px;
            margin-left: auto;
            margin-right: auto;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .action-buttons .btn {
            margin-right: 0.25rem;
            margin-bottom: 0.25rem;
        }
        .navbar-brand {
            font-weight: 600;
            font-size: 1.4rem;
        }
        .page-title {
            margin-bottom: 1.5rem;
            font-size: 1.85rem;
            font-weight: 500;
            color: #0b0a0a;
        }
        .card {
            border: 1px solid #e0e0e0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e0e0e0;
            padding: 0.75rem 1.25rem;
        }
        .form-label {
            font-weight: 500;
            color: #495057;
        }
        .btn-action-icon {
            padding: 0.375rem 0.5rem;
        }
        .table thead th {
            background-color: #e9ecef;
            border-color: #dee2e6;
            color: #495057;
            font-weight: 500;
        }
        .modal-header {
            border-bottom: 1px solid #dee2e6;
        }
        .modal-footer {
            border-top: 1px solid #dee2e6;
            background-color: #f8f9fa;
        }
        .search-form-container {
            padding: 1rem;
            background-color: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 0.25rem;
            margin-bottom: 1.5rem;
        }
        .alert i {
            vertical-align: middle;
        }

        .bg-custom-black {
            background-color: rgba(35, 114, 177, 0.85) !important;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
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