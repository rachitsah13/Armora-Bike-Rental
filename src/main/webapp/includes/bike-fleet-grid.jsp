<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.armora.model.Bike, com.armora.util.BikeImageUtil, java.util.List" %>
<%
    @SuppressWarnings("unchecked")
    List<Bike> fleetBikes = (List<Bike>) request.getAttribute("fleetBikes");
    if (fleetBikes == null) {
        fleetBikes = java.util.Collections.emptyList();
    }
    boolean showAdminActions = Boolean.TRUE.equals(request.getAttribute("showAdminActions"));
%>
<section class="fleet-section">
    <div class="fleet-section-header">
        <h3>Fleet Price List</h3>
        <p>Premium superbikes — hourly rental rates</p>
    </div>
    <div class="fleet-grid">
        <% if (fleetBikes.isEmpty()) { %>
            <p class="fleet-empty">No bikes in the fleet yet. Run database/update-bikes-images.sql in MySQL.</p>
        <% } else {
            for (Bike bike : fleetBikes) { %>
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
                <% if (showAdminActions) { %>
                    <a href="manage-bikes.jsp" class="btn btn-outline" style="width: 100%; text-align: center; font-size: 0.85rem; margin-top: 0.75rem;">Manage in Admin</a>
                <% } else { %>
                    <a href="search.jsp" class="btn btn-primary" style="width: 100%; text-align: center; font-size: 0.85rem; margin-top: 0.75rem;">View &amp; Wishlist</a>
                <% } %>
            </div>
        </article>
        <% } } %>
    </div>
</section>
