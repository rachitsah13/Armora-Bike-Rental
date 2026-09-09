<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.dao.BikeDAO, com.armora.dao.WishlistDAO, com.armora.model.Bike, com.armora.model.User, com.armora.util.BikeImageUtil, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    BikeDAO bikeDAO = new BikeDAO();
    WishlistDAO wishlistDAO = new WishlistDAO();
    List<Bike> bikes = bikeDAO.getAllBikes();
    String search = request.getParameter("q");
    if (search != null && !search.trim().isEmpty()) {
        String q = search.trim().toLowerCase();
        bikes.removeIf(b -> !b.getTitle().toLowerCase().contains(q)
                && !b.getAuthor().toLowerCase().contains(q)
                && !b.getGenre().toLowerCase().contains(q));
    }
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Bikes | Armora</title>
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
                <li><a href="search.jsp" class="active">Search Bikes</a></li>
                <li><a href="my-rentals.jsp">My Rentals</a></li>
                <li><a href="wishlist.jsp">My Wishlist</a></li>
            </ul>
        </aside>
        
        <main class="dashboard-content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
                <h2>Premium Fleet &amp; Pricing</h2>
                <form method="get" class="search-bar" style="max-width: 400px; width: 100%; display: flex; gap: 0.5rem;">
                    <input type="text" name="q" value="<%= search != null ? search : "" %>" placeholder="Search by model or brand..." style="padding: 0.75rem; border-radius: 8px; background: var(--surface-color); border: 1px solid var(--border-color); color: white; width: 100%;">
                    <button type="submit" class="btn btn-primary" style="white-space: nowrap;">Search</button>
                </form>
            </div>

            <% if ("added".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Added to wishlist.</div>
            <% } else if ("rented".equals(msg)) { %>
                <div class="alert" style="background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">Bike successfully rented for 24 hours!</div>
            <% } else if ("failed".equals(msg)) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">Could not complete action.</div>
            <% } %>

            <div class="fleet-grid">
                <% if (bikes.isEmpty()) { %>
                    <p class="fleet-empty">No bikes found.</p>
                <% } else {
                    for (Bike bike : bikes) {
                        boolean inWishlist = wishlistDAO.isInWishlist(currentUser.getUserId(), bike.getBikeId());
                %>
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
                        <div style="display: flex; gap: 0.75rem; margin-top: 0.75rem;">
                            <% if ("AVAILABLE".equals(bike.getStatus())) { %>
                                <form action="../UserServlet" method="post" style="flex: 2;">
                                    <input type="hidden" name="action" value="rentBike">
                                    <input type="hidden" name="bikeId" value="<%= bike.getBikeId() %>">
                                    <input type="hidden" name="from" value="search.jsp">
                                    <button type="submit" class="btn btn-primary" style="width: 100%; text-align: center; font-size: 0.85rem;">Rent Now</button>
                                </form>
                            <% } else { %>
                                <span class="btn btn-outline" style="flex: 2; text-align: center; opacity: 0.6; cursor: default; font-size: 0.85rem;">Not Available</span>
                            <% } %>
                            <% if (inWishlist) { %>
                            <form action="../UserServlet" method="post" style="flex: 1;">
                                <input type="hidden" name="action" value="removeWishlist">
                                <input type="hidden" name="bikeId" value="<%= bike.getBikeId() %>">
                                <input type="hidden" name="from" value="search.jsp">
                                <button type="submit" class="btn btn-outline" style="width: 100%;">♥</button>
                            </form>
                            <% } else { %>
                            <form action="../UserServlet" method="post" style="flex: 1;">
                                <input type="hidden" name="action" value="addWishlist">
                                <input type="hidden" name="bikeId" value="<%= bike.getBikeId() %>">
                                <input type="hidden" name="from" value="search.jsp">
                                <button type="submit" class="btn btn-outline" style="width: 100%;">♡</button>
                            </form>
                            <% } %>
                        </div>
                    </div>
                </article>
                <% } } %>
            </div>
        </main>
    </div>
</body>
</html>
