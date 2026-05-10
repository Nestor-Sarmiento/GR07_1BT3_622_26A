package tools;

import Enums.MateriasCatalogo;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import repositories.JpaUtil;

import java.util.List;
import java.util.Optional;

/**
 * Migración puntual: copia filas de {@code tutor_materias_fis} (columna {@code materia} = nombre de
 * constante enum antigua) hacia {@code tutor_materias_codigo} (siglas). Ejecutar una vez desde el IDE
 * (Run main) o {@code mvn -q exec:java -Dexec.mainClass=tools.MigrateTutorMateriasFisToCodigo}.
 * <p>
 * Tras verificar en Supabase, puedes vaciar o eliminar {@code tutor_materias_fis}.
 */
public final class MigrateTutorMateriasFisToCodigo {

    private MigrateTutorMateriasFisToCodigo() {
    }

    @SuppressWarnings("unchecked")
    public static void main(String[] args) {
        try (EntityManager em = JpaUtil.createEntityManager()) {
            List<Object[]> rows = em.createNativeQuery("SELECT id_tutor, materia FROM tutor_materias_fis")
                    .getResultList();

            EntityTransaction tx = em.getTransaction();
            tx.begin();
            int ok = 0;
            int unknown = 0;
            int dup = 0;
            for (Object[] row : rows) {
                long idTutor = ((Number) row[0]).longValue();
                String materiaConst = row[1] == null ? "" : String.valueOf(row[1]).trim();
                Optional<String> codOpt = MateriasCatalogo.codigoPorNombreConstanteLegacy(materiaConst);
                if (codOpt.isEmpty()) {
                    System.err.println("[omitido] id_tutor=" + idTutor + " materia='" + materiaConst
                            + "' (no coincide con ninguna constante de los enums actuales)");
                    unknown++;
                    continue;
                }
                String codigo = codOpt.get();
                int inserted = em.createNativeQuery(
                                "INSERT INTO tutor_materias_codigo (id_tutor, codigo) VALUES (:id, :cod) "
                                        + "ON CONFLICT DO NOTHING")
                        .setParameter("id", idTutor)
                        .setParameter("cod", codigo)
                        .executeUpdate();
                if (inserted == 0) {
                    dup++;
                } else {
                    ok++;
                }
            }
            tx.commit();
            System.out.println("Migración terminada: insertadas " + ok + " filas nuevas, "
                    + dup + " ya existían (conflicto), " + unknown + " sin mapeo.");
        }
    }
}
