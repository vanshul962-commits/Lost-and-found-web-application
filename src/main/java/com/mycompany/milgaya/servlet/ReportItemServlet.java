package com.mycompany.milgaya.servlet;

import com.mycompany.milgaya.dao.CategoryDAO;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.model.Category;
import com.mycompany.milgaya.model.Item;
import com.mycompany.milgaya.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "ReportItemServlet", urlPatterns = {"/report-lost", "/report-found"})
public class ReportItemServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String servletPath = request.getServletPath();
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getContextPath() + servletPath);
            return;
        }

        List<Category> categories = categoryDAO.listAll();
        request.setAttribute("categories", categories);

        if ("/report-found".equals(servletPath)) {
            request.getRequestDispatcher("/report-found.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/report-lost.jsp").forward(request, response);
        }
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

        String servletPath = request.getServletPath();
        String type = "/report-found".equals(servletPath) ? "FOUND" : "LOST";

        String title = request.getParameter("title");
        String categoryParam = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String city = request.getParameter("city");
        String dateParam = request.getParameter("dateEvent");
        String rewardParam = request.getParameter("rewardAmount");
        String securityQuestion = request.getParameter("securityQuestion");
        String imageUrl = request.getParameter("imageUrl");
        String contactPhone = request.getParameter("contactPhone");
        String contactEmail = request.getParameter("contactEmail");
        String contactVisibleParam = request.getParameter("contactVisible");

        if (title == null || title.trim().isEmpty() ||
            categoryParam == null || categoryParam.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            location == null || location.trim().isEmpty() ||
            city == null || city.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please fill in all required fields.");
            request.setAttribute("categories", categoryDAO.listAll());
            if ("FOUND".equals(type)) {
                request.getRequestDispatcher("/report-found.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/report-lost.jsp").forward(request, response);
            }
            return;
        }

        Item item = new Item();
        item.setType(type);
        item.setTitle(title.trim());
        try {
            item.setCategoryId(Integer.parseInt(categoryParam.trim()));
        } catch (NumberFormatException e) {
            item.setCategoryId(1);
        }
        item.setDescription(description.trim());
        item.setLocation(location.trim());
        item.setCity(city.trim());

        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                item.setDateEvent(Date.valueOf(dateParam.trim()));
            } catch (Exception e) {
                item.setDateEvent(new Date(System.currentTimeMillis()));
            }
        } else {
            item.setDateEvent(new Date(System.currentTimeMillis()));
        }

        BigDecimal reward = BigDecimal.ZERO;
        if (rewardParam != null && !rewardParam.trim().isEmpty()) {
            try {
                reward = new BigDecimal(rewardParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        item.setRewardAmount(reward);

        item.setSecurityQuestion(securityQuestion != null ? securityQuestion.trim() : null);

        // Fallback or default image if user didn't enter one
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = getDefaultImageForCategory(item.getCategoryId(), type);
        }
        item.setImageUrl(imageUrl.trim());

        item.setStatus("OPEN");
        item.setUserId(currentUser.getId());
        item.setContactPhone((contactPhone != null && !contactPhone.trim().isEmpty()) ? contactPhone.trim() : currentUser.getPhone());
        item.setContactEmail((contactEmail != null && !contactEmail.trim().isEmpty()) ? contactEmail.trim() : currentUser.getEmail());
        item.setContactVisible("true".equalsIgnoreCase(contactVisibleParam) || "on".equalsIgnoreCase(contactVisibleParam));

        boolean created = itemDAO.create(item);
        if (created) {
            session.setAttribute("flashSuccess", "Your " + type.toLowerCase() + " item report has been published successfully!");
            response.sendRedirect(request.getContextPath() + "/item?id=" + item.getId());
        } else {
            request.setAttribute("errorMessage", "Failed to save item report. Please check the details and try again.");
            request.setAttribute("categories", categoryDAO.listAll());
            if ("FOUND".equals(type)) {
                request.getRequestDispatcher("/report-found.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/report-lost.jsp").forward(request, response);
            }
        }
    }

    private String getDefaultImageForCategory(int categoryId, String type) {
        switch (categoryId) {
            case 1: // Electronics
                return "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&auto=format&fit=crop&q=80";
            case 2: // Wallets & Bags
                return "https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80";
            case 3: // Documents & ID
                return "https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80";
            case 4: // Keys
                return "https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop&q=80";
            case 5: // Pets
                return "https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=600&auto=format&fit=crop&q=80";
            case 6: // Jewelry & Watches
                return "https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80";
            case 7: // Clothing
                return "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80";
            case 8: // Books
                return "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80";
            default:
                return "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80";
        }
    }
}
