package servlets;

import jakarta.servlet.http.HttpSession;

public class ServletUtils {

    public static String value(String input) {
        return input == null ? "" : input.trim();
    }

    public static void flash(HttpSession session, String key, String value) {
        session.setAttribute(key, value);
    }
}
