package web;

import repositories.AdminRepository;
import repositories.JpaUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        seedInitialAdmin(sce);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JpaUtil.shutdown();
    }

    private void seedInitialAdmin(ServletContextEvent sce) {
        String email = JpaUtil.getConfigValue("ADMIN_EMAIL");
        String password = JpaUtil.getConfigValue("ADMIN_PASSWORD");
        String nombre = JpaUtil.getConfigValue("ADMIN_NOMBRE");
        String apellido = JpaUtil.getConfigValue("ADMIN_APELLIDO");

        if (email.isBlank() || password.isBlank() || nombre.isBlank() || apellido.isBlank()) {
            return;
        }

        try {
            AdminRepository adminRepository = new AdminRepository();
            adminRepository.upsertInitialAdmin(email, password, nombre, apellido);
            sce.getServletContext().log("Admin inicial sincronizado para: " + email);
        } catch (RuntimeException ex) {
            sce.getServletContext().log("No se pudo sincronizar el admin inicial. La app sigue activa, pero sin conexión DB.", ex);
        }
    }
}

