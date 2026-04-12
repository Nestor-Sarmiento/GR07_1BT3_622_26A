package web;

import Enums.Estados;
import repositories.AdminRepository;
import repositories.JpaUtil;
import schemas.Admin;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        seedInitialAdmin();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JpaUtil.shutdown();
    }

    private void seedInitialAdmin() {
        String email = JpaUtil.getConfigValue("ADMIN_EMAIL", "admin@olwshare.com");
        String password = JpaUtil.getConfigValue("ADMIN_PASSWORD", "OlwShare2026!");
        String nombre = JpaUtil.getConfigValue("ADMIN_NOMBRE", "Administrador");
        String apellido = JpaUtil.getConfigValue("ADMIN_APELLIDO", "Sistema");

        AdminRepository adminRepository = new AdminRepository();
        if (adminRepository.existsByEmail(email)) {
            return;
        }

        Admin admin = new Admin(null, email, nombre, apellido, password, Estados.ACTIVO);
        admin.setMustChangePassword(false);
        adminRepository.save(admin);
    }
}

