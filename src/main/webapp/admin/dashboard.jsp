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
    List<Issue> recentIssues = issueDAO.getAllIssues();
    if (recentIssues.size() > 10) {
        recentIssues = recentIssues.subList(0, 10);
    }
    java.util.List<com.armora.model.Bike> fleetBikes = bikeDAO.getAllBikes();
    request.setAttribute("fleetBikes", fleetBikes);
    request.setAttribute("showAdminActions", Boolean.TRUE);
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Armora</title>
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
                <li><a href="dashboard.jsp" class="active">Overview</a></li>
                <li><a href="manage-bikes.jsp">Manage Bikes</a></li>
                <li><a href="manage-users.jsp">Manage Users (Approve)</a></li>
                <li><a href="issue-bike.jsp">Issue Bike</a></li>
                <li><a href="reports.jsp">Reports &amp; Analytics</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 2rem;">Dashboard Overview</h2>

            <% if ("returned".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Bike marked as returned.</div>
            <% } else if ("failed".equals(msg)) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">Action failed. Please try again.</div>
            <% } %>

            <div class="card-grid">
                <div class="card">
                    <h3>Total Bikes</h3>
                    <div class="value"><%= bikeDAO.countAll() %></div>
                </div>
                <div class="card">
                    <h3>Active Users</h3>
                    <div class="value"><%= userDAO.countApprovedUsers() %></div>
                </div>
                <div class="card">
                    <h3>Bikes Issued</h3>
                    <div class="value"><%= bikeDAO.countByStatus("ISSUED") %></div>
                </div>
                <div class="card">
                    <h3>Pending Approvals</h3>
                    <div class="value" style="color: var(--accent-color);"><%= userDAO.countPendingApprovals() %></div>
                </div>
            </div>

            <jsp:include page="../includes/bike-fleet-grid.jsp" />

            <h3 style="margin-bottom: 1rem; margin-top: 3rem;">Recent Bike Issues</h3>
            <table>
                <thead>
                    <tr>
                        <th>Issue ID</th>
                        <th>User Name</th>
                        <th>Bike Model</th>
                        <th>Issue Date</th>
                        <th>Return Due</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (recentIssues.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align: center; color: var(--text-secondary);">No issues yet.</td></tr>
                    <% } else {
                        for (Issue issue : recentIssues) { %>
                        <tr>
                            <td>#<%= issue.getIssueId() %></td>
                            <td><%= issue.getUserName() %></td>
                            <td><%= issue.getBikeTitle() %></td>
                            <td><%= issue.getIssueDate() %></td>
                            <td><%= issue.getDueDate() %></td>
                            <td>
                                <% if ("ACTIVE".equals(issue.getStatus())) { %>
                                    <span style="color: #fbbf24;">Issued</span>
                                <% } else { %>
                                    <span style="color: #4ade80;">Returned</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("ACTIVE".equals(issue.getStatus())) { %>
                                <form action="../AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="returnBike">
                                    <input type="hidden" name="issueId" value="<%= issue.getIssueId() %>">
                                    <input type="hidden" name="from" value="dashboard.jsp">
                                    <button type="submit" class="btn btn-outline" style="padding: 0.25rem 0.75rem; font-size: 0.8rem;">Mark Returned</button>
                                </form>
                                <% } else { %>
                                    <span style="color: var(--text-secondary);">—</span>
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
