package epn.repositories;

import epn.schemas.Usuario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.List;

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

