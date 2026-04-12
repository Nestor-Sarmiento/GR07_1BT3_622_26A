package repositories;

import Enums.Estados;
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
                    "SELECT COUNT(u) FROM Usuario u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email))", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return count != null && count > 0;
        }
    }

    public Optional<Usuario> findByEmail(String email) {
        try (EntityManager em = JpaUtil.createEntityManager()) {
            List<Usuario> result = em.createQuery(
                    "SELECT u FROM Usuario u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email)) AND u.rol = :rol", Usuario.class)
                    .setParameter("email", email)
                    .setParameter("rol", Rol.ADMIN)
                    .setMaxResults(1)
                    .getResultList();
            if (result.isEmpty()) {
                return Optional.empty();
            }
            return Optional.of(result.get(0));
        }
    }

    public void upsertInitialAdmin(String email, String password, String nombre, String apellido) {
        try (EntityManager em = JpaUtil.createEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();

                List<Usuario> existing = em.createQuery(
                        "SELECT u FROM Usuario u WHERE u.email = :email", Usuario.class)
                        .setParameter("email", email)
                        .setMaxResults(1)
                        .getResultList();

                if (existing.isEmpty()) {
                    Admin admin = new Admin(null, email, nombre, apellido, password, Estados.ACTIVO);
                    admin.setMustChangePassword(false);
                    em.persist(admin);
                } else {
                    Usuario usuario = existing.get(0);
                    usuario.setRol(Rol.ADMIN);
                    usuario.setPassword(password);
                    usuario.setNombre(nombre);
                    usuario.setApellido(apellido);
                    usuario.setEstado(Estados.ACTIVO);
                    usuario.setMustChangePassword(false);
                    em.merge(usuario);
                }

                tx.commit();
            } catch (RuntimeException ex) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                throw ex;
            }
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
