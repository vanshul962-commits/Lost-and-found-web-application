package com.mycompany.milgaya.servlet;

import com.mycompany.milgaya.config.DBConnection;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.dao.UserDAO;
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
import java.util.Map;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getContextPath() + "/admin");
            return;
        }

        if (!currentUser.isAdmin()) {
            session.setAttribute("flashError", "Access denied. Administrator privileges required.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Map<String, Integer> stats = itemDAO.getStats();
        int totalUsers = userDAO.countUsers();
        stats.put("totalUsers", totalUsers);
        request.setAttribute("stats", stats);

        List<Item> allItems = itemDAO.listAll();
        request.setAttribute("items", allItems);

        List<User> allUsers = userDAO.listAll();
        request.setAttribute("users", allUsers);

        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("deleteUser".equals(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null) {
                int uid = Integer.parseInt(userIdParam.trim());
                if (uid != currentUser.getId()) { // Do not delete own admin account
                    userDAO.deleteUser(uid);
                    session.setAttribute("flashSuccess", "User deleted successfully.");
                } else {
                    session.setAttribute("flashError", "You cannot delete your own admin account.");
                }
            }
        } else if ("resetDemoData".equals(action)) {
            // Re-run initialization and seeding
            DBConnection.initDatabase();
            session.setAttribute("flashSuccess", "Database re-initialized and verified successfully.");
        }

        response.sendRedirect(request.getContextPath() + "/admin");
    }
}
