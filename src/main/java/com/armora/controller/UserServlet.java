package com.armora.controller;

import com.armora.dao.UserDAO;
import com.armora.dao.WishlistDAO;
import com.armora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String redirect = "dashboard.jsp";
        String msg = "error";

        if ("addWishlist".equals(action)) {
            redirect = request.getParameter("from") != null ? request.getParameter("from") : "search.jsp";
            int bikeId = Integer.parseInt(request.getParameter("bikeId"));
            msg = wishlistDAO.addToWishlist(user.getUserId(), bikeId) ? "added" : "failed";
        } else if ("removeWishlist".equals(action)) {
            redirect = request.getParameter("from") != null ? request.getParameter("from") : "wishlist.jsp";
            int bikeId = Integer.parseInt(request.getParameter("bikeId"));
            msg = wishlistDAO.removeFromWishlist(user.getUserId(), bikeId) ? "removed" : "failed";
        } else if ("updateProfile".equals(action)) {
            redirect = "dashboard.jsp";
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String course = request.getParameter("course");
            String level = request.getParameter("level");
            
            String profilePictureUrl = user.getProfilePicture(); // keep existing by default
            try {
                Part filePart = request.getPart("profilePicture");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "profiles";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    String uniqueFileName = user.getUserId() + "_" + System.currentTimeMillis() + "_" + fileName;
                    filePart.write(uploadPath + File.separator + uniqueFileName);
                    profilePictureUrl = "../images/profiles/" + uniqueFileName;
                }
            } catch (Exception e) {
                // If it's not a multipart request or fails, we just keep the old profile picture
                e.printStackTrace();
            }

            if (userDAO.updateProfile(user.getUserId(), firstName, lastName, phone, course, level, profilePictureUrl)) {
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setPhone(phone);
                user.setCourse(course);
                user.setLevel(level);
                user.setProfilePicture(profilePictureUrl);
                session.setAttribute("user", user);
                msg = "saved";
            }
        } else if ("rentBike".equals(action)) {
            redirect = request.getParameter("from") != null ? request.getParameter("from") : "search.jsp";
            int bikeId = Integer.parseInt(request.getParameter("bikeId"));
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
            java.sql.Date dueDate = new java.sql.Date(cal.getTimeInMillis());
            
            com.armora.dao.IssueDAO issueDAO = new com.armora.dao.IssueDAO();
            msg = issueDAO.issueBike(user.getUserId(), bikeId, dueDate) ? "rented" : "failed";
        }

        if (!redirect.startsWith("user/")) {
            redirect = "user/" + redirect;
        }
        response.sendRedirect(request.getContextPath() + "/" + redirect + "?msg=" + msg);
    }
}
