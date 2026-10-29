package com.mycompany.milgaya.servlet;

import com.mycompany.milgaya.dao.ClaimDAO;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.model.Claim;
import com.mycompany.milgaya.model.Item;
import com.mycompany.milgaya.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ItemDetailServlet", urlPatterns = {"/item"})
public class ItemDetailServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final ClaimDAO claimDAO = new ClaimDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/items");
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/items");
            return;
        }

        Item item = itemDAO.findById(itemId);
        if (item == null) {
            request.getSession().setAttribute("flashError", "The requested item could not be found.");
            response.sendRedirect(request.getContextPath() + "/items");
            return;
        }

        request.setAttribute("item", item);

        // Check if user is logged in and if they are the owner or admin
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        boolean isOwner = currentUser != null && (currentUser.getId() == item.getUserId() || currentUser.isAdmin());
        request.setAttribute("isOwner", isOwner);

        if (isOwner) {
            List<Claim> claims = claimDAO.findByItemId(item.getId());
            request.setAttribute("claims", claims);
        }

        request.getRequestDispatcher("/item-details.jsp").forward(request, response);
    }
}
