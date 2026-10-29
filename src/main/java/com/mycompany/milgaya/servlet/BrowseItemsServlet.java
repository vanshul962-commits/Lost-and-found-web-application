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

@WebServlet(name = "BrowseItemsServlet", urlPatterns = {"/items"})
public class BrowseItemsServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private static final int PAGE_SIZE = 9;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        String type = request.getParameter("type");
        String categoryParam = request.getParameter("category");
        String city = request.getParameter("city");
        String status = request.getParameter("status");
        String pageParam = request.getParameter("page");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        int offset = (page - 1) * PAGE_SIZE;

        int totalCount = itemDAO.countFilteredItems(query, type, categoryId, city, status);
        List<Item> items = itemDAO.searchItems(query, type, categoryId, city, status, offset, PAGE_SIZE);

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        List<Category> categories = categoryDAO.listAll();
        List<String> cities = itemDAO.listDistinctCities();

        request.setAttribute("items", items);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", categories);
        request.setAttribute("cities", cities);

        // Keep filter selections in scope
        request.setAttribute("selectedQuery", query != null ? query : "");
        request.setAttribute("selectedType", type != null ? type : "ALL");
        request.setAttribute("selectedCategoryId", categoryId != null ? categoryId : 0);
        request.setAttribute("selectedCity", city != null ? city : "ALL");
        request.setAttribute("selectedStatus", status != null ? status : "ALL");

        request.getRequestDispatcher("/items.jsp").forward(request, response);
    }
}
