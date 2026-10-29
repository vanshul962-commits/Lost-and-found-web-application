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

@WebServlet(name = "ClaimServlet", urlPatterns = {"/claim"})
public class ClaimServlet extends HttpServlet {

    private final ClaimDAO claimDAO = new ClaimDAO();
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

        // Action: Submit a new claim or ownership proof
        if (action == null || "submit".equals(action)) {
            String itemIdParam = request.getParameter("itemId");
            String message = request.getParameter("claimMessage");
            String proof = request.getParameter("claimProof");
            String contact = request.getParameter("claimantContact");

            if (itemIdParam == null || message == null || message.trim().isEmpty()) {
                session.setAttribute("flashError", "Claim description cannot be empty.");
                response.sendRedirect(request.getContextPath() + "/items");
                return;
            }

            int itemId = Integer.parseInt(itemIdParam.trim());
            Item item = itemDAO.findById(itemId);
            if (item == null) {
                session.setAttribute("flashError", "Item not found.");
                response.sendRedirect(request.getContextPath() + "/items");
                return;
            }

            // Cannot claim own item
            if (item.getUserId() == currentUser.getId()) {
                session.setAttribute("flashError", "You cannot submit a claim on an item you reported.");
                response.sendRedirect(request.getContextPath() + "/item?id=" + itemId);
                return;
            }

            Claim claim = new Claim();
            claim.setItemId(itemId);
            claim.setClaimantId(currentUser.getId());
            claim.setClaimMessage(message.trim());
            claim.setClaimProof(proof != null ? proof.trim() : "");
            claim.setClaimantContact((contact != null && !contact.trim().isEmpty()) ? contact.trim() : currentUser.getPhone());
            claim.setStatus("PENDING");

            boolean success = claimDAO.create(claim);
            if (success) {
                session.setAttribute("flashSuccess", "Your claim and proof of ownership have been submitted to the reporter.");
            } else {
                session.setAttribute("flashError", "Failed to submit claim. Please try again.");
            }

            response.sendRedirect(request.getContextPath() + "/item?id=" + itemId);
            return;
        }

        // Action: Accept or Reject claim (by Item Owner)
        if ("accept".equals(action) || "reject".equals(action)) {
            String claimIdParam = request.getParameter("claimId");
            String ownerReply = request.getParameter("ownerReply");

            if (claimIdParam != null && !claimIdParam.trim().isEmpty()) {
                int claimId = Integer.parseInt(claimIdParam.trim());
                Claim claim = claimDAO.findById(claimId);
                if (claim != null) {
                    Item item = itemDAO.findById(claim.getItemId());
                    if (item != null && (item.getUserId() == currentUser.getId() || currentUser.isAdmin())) {
                        String newStatus = "accept".equals(action) ? "ACCEPTED" : "REJECTED";
                        claimDAO.updateStatus(claimId, newStatus, ownerReply);

                        if ("ACCEPTED".equals(newStatus)) {
                            // Automatically mark item as CLAIMED/RESOLVED
                            itemDAO.updateStatus(item.getId(), "RESOLVED");
                            session.setAttribute("flashSuccess", "Claim accepted! The item has been marked as Resolved / Reunited.");
                        } else {
                            session.setAttribute("flashInfo", "Claim rejected.");
                        }

                        response.sendRedirect(request.getContextPath() + "/dashboard");
                        return;
                    }
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
