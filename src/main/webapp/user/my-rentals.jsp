<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.IssueDAO, com.armora.model.Issue, com.armora.model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    IssueDAO issueDAO = new IssueDAO();
    List<Issue> rentals = issueDAO.getIssuesByUser(currentUser.getUserId());
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals | Armora</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <nav class="navbar">
        <a href="../index.jsp" class="logo">
            <img src="../images/logo.png" alt="Armora Bike Rentals logo">
            <span class="logo-text">Armora <span>Bikes</span></span>
        </a>
        <div class="auth-buttons">
            <span style="align-self: center; margin-right: 1rem; color: var(--text-secondary);">Welcome, <%= currentUser.getFirstName() %></span>
            <a href="../LogoutServlet" class="btn btn-outline">Log Out</a>
        </div>
    </nav>

    <div class="dashboard-container">
        <aside class="sidebar">
            <ul class="sidebar-nav">
                <li><a href="dashboard.jsp">My Profile</a></li>
                <li><a href="search.jsp">Search Bikes</a></li>
                <li><a href="my-rentals.jsp" class="active">My Rentals</a></li>
                <li><a href="wishlist.jsp">My Wishlist</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 2rem;">My Rentals</h2>

            <table>
                <thead>
                    <tr>
                        <th>Issue ID</th>
                        <th>Bike Model</th>
                        <th>Type</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Returned</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (rentals.isEmpty()) { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-secondary); padding: 2rem;">
                                No rentals yet. <a href="search.jsp" style="color: var(--primary-color);">Browse bikes</a> or ask admin to issue a bike to you.
                            </td>
                        </tr>
                    <% } else {
                        for (Issue rental : rentals) { %>
                        <tr>
                            <td>#<%= rental.getIssueId() %></td>
                            <td><%= rental.getBikeTitle() %></td>
                            <td><%= rental.getBikeGenre() != null ? rental.getBikeGenre() : "—" %></td>
                            <td><%= rental.getIssueDate() %></td>
                            <td><%= rental.getDueDate() %></td>
                            <td><%= rental.getReturnDate() != null ? rental.getReturnDate() : "—" %></td>
                            <td>
                                <% if ("ACTIVE".equals(rental.getStatus())) { %>
                                    <span style="color: #fbbf24;">Active</span>
                                <% } else { %>
                                    <span style="color: #4ade80;">Returned</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </main>
    </div>
</body>
</html>
