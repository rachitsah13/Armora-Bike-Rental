package com.armora.controller;

import com.armora.dao.BikeDAO;
import com.armora.dao.IssueDAO;
import com.armora.dao.UserDAO;
import com.armora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private BikeDAO bikeDAO;
    private IssueDAO issueDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        bikeDAO = new BikeDAO();
        issueDAO = new IssueDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request.getSession(false))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
            return;
        }

        String action = request.getParameter("action");
        String redirect = "dashboard.jsp";
        String msg = "error";

        if ("approve".equals(action)) {
            redirect = "manage-users.jsp";
            int userId = Integer.parseInt(request.getParameter("userId"));
            msg = userDAO.approveUser(userId) ? "approved" : "failed";
        } else if ("pauseUser".equals(action)) {
            redirect = "manage-users.jsp";
            int userId = Integer.parseInt(request.getParameter("userId"));
            msg = userDAO.pauseUser(userId) ? "paused" : "failed";
        } else if ("deleteUser".equals(action)) {
            redirect = "manage-users.jsp";
            int userId = Integer.parseInt(request.getParameter("userId"));
            msg = userDAO.deleteUser(userId) ? "deleted" : "failed";
        } else if ("addBike".equals(action)) {
            redirect = "manage-bikes.jsp";
            String title = request.getParameter("title");
            String isbn = request.getParameter("isbn");
            String genre = request.getParameter("genre");
            String author = request.getParameter("author");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            msg = bikeDAO.addBike(title, isbn, genre, author, price) ? "bikeAdded" : "failed";
        } else if ("updateBikeStatus".equals(action)) {
            redirect = "manage-bikes.jsp";
            int bikeId = Integer.parseInt(request.getParameter("bikeId"));
            String status = request.getParameter("status");
            msg = bikeDAO.updateStatus(bikeId, status) ? "statusUpdated" : "failed";
        } else if ("issueBike".equals(action)) {
            redirect = "issue-bike.jsp";
            int userId = Integer.parseInt(request.getParameter("userId"));
            int bikeId = Integer.parseInt(request.getParameter("bikeId"));
            Date dueDate = Date.valueOf(request.getParameter("dueDate"));
            msg = issueDAO.issueBike(userId, bikeId, dueDate) ? "issued" : "failed";
        } else if ("returnBike".equals(action)) {
            String from = request.getParameter("from");
            redirect = (from != null && !from.isEmpty()) ? from : "dashboard.jsp";
            int issueId = Integer.parseInt(request.getParameter("issueId"));
            msg = issueDAO.returnBike(issueId) ? "returned" : "failed";
        }

        redirectToAdminPage(request, response, redirect, msg);
    }

    private void redirectToAdminPage(HttpServletRequest request, HttpServletResponse response,
                                   String page, String msg) throws IOException {
        String target = page.startsWith("admin/") ? page : "admin/" + page;
        response.sendRedirect(request.getContextPath() + "/" + target + "?msg=" + msg);
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
