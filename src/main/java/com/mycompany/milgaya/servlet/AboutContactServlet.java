package com.mycompany.milgaya.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AboutContactServlet", urlPatterns = {"/about", "/contact"})
public class AboutContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/contact".equals(path)) {
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/about.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Feedback or contact form submit
        request.getSession().setAttribute("flashSuccess", "Thank you for reaching out! Our team will respond to your inquiry shortly.");
        response.sendRedirect(request.getContextPath() + "/contact");
    }
}
