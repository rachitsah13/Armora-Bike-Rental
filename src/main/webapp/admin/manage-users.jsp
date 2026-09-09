<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.UserDAO, com.armora.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAllUsers();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | Armora Admin</title>
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
                <li><a href="manage-users.jsp" class="active">Manage Users (Approve)</a></li>
                <li><a href="issue-bike.jsp">Issue Bike</a></li>
                <li><a href="reports.jsp">Reports &amp; Analytics</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 1.5rem;">Manage Users</h2>

            <% if ("approved".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">User approved successfully.</div>
            <% } else if ("paused".equals(msg)) { %>
                <div class="alert" style="background: rgba(251, 191, 36, 0.15); border: 1px solid #fbbf24; color: #fbbf24; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">User subscription paused.</div>
            <% } else if ("deleted".equals(msg)) { %>
                <div class="alert" style="background: rgba(248, 113, 113, 0.15); border: 1px solid #f87171; color: #f87171; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">User deleted successfully.</div>
            <% } else if ("failed".equals(msg)) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">Could not complete action.</div>
            <% } %>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Course</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (User u : users) { %>
                    <tr>
                        <td><%= u.getUserId() %></td>
                        <td>
                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                <% if (u.getProfilePicture() != null && !u.getProfilePicture().trim().isEmpty()) { %>
                                    <img src="<%= u.getProfilePicture() %>" alt="Profile" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-color);">
                                <% } else { %>
                                    <div style="width: 36px; height: 36px; border-radius: 50%; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-color); color: var(--text-secondary); font-size: 0.85rem; font-weight: bold;">
                                        <%= u.getFirstName().substring(0, 1).toUpperCase() %><%= u.getLastName().substring(0, 1).toUpperCase() %>
                                    </div>
                                <% } %>
                                <span><%= u.getFirstName() %> <%= u.getLastName() %></span>
                            </div>
                        </td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() %></td>
                        <td><%= u.getCourse() != null ? u.getCourse() : "—" %></td>
                        <td><%= u.getRole() %></td>
                        <td>
                            <% if (u.isApproved()) { %>
                                <span style="color: #4ade80;">Approved</span>
                            <% } else { %>
                                <span style="color: #fbbf24;">Pending</span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("USER".equals(u.getRole())) { %>
                                <% if (!u.isApproved()) { %>
                                    <form action="../AdminServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                        <button type="submit" class="btn btn-primary" style="padding: 0.35rem 0.85rem; font-size: 0.8rem; margin-right: 0.5rem;">Approve</button>
                                    </form>
                                <% } else { %>
                                    <form action="../AdminServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="pauseUser">
                                        <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                        <button type="submit" class="btn btn-outline" style="padding: 0.35rem 0.85rem; font-size: 0.8rem; border-color: #fbbf24; color: #fbbf24; margin-right: 0.5rem;">Pause Subscription</button>
                                    </form>
                                <% } %>
                                <form action="../AdminServlet" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-outline" style="padding: 0.35rem 0.85rem; font-size: 0.8rem; border-color: #f87171; color: #f87171;">Delete</button>
                                </form>
                            <% } else { %>
                                <span style="color: var(--text-secondary);">—</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </main>
    </div>
</body>
</html>
