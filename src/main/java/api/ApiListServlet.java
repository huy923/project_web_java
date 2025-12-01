package api;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@WebServlet(urlPatterns = {"/api", "/api/"})
public class ApiListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonArray endpoints = new JsonArray();

        ServletContext context = getServletContext();
        for (ServletRegistration registration : context.getServletRegistrations().values()) {
            for (String mapping : registration.getMappings()) {
                endpoints.add(mapping);
            }
        }

        JsonObject response = new JsonObject();
        response.addProperty("message", "Registered servlets in context");
        response.add("endpoints", endpoints);

        resp.getWriter().print(new Gson().toJson(response));
    }
}