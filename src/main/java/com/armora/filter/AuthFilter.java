package com.armora.filter;

import com.armora.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
            
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String loginURI = httpRequest.getContextPath() + "/login.jsp";
        
        boolean loggedIn = session != null && session.getAttribute("user") != null;
        
        if (loggedIn) {
            User user = (User) session.getAttribute("user");
            String uri = httpRequest.getRequestURI();
            
            // Role-based Access Control
            if (uri.contains("/admin/") && !"ADMIN".equals(user.getRole())) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access. Admin role required.");
                return;
            }
            if (uri.contains("/user/") && !"USER".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
                httpResponse.sendRedirect(loginURI);
                return;
            }
            
            // Allow the request to proceed
            chain.doFilter(request, response);
        } else {
            // Unauthenticated users are redirected to login
            httpResponse.sendRedirect(loginURI);
        }
    }

    public void destroy() {}
}
