package repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public final class JpaUtil {
    private static final EntityManagerFactory EMF = Persistence.createEntityManagerFactory("pdciaePU");

    private JpaUtil() {
    }

    public static EntityManager createEntityManager() {
        return EMF.createEntityManager();
    }

    public static void shutdown() {
        if (EMF.isOpen()) {
            EMF.close();
        }
    }
}

