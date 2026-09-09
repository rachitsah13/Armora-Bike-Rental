package com.armora.controller;

import com.armora.dao.UserDAO;
import com.armora.model.User;
import com.armora.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String course = request.getParameter("course");
        String level = request.getParameter("level");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic Validation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (phone != null && !phone.matches("\\d+")) {
            request.setAttribute("errorMessage", "Phone number must contain only numerical digits.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Hash the password securely
        String hashedPassword = PasswordUtil.hashPassword(password);

        User newUser = new User(firstName, lastName, email, phone, hashedPassword, "USER", course, level);

        try {
            boolean isRegistered = userDAO.registerUser(newUser);
            if (isRegistered) {
                // Success - Redirect to login with success message
                request.setAttribute("errorMessage", "Registration successful. Please wait for admin approval before logging in.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Email or Phone number already exists.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An internal server error occurred. Please try again later.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
