<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.BikeDAO, com.armora.dao.UserDAO, com.armora.model.Bike, com.armora.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    UserDAO userDAO = new UserDAO();
    BikeDAO bikeDAO = new BikeDAO();
    List<User> users = userDAO.getApprovedUsers();
    List<Bike> bikes = bikeDAO.getAvailableBikes();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Bike | Armora Admin</title>
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
                <li><a href="issue-bike.jsp" class="active">Issue Bike</a></li>
                <li><a href="reports.jsp">Reports &amp; Analytics</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 1.5rem;">Issue Bike to User</h2>

            <% if ("issued".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Bike issued successfully.</div>
            <% } else if ("failed".equals(msg)) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">Could not issue bike. Ensure the bike is available and user is approved.</div>
            <% } %>

            <div style="max-width: 600px; background: rgba(30, 41, 59, 0.5); padding: 2rem; border-radius: 12px; border: 1px solid var(--border-color);">
                <form action="../AdminServlet" method="post">
                    <input type="hidden" name="action" value="issueBike">

                    <div class="form-group">
                        <label for="userId">Select User</label>
                        <select id="userId" name="userId" required style="width: 100%; padding: 0.75rem; border-radius: 8px; background: var(--surface-color); color: var(--text-primary); border: 1px solid var(--border-color);">
                            <option value="">-- Choose approved user --</option>
                            <% for (User u : users) { %>
                                <option value="<%= u.getUserId() %>"><%= u.getFirstName() %> <%= u.getLastName() %> (<%= u.getEmail() %>)</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="bikeId">Select Available Bike</label>
                        <select id="bikeId" name="bikeId" required style="width: 100%; padding: 0.75rem; border-radius: 8px; background: var(--surface-color); color: var(--text-primary); border: 1px solid var(--border-color);">
                            <option value="">-- Choose bike --</option>
                            <% for (Bike b : bikes) { %>
                                <option value="<%= b.getBikeId() %>"><%= b.getTitle() %> — <%= b.getGenre() %> (Rs <%= b.getPricePerHour() %>/hr)</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dueDate">Return Due Date</label>
                        <input type="date" id="dueDate" name="dueDate" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Issue Bike</button>
                </form>

                <% if (users.isEmpty()) { %>
                    <p style="margin-top: 1.5rem; color: var(--text-secondary);">No approved users yet. <a href="manage-users.jsp" style="color: var(--primary-color);">Approve users</a> first.</p>
                <% } %>
                <% if (bikes.isEmpty()) { %>
                    <p style="margin-top: 1rem; color: var(--text-secondary);">No available bikes. <a href="manage-bikes.jsp" style="color: var(--primary-color);">Add or free up bikes</a>.</p>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
