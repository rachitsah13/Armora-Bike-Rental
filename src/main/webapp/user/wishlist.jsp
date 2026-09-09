<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.WishlistDAO, com.armora.model.Bike, com.armora.model.User, com.armora.util.BikeImageUtil, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    WishlistDAO wishlistDAO = new WishlistDAO();
    List<Bike> wishlist = wishlistDAO.getWishlistByUser(currentUser.getUserId());
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | Armora</title>
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
                <li><a href="wishlist.jsp" class="active">My Wishlist</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <h2 style="margin-bottom: 1.5rem;">My Wishlist</h2>

            <% if ("added".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Added to wishlist.</div>
            <% } else if ("removed".equals(msg)) { %>
                <div class="alert" style="background: rgba(56, 189, 248, 0.15); border: 1px solid var(--primary-color); color: var(--primary-color); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Removed from wishlist.</div>
            <% } %>

            <% if (wishlist.isEmpty()) { %>
                <p style="color: var(--text-secondary);">Your wishlist is empty. <a href="search.jsp" style="color: var(--primary-color);">Browse bikes</a> and tap ♥ to save favourites.</p>
            <% } else { %>
            <div class="fleet-grid">
                <% for (Bike bike : wishlist) { %>
                <article class="bike-card">
                    <div class="bike-card-image" style="background-image: url('<%= BikeImageUtil.getImageUrl(bike) %>');"></div>
                    <div class="bike-card-body">
                        <div class="bike-card-top">
                            <div>
                                <h4><%= bike.getTitle() %></h4>
                                <span class="bike-tag"><%= bike.getGenre() %></span>
                            </div>
                            <div class="bike-price">
                                <strong><%= BikeImageUtil.formatPricePerHour(bike.getPricePerHour()) %></strong>
                                <span>per hour</span>
                            </div>
                        </div>
                        <p class="bike-meta"><%= bike.getAuthor() %> · <span class="status-<%= bike.getStatus().toLowerCase() %>"><%= bike.getStatus() %></span></p>
                        <form action="../UserServlet" method="post" style="margin-top: 0.75rem;">
                            <input type="hidden" name="action" value="removeWishlist">
                            <input type="hidden" name="bikeId" value="<%= bike.getBikeId() %>">
                            <input type="hidden" name="from" value="wishlist.jsp">
                            <button type="submit" class="btn btn-outline" style="width: 100%; font-size: 0.9rem;">Remove from Wishlist</button>
                        </form>
                    </div>
                </article>
                <% } %>
            </div>
            <% } %>
        </main>
    </div>
</body>
</html>
