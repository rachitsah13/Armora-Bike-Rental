<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.BikeDAO, com.armora.model.Bike, com.armora.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    BikeDAO bikeDAO = new BikeDAO();
    List<Bike> bikes = bikeDAO.getAllBikes();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bikes | Armora Admin</title>
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
                <li><a href="manage-bikes.jsp" class="active">Manage Bikes</a></li>
                <li><a href="manage-users.jsp">Manage Users (Approve)</a></li>
                <li><a href="issue-bike.jsp">Issue Bike</a></li>
                <li><a href="reports.jsp">Reports &amp; Analytics</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 1.5rem;">Manage Bikes</h2>

            <% if ("bikeAdded".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Bike added successfully.</div>
            <% } else if ("statusUpdated".equals(msg)) { %>
                <div class="alert" style="background: rgba(56, 189, 248, 0.15); border: 1px solid var(--primary-color); color: var(--primary-color); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Bike status updated.</div>
            <% } else if ("failed".equals(msg)) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">Could not complete action.</div>
            <% } %>

            <div style="background: rgba(30, 41, 59, 0.5); padding: 1.5rem; border-radius: 12px; border: 1px solid var(--border-color); margin-bottom: 2rem;">
                <h3 style="margin-bottom: 1rem;">Add New Bike</h3>
                <form action="../AdminServlet" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 1rem; align-items: end;">
                    <input type="hidden" name="action" value="addBike">
                    <div class="form-group">
                        <label>Model / Title</label>
                        <input type="text" name="title" required placeholder="e.g. BMW S1000RR">
                    </div>
                    <div class="form-group">
                        <label>Serial / ISBN</label>
                        <input type="text" name="isbn" required placeholder="SN-001">
                    </div>
                    <div class="form-group">
                        <label>Type / Genre</label>
                        <input type="text" name="genre" required placeholder="Superbike">
                    </div>
                    <div class="form-group">
                        <label>Brand</label>
                        <input type="text" name="author" required placeholder="BMW">
                    </div>
                    <div class="form-group">
                        <label>Price / Hour (Rs)</label>
                        <input type="number" name="price" step="0.01" min="0" required placeholder="8000">
                    </div>
                    <button type="submit" class="btn btn-primary">Add Bike</button>
                </form>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Model</th>
                        <th>Serial</th>
                        <th>Type</th>
                        <th>Brand</th>
                        <th>Price/Hr</th>
                        <th>Status</th>
                        <th>Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Bike bike : bikes) { %>
                    <tr>
                        <td><%= bike.getBikeId() %></td>
                        <td><%= bike.getTitle() %></td>
                        <td><%= bike.getIsbnNumber() %></td>
                        <td><%= bike.getGenre() %></td>
                        <td><%= bike.getAuthor() %></td>
                        <td>Rs <%= bike.getPricePerHour() %></td>
                        <td><%= bike.getStatus() %></td>
                        <td>
                            <form action="../AdminServlet" method="post" style="display: flex; gap: 0.5rem; align-items: center;">
                                <input type="hidden" name="action" value="updateBikeStatus">
                                <input type="hidden" name="bikeId" value="<%= bike.getBikeId() %>">
                                <select name="status" style="padding: 0.35rem; border-radius: 6px; background: var(--surface-color); color: var(--text-primary); border: 1px solid var(--border-color);">
                                    <option value="AVAILABLE" <%= "AVAILABLE".equals(bike.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
                                    <option value="ISSUED" <%= "ISSUED".equals(bike.getStatus()) ? "selected" : "" %>>ISSUED</option>
                                    <option value="MAINTENANCE" <%= "MAINTENANCE".equals(bike.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
                                </select>
                                <button type="submit" class="btn btn-outline" style="padding: 0.35rem 0.75rem; font-size: 0.8rem;">Save</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </main>
    </div>
</body>
</html>
