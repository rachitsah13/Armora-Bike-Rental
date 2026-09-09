<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.BikeDAO, com.armora.dao.IssueDAO, com.armora.model.Issue, com.armora.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    BikeDAO bikeDAO = new BikeDAO();
    IssueDAO issueDAO = new IssueDAO();
    Issue activeRental = issueDAO.getActiveIssueByUser(currentUser.getUserId());
    int totalRentals = issueDAO.countIssuesByUser(currentUser.getUserId());
    int activeCount = issueDAO.countActiveIssuesByUser(currentUser.getUserId());
    request.setAttribute("fleetBikes", bikeDAO.getAllBikes());
    request.setAttribute("showAdminActions", Boolean.FALSE);
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Portal | Armora</title>
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
                <li><a href="dashboard.jsp" class="active">My Profile</a></li>
                <li><a href="search.jsp">Search Bikes</a></li>
                <li><a href="my-rentals.jsp">My Rentals</a></li>
                <li><a href="wishlist.jsp">My Wishlist</a></li>
            </ul>
        </aside>
        
        <main class="dashboard-content">
            <h2 style="margin-bottom: 2rem;">My Profile Dashboard</h2>

            <% if ("saved".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Profile updated successfully.</div>
            <% } %>
            
            <div class="card-grid">
                <div class="card">
                    <h3>Active Rentals</h3>
                    <div class="value"><%= activeCount %></div>
                </div>
                <div class="card">
                    <h3>Return Due</h3>
                    <div class="value" style="color: var(--accent-color);"><%= activeRental != null ? activeRental.getDueDate() : "—" %></div>
                </div>
                <div class="card">
                    <h3>Total Issued (All Time)</h3>
                    <div class="value"><%= totalRentals %></div>
                </div>
            </div>

            <jsp:include page="../includes/bike-fleet-grid.jsp" />

            <div style="display: flex; gap: 2rem; margin-top: 3rem; flex-wrap: wrap;">
                <div style="flex: 1; min-width: 280px;">
                    <h3 style="margin-bottom: 1rem;">Personal Information</h3>
                    <div style="background: rgba(30, 41, 59, 0.5); padding: 1.5rem; border-radius: 12px; border: 1px solid var(--border-color);">
                        <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;">
                            <% if (currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().trim().isEmpty()) { %>
                                <img src="<%= currentUser.getProfilePicture() %>" alt="Profile" style="width: 64px; height: 64px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-color);">
                            <% } else { %>
                                <div style="width: 64px; height: 64px; border-radius: 50%; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; border: 2px solid var(--border-color); color: var(--text-secondary); font-size: 1.5rem; font-weight: bold;">
                                    <%= currentUser.getFirstName().substring(0, 1).toUpperCase() %><%= currentUser.getLastName().substring(0, 1).toUpperCase() %>
                                </div>
                            <% } %>
                            <div>
                                <h4 style="margin: 0; font-size: 1.25rem;"><%= currentUser.getFirstName() %> <%= currentUser.getLastName() %></h4>
                                <span style="color: var(--text-secondary); font-size: 0.85rem;"><%= currentUser.getRole() %></span>
                            </div>
                        </div>
                        <p style="margin-bottom: 0.5rem;"><strong>Email:</strong> <%= currentUser.getEmail() %></p>
                        <p style="margin-bottom: 0.5rem;"><strong>Phone:</strong> <%= currentUser.getPhone() %></p>
                        <p style="margin-bottom: 0.5rem;"><strong>Course:</strong> <%= currentUser.getCourse() != null ? currentUser.getCourse() : "—" %></p>
                        <p style="margin-bottom: 1rem;"><strong>Level:</strong> <%= currentUser.getLevel() != null ? currentUser.getLevel() : "—" %></p>
                        <a href="edit-profile.jsp" class="btn btn-outline" style="font-size: 0.9rem; padding: 0.5rem 1rem;">Update Info</a>
                    </div>
                </div>
                
                <div style="flex: 2; min-width: 320px;">
                    <h3 style="margin-bottom: 1rem;">My Current Rental</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Bike Model</th>
                                <th>Genre/Type</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (activeRental == null) { %>
                                <tr><td colspan="5" style="text-align: center; color: var(--text-secondary);">No active rental.</td></tr>
                            <% } else { %>
                            <tr>
                                <td><%= activeRental.getBikeTitle() %></td>
                                <td><%= activeRental.getBikeGenre() != null ? activeRental.getBikeGenre() : "—" %></td>
                                <td><%= activeRental.getIssueDate() %></td>
                                <td><%= activeRental.getDueDate() %></td>
                                <td><span style="color: #fbbf24;">Active</span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <p style="margin-top: 1rem;"><a href="my-rentals.jsp" style="color: var(--primary-color);">View all rentals →</a></p>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
