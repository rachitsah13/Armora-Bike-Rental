package com.armora.controller;

import com.armora.dao.UserDAO;
import com.armora.model.User;
import com.armora.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String identifier = request.getParameter("email"); // Used for both email and phone
        String password = request.getParameter("password");

        String hashedPassword = PasswordUtil.hashPassword(password);
        
        User user = userDAO.authenticateUser(identifier, hashedPassword);

        if (user != null) {
            // Check if user is approved (Admins are always approved)
            if (!user.isApproved() && !"ADMIN".equals(user.getRole())) {
                request.setAttribute("errorMessage", "Your account is pending admin approval.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Authentication successful - create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Role-based Redirect Management
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                response.sendRedirect("user/dashboard.jsp");
            }
        } else {
            // Authentication failed
            request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
