<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Armora Bike Rentals - Premium bike sharing service. Experience the city like never before.">
    <title>Armora Bike Rentals | Premium Bike Sharing</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <img src="images/logo.png" alt="Armora Bike Rentals logo">
            <span class="logo-text">Armora <span>Bikes</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="index.jsp" class="active">Home</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="contact.jsp">Contact</a></li>
        </ul>
        <div class="auth-buttons">
            <a href="login.jsp" class="btn btn-outline">Log In</a>
            <a href="register.jsp" class="btn btn-primary">Sign Up</a>
        </div>
    </nav>

    <main>
        <section class="hero">
            <div class="hero-content">
                <h1>Ride the Future,<br>Today.</h1>
                <p>Experience the city like never before. Premium, well-maintained bikes ready for your next adventure. Join Armora Bike Rentals and move freely.</p>
                <a href="register.jsp" class="btn btn-primary" style="font-size: 1.1rem; padding: 1rem 2rem;">Start Riding Now</a>
            </div>
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1558981403-c5f9899a28bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Premium Mountain Bike in Nature">
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2026 Armora Bike Rentals (ABR). All rights reserved.</p>
    </footer>
</body>
</html>
