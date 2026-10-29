package com.mycompany.milgaya.servlet;

import com.google.gson.Gson;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ApiServlet", urlPatterns = {"/api/items", "/api/stats"})
public class ApiServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String path = request.getServletPath();

        if ("/api/stats".equals(path)) {
            Map<String, Integer> stats = itemDAO.getStats();
            response.getWriter().write(gson.toJson(stats));
            return;
        }

        String q = request.getParameter("q");
        String type = request.getParameter("type");
        String city = request.getParameter("city");

        List<Item> items = itemDAO.searchItems(q, type, null, city, "OPEN", 0, 10);
        response.getWriter().write(gson.toJson(items));
    }
}
