<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | Armora</title>
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
                <li><a href="my-rentals.jsp">My Rentals</a></li>
                <li><a href="wishlist.jsp">My Wishlist</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 1.5rem;">Update Profile</h2>

            <div class="form-container" style="max-width: 500px;">
                <form action="../UserServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" value="<%= currentUser.getFirstName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" value="<%= currentUser.getLastName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" id="phone" name="phone" value="<%= currentUser.getPhone() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="course">Course</label>
                        <input type="text" id="course" name="course" value="<%= currentUser.getCourse() != null ? currentUser.getCourse() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="level">Level</label>
                        <input type="text" id="level" name="level" value="<%= currentUser.getLevel() != null ? currentUser.getLevel() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="profilePicture">Upload New Profile Picture</label>
                        <input type="file" id="profilePicture" name="profilePicture" accept="image/*">
                        <% if (currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().trim().isEmpty()) { %>
                            <p style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 0.5rem;">Current picture is set. Uploading a new one will replace it.</p>
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Save Changes</button>
                    <a href="dashboard.jsp" class="btn btn-outline" style="width: 100%; text-align: center; margin-top: 0.75rem;">Cancel</a>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
