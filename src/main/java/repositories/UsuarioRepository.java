package repositories;

import schemas.Usuario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.List;
import java.util.Optional;

public class UsuarioRepository {

	public List<Usuario> findAll() {
		EntityManager em = JpaUtil.createEntityManager();
		try {
			return em.createQuery("SELECT u FROM Usuario u ORDER BY u.id_usuario DESC", Usuario.class)
					.getResultList();
		} finally {
			em.close();
		}
	}

	public Optional<Usuario> findById(Long id) {
		EntityManager em = JpaUtil.createEntityManager();
		try {
			Usuario usuario = em.find(Usuario.class, id);
			return Optional.ofNullable(usuario);
		} finally {
			em.close();
		}
	}

	public boolean existsByEmail(String email, Long excludeId) {
		EntityManager em = JpaUtil.createEntityManager();
		try {
			Long count = em.createQuery(
					"SELECT COUNT(u) FROM Usuario u WHERE u.email = :email AND (:excludeId IS NULL OR u.id_usuario <> :excludeId)",
					Long.class)
				.setParameter("email", email)
				.setParameter("excludeId", excludeId)
				.getSingleResult();
			return count != null && count > 0;
		} finally {
			em.close();
		}
	}

	public Usuario save(Usuario usuario) {
		EntityManager em = JpaUtil.createEntityManager();
		EntityTransaction tx = em.getTransaction();
		try {
			tx.begin();
			Usuario managed = em.merge(usuario);
			tx.commit();
			return managed;
		} catch (RuntimeException ex) {
			if (tx.isActive()) {
				tx.rollback();
			}
			throw ex;
		} finally {
			em.close();
		}
	}
}

