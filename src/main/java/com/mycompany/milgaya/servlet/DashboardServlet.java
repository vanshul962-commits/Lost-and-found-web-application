package com.mycompany.milgaya.servlet;

import com.mycompany.milgaya.dao.ClaimDAO;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.dao.UserDAO;
import com.mycompany.milgaya.model.Claim;
import com.mycompany.milgaya.model.Item;
import com.mycompany.milgaya.model.User;
import com.mycompany.milgaya.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard", "/profile"})
public class DashboardServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final ClaimDAO claimDAO = new ClaimDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getContextPath() + "/dashboard");
            return;
        }

        // Refresh user from database to ensure up-to-date data
        User freshUser = userDAO.findById(currentUser.getId());
        if (freshUser != null) {
            session.setAttribute("currentUser", freshUser);
            currentUser = freshUser;
        }

        List<Item> myItems = itemDAO.findByUserId(currentUser.getId());
        List<Item> myLostItems = new ArrayList<>();
        List<Item> myFoundItems = new ArrayList<>();

        for (Item item : myItems) {
            if ("LOST".equalsIgnoreCase(item.getType())) {
                myLostItems.add(item);
            } else {
                myFoundItems.add(item);
            }
        }

        List<Claim> claimsReceived = claimDAO.findByItemOwnerId(currentUser.getId());
        List<Claim> mySubmittedClaims = claimDAO.findByClaimantId(currentUser.getId());

        request.setAttribute("myLostItems", myLostItems);
        request.setAttribute("myFoundItems", myFoundItems);
        request.setAttribute("claimsReceived", claimsReceived);
        request.setAttribute("mySubmittedClaims", mySubmittedClaims);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

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

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String city = request.getParameter("city");

            currentUser.setFullName(fullName != null ? fullName.trim() : currentUser.getFullName());
            currentUser.setPhone(phone != null ? phone.trim() : currentUser.getPhone());
            currentUser.setCity(city != null ? city.trim() : currentUser.getCity());

            boolean ok = userDAO.updateProfile(currentUser);
            if (ok) {
                session.setAttribute("flashSuccess", "Profile updated successfully.");
            } else {
                session.setAttribute("flashError", "Failed to update profile.");
            }
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!PasswordUtil.verifyPassword(currentPassword, currentUser.getPasswordHash())) {
                session.setAttribute("flashError", "Current password does not match our records.");
            } else if (newPassword == null || newPassword.length() < 6) {
                session.setAttribute("flashError", "New password must be at least 6 characters long.");
            } else if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("flashError", "New passwords do not match.");
            } else {
                boolean ok = userDAO.updatePassword(currentUser.getId(), PasswordUtil.hashPassword(newPassword));
                if (ok) {
                    session.setAttribute("flashSuccess", "Password updated successfully!");
                } else {
                    session.setAttribute("flashError", "Failed to update password.");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
