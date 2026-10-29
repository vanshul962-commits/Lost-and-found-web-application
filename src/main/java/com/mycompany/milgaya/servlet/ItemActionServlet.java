package com.mycompany.milgaya.servlet;

import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.model.Item;
import com.mycompany.milgaya.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ItemActionServlet", urlPatterns = {"/item-action"})
public class ItemActionServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Item item = itemDAO.findById(itemId);
        if (item == null) {
            session.setAttribute("flashError", "Item not found.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Must be owner or admin
        if (item.getUserId() != currentUser.getId() && !currentUser.isAdmin()) {
            session.setAttribute("flashError", "You are not authorized to perform actions on this item.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        if ("resolve".equals(action)) {
            itemDAO.updateStatus(itemId, "RESOLVED");
            session.setAttribute("flashSuccess", "Item has been successfully marked as Resolved / Reunited!");
        } else if ("reopen".equals(action)) {
            itemDAO.updateStatus(itemId, "OPEN");
            session.setAttribute("flashInfo", "Item listing has been reopened.");
        } else if ("delete".equals(action)) {
            itemDAO.delete(itemId);
            session.setAttribute("flashSuccess", "Item listing has been deleted.");
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/admin")) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else if (referer != null && referer.contains("/item?id=")) {
            response.sendRedirect(request.getContextPath() + "/item?id=" + itemId);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}
