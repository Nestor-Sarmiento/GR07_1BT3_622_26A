package services;

import Enums.EstadoMaterial;
import Enums.Estados;
import Enums.Rol;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.junit.jupiter.MockitoExtension;
import repositories.UsuarioRepository;
import schemas.Material;
import schemas.Usuario;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EstudianteServiceTest {

    private final EstudianteService service = new EstudianteService();

    // ─── 4 Tests unitarios normales ──────────────────────────────────────────

    @Test
    void puedeSolicitarTutoria_deberiaRetornarTrue_siTutorDisponible() {
        assertTrue(service.puedeSolicitarTutoria(true));
    }

    @Test
    void puedeSolicitarTutoria_deberiaRetornarFalse_siTutorNoDisponible() {
        assertFalse(service.puedeSolicitarTutoria(false));
    }

    @Test
    void puedeDescargarArchivo_deberiaRetornarTrue_siMaterialAprobado() {
        Material material = new Material();
        material.setEstado(EstadoMaterial.APROBADO);
        assertTrue(service.puedeDescargarArchivo(material));
    }

    @Test
    void validarActualizacionDatos_deberiaRetornarTrue_siNombreYCorreoValidos() {
        assertTrue(service.validarActualizacionDatos("María López", "maria@epn.edu.ec"));
    }

    // ─── Test con Mocks: crear estudiante desde admin ────────────────────────

    @Test
    void crearEstudiante_deberiaGuardarEnRepo_conDatosCorrectos() {
        UsuarioRepository mockRepo = mock(UsuarioRepository.class);

        Usuario estudianteEsperado = Usuario.builder()
                .nombre("Ana Torres")
                .email("ana@epn.edu.ec")
                .password("temp123A1")
                .rol(Rol.ESTUDIANTE)
                .estado(Estados.POR_VERIFICAR)
                .mustChangePassword(true)
                .build();

        when(mockRepo.save(any(Usuario.class))).thenReturn(estudianteEsperado);

        Usuario resultado = service.crearEstudiante(
                mockRepo, "Ana Torres", "ana@epn.edu.ec", "temp123A1");

        assertEquals("Ana Torres",         resultado.getNombre());
        assertEquals("ana@epn.edu.ec",     resultado.getEmail());
        assertEquals(Rol.ESTUDIANTE,        resultado.getRol());
        assertEquals(Estados.POR_VERIFICAR, resultado.getEstado());
        assertTrue(resultado.isMustChangePassword());
    }

    // ─── Test parametrizado: bloquear estudiante por estado ──────────────────

    @ParameterizedTest(name = "estado={0} → esperado={1}")
    @CsvSource({
            "ACTIVO,        true",
            "INACTIVO,      false",
            "POR_VERIFICAR, false"
    })
    void puedeBloquearEstudiante_segunEstado(Estados estado, boolean esperado) {
        assertEquals(esperado, service.puedeBloquearEstudiante(estado));
    }
}
