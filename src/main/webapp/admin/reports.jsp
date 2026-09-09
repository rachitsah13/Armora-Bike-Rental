<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.BikeDAO, com.armora.dao.UserDAO, com.armora.dao.IssueDAO, com.armora.model.Issue, com.armora.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    BikeDAO bikeDAO = new BikeDAO();
    UserDAO userDAO = new UserDAO();
    IssueDAO issueDAO = new IssueDAO();
    List<Issue> allIssues = issueDAO.getAllIssues();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports | Armora Admin</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <nav class="navbar">
        <a href="dashboard.jsp" class="logo">
            <img src="../images/logo.png" alt="Armora Bike Rentals logo">
            <span class="logo-text">Armora <span>Admin</span></span>
        </a>
        <div class="auth-buttons">
            <span style="align-self: center; margin-right: 1rem; color: var(--text-secondary);">Welcome, <%= admin.getFirstName() %></span>
            <a href="../LogoutServlet" class="btn btn-outline">Log Out</a>
        </div>
    </nav>

    <div class="dashboard-container">
        <aside class="sidebar">
            <ul class="sidebar-nav">
                <li><a href="dashboard.jsp">Overview</a></li>
                <li><a href="manage-bikes.jsp">Manage Bikes</a></li>
                <li><a href="manage-users.jsp">Manage Users (Approve)</a></li>
                <li><a href="issue-bike.jsp">Issue Bike</a></li>
                <li><a href="reports.jsp" class="active">Reports &amp; Analytics</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 2rem;">Reports &amp; Analytics</h2>

            <div class="card-grid">
                <div class="card">
                    <h3>Total Rentals (All Time)</h3>
                    <div class="value"><%= allIssues.size() %></div>
                </div>
                <div class="card">
                    <h3>Active Rentals</h3>
                    <div class="value" style="color: #fbbf24;"><%= issueDAO.countActiveIssues() %></div>
                </div>
                <div class="card">
                    <h3>Completed Returns</h3>
                    <div class="value" style="color: #4ade80;"><%= issueDAO.countReturnedIssues() %></div>
                </div>
                <div class="card">
                    <h3>Bikes in Maintenance</h3>
                    <div class="value"><%= bikeDAO.countByStatus("MAINTENANCE") %></div>
                </div>
            </div>

            <h3 style="margin: 2.5rem 0 1rem;">Fleet Status</h3>
            <div class="card-grid" style="grid-template-columns: repeat(3, 1fr);">
                <div class="card">
                    <h3>Available</h3>
                    <div class="value" style="color: #4ade80;"><%= bikeDAO.countByStatus("AVAILABLE") %></div>
                </div>
                <div class="card">
                    <h3>Issued</h3>
                    <div class="value" style="color: #fbbf24;"><%= bikeDAO.countByStatus("ISSUED") %></div>
                </div>
                <div class="card">
                    <h3>Registered Users</h3>
                    <div class="value"><%= userDAO.getAllUsers().size() %></div>
                </div>
            </div>

            <h3 style="margin: 2.5rem 0 1rem;">Full Rental History</h3>
            <table>
                <thead>
                    <tr>
                        <th>Issue ID</th>
                        <th>User</th>
                        <th>Bike</th>
                        <th>Issued</th>
                        <th>Due</th>
                        <th>Returned</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (allIssues.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align: center; color: var(--text-secondary);">No rental records yet.</td></tr>
                    <% } else {
                        for (Issue issue : allIssues) { %>
                        <tr>
                            <td>#<%= issue.getIssueId() %></td>
                            <td><%= issue.getUserName() %></td>
                            <td><%= issue.getBikeTitle() %></td>
                            <td><%= issue.getIssueDate() %></td>
                            <td><%= issue.getDueDate() %></td>
                            <td><%= issue.getReturnDate() != null ? issue.getReturnDate() : "—" %></td>
                            <td><%= issue.getStatus() %></td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </main>
    </div>
</body>
</html>
