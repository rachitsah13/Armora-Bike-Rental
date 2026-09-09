<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contact Us | Armora Bike Rentals</title>
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
                <li><a href="contact.jsp" class="active">Contact</a></li>
            </ul>
            <div class="auth-buttons">
                <a href="login.jsp" class="btn btn-outline">Log In</a>
                <a href="register.jsp" class="btn btn-primary">Sign Up</a>
            </div>
        </nav>

        <main style="flex: 1; padding: 5rem 5%;">
            <div class="feedback-grid">
                <div class="feedback-info">
                    <h1>We value your <br><span>Experience.</span></h1>
                    <p style="font-size: 1.25rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 2rem;">
                        Your feedback helps us steer Armora Bikes in the right direction.
                        Whether it's a high-five or a suggestion for improvement, we're all ears.
                    </p>

                    <div style="display: flex; gap: 3rem; margin-top: 4rem;">
                        <div>
                            <h4 style="color: var(--primary-color); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 0.5rem;">Email Us</h4>
                            <p style="font-size: 1.1rem; font-weight: 600;">speedyhero6@gmail.com</p>
                        </div>
                        <div>
                            <h4 style="color: var(--secondary-color); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 0.5rem;">Call Us</h4>
                            <p style="font-size: 1.1rem; font-weight: 600;">+977 9820742290</p>
                        </div>
                    </div>
                </div>

                <div class="feedback-card">
                    <h2 style="text-align: left; margin-bottom: 2rem; font-size: 1.75rem; font-weight: 800;">Send Feedback</h2>
                    <form action="https://formspree.io/f/mvzleqkl" method="POST" id="feedbackForm">
                        <div class="type-pills">
                            <div class="type-pill active" onclick="setType(this, 'suggestion')">Suggestion</div>
                            <div class="type-pill" onclick="setType(this, 'issue')">Issue</div>
                            <div class="type-pill" onclick="setType(this, 'praise')">Praise</div>
                            <input type="hidden" name="feedbackType" id="feedbackType" value="suggestion">
                        </div>

                        <div class="rating-container">
                            <span class="rating-item" onclick="setRating(1)" title="Poor">😠</span>
                            <span class="rating-item" onclick="setRating(2)" title="Fair">🙁</span>
                            <span class="rating-item active" onclick="setRating(3)" title="Good">😐</span>
                            <span class="rating-item" onclick="setRating(4)" title="Very Good">😊</span>
                            <span class="rating-item" onclick="setRating(5)" title="Excellent">🤩</span>
                            <input type="hidden" name="rating" id="ratingValue" value="3">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                            <div class="form-group">
                                <input type="text" id="name" name="name" required placeholder=" ">
                                <label for="name">Full Name</label>
                            </div>
                            <div class="form-group">
                                <input type="email" id="email" name="_replyto" required placeholder=" ">
                                <label for="email">Email Address</label>
                            </div>
                        </div>

                        <div class="form-group">
                            <textarea id="message" name="message" rows="4" required placeholder=" "></textarea>
                            <label for="message">What's on your mind?</label>
                        </div>

                        <div class="experience-toggle">
                            <span style="font-size: 0.95rem; color: var(--text-primary); font-weight: 500;">Exceeded your expectations?</span>
                            <label class="switch">
                                <input type="checkbox" name="exceeded_expectations" value="Yes">
                                <span class="slider"></span>
                            </label>
                        </div>

                        <input type="hidden" name="_subject" value="New Feedback from Armora Bikes!">

                        <button type="submit" class="btn btn-primary"
                            style="width: 100%; margin-top: 1rem; padding: 1.25rem; font-size: 1.1rem; letter-spacing: 1px; text-transform: uppercase;">
                            Submit Feedback
                        </button>
                    </form>
                </div>
            </div>
        </main>

        <script>
            function setRating(val) {
                const items = document.querySelectorAll('.rating-item');
                items.forEach(item => item.classList.remove('active'));
                items[val - 1].classList.add('active');
                document.getElementById('ratingValue').value = val;
            }

            function setType(element, type) {
                document.querySelectorAll('.type-pill').forEach(pill => pill.classList.remove('active'));
                element.classList.add('active');
                document.getElementById('feedbackType').value = type;
            }
        </script>

        <footer>
            <p>&copy; 2026 Armora Bike Rentals (ABR). All rights reserved.</p>
        </footer>
    </body>

    </html>