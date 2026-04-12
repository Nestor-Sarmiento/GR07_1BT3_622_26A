package repositories;

import Enums.Rol;
import schemas.Admin;
import schemas.Usuario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.List;
import java.util.Optional;

public class AdminRepository {

    public boolean existsByEmail(String email) {
        try (EntityManager em = JpaUtil.createEntityManager()) {
            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM Usuario u WHERE u.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return count != null && count > 0;
        }
    }

    public Optional<Admin> findByEmail(String email) {
        try (EntityManager em = JpaUtil.createEntityManager()) {
            List<Usuario> result = em.createQuery(
                    "SELECT u FROM Usuario u WHERE u.email = :email AND u.rol = :rol", Usuario.class)
                    .setParameter("email", email)
                    .setParameter("rol", Rol.ADMIN)
                    .setMaxResults(1)
                    .getResultList();
            if (result.isEmpty()) {
                return Optional.empty();
            }
            return Optional.of((Admin) result.get(0));
        }
    }

    public Admin save(Admin admin) {
        try (EntityManager em = JpaUtil.createEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                Admin managed = em.merge(admin);
                tx.commit();
                return managed;
            } catch (RuntimeException ex) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                throw ex;
            }
        }
    }
}
