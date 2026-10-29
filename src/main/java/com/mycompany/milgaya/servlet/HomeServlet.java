package com.mycompany.milgaya.servlet;

import com.mycompany.milgaya.dao.CategoryDAO;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.model.Category;
import com.mycompany.milgaya.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch statistics for counters
        Map<String, Integer> stats = itemDAO.getStats();
        request.setAttribute("stats", stats);

        // Fetch recent lost items (limit 6)
        List<Item> recentLost = itemDAO.findRecentLost(6);
        request.setAttribute("recentLost", recentLost);

        // Fetch recent found items (limit 6)
        List<Item> recentFound = itemDAO.findRecentFound(6);
        request.setAttribute("recentFound", recentFound);

        // Fetch categories with counts
        List<Category> categories = categoryDAO.listAll();
        request.setAttribute("categories", categories);

        // Fetch distinct cities for search dropdown
        List<String> cities = itemDAO.listDistinctCities();
        request.setAttribute("cities", cities);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
