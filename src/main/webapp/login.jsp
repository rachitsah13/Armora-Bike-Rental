<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Login to Armora Bike Rentals">
    <title>Login | Armora Bike Rentals</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <img src="images/logo.png" alt="Armora Bike Rentals logo">
            <span class="logo-text">Armora <span>Bikes</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="contact.jsp">Contact</a></li>
        </ul>
    </nav>

    <main style="flex: 1; display: flex; align-items: center; justify-content: center;">
        <div class="form-container">
            <h2>Welcome Back</h2>
            
            <%-- Display error message if authentication fails --%>
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="form-group">
                    <label for="email">Email Address / Phone Number</label>
                    <input type="text" id="email" name="email" required placeholder="Enter your email or phone">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Enter your password">
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Log In</button>
            </form>
            <div class="form-text">
                <p>Don't have an account? <a href="register.jsp">Sign up here</a>.</p>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 Armora Bike Rentals (ABR). All rights reserved.</p>
    </footer>
</body>
</html>
