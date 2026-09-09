<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Register for Armora Bike Rentals">
    <title>Register | Armora Bike Rentals</title>
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

    <main style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 2rem 0;">
        <div class="form-container" style="max-width: 600px; margin: 0 auto;">
            <h2>Create an Account</h2>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" required placeholder="e.g. John">
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" required placeholder="e.g. Doe">
                    </div>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="john@example.com">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" required placeholder="Must be unique">
                </div>
                
                <h3 style="margin: 1.5rem 0 1rem; color: var(--text-secondary); font-size: 1.1rem; border-bottom: 1px solid var(--border-color); padding-bottom: 0.5rem;">Academic Data</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="course">Course Enrolled</label>
                        <input type="text" id="course" name="course" required placeholder="e.g. BSc CSIT">
                    </div>
                    <div class="form-group">
                        <label for="level">Level / Year</label>
                        <input type="text" id="level" name="level" required placeholder="e.g. 2nd Year">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 1rem;">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Register Account</button>
            </form>
            <div class="form-text">
                <p>Registration requires admin approval. Already have an account? <a href="login.jsp">Log in</a>.</p>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 Armora Bike Rentals (ABR). All rights reserved.</p>
    </footer>
</body>
</html>
