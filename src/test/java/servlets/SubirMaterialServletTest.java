package servlets;

import Enums.Rol;
import Enums.EstadoMaterial;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import schemas.Usuario;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Path;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class SubirMaterialServletTest {

    private SubirMaterialServlet servlet;

    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;
    @Mock
    private HttpSession session;
    @Mock
    private ServletContext servletContext;
    @Mock
    private Part filePart;
    @Mock
    private jakarta.servlet.RequestDispatcher requestDispatcher;

    @TempDir
    Path tempDir;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
        servlet = new SubirMaterialServlet() {
            @Override
            public ServletContext getServletContext() {
                return servletContext;
            }
        };
    }

    @Test
    void testSubirMaterialExitoso() throws ServletException, IOException {
        Usuario tutor = Usuario.builder()
                .nombre("Test Tutor")
                .rol(Rol.TUTOR)
                .build();

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(tutor);

        when(request.getParameter("titulo")).thenReturn("Material de Prueba");
        when(request.getParameter("descripcion")).thenReturn("Descripcion de prueba");
        when(request.getParameter("nombreMateria")).thenReturn("FISICA");
        when(request.getParameter("costo")).thenReturn("10.0");

        when(request.getPart("archivo")).thenReturn(filePart);
        when(filePart.getSubmittedFileName()).thenReturn("test.pdf");
        when(filePart.getInputStream()).thenReturn(new ByteArrayInputStream("contenido".getBytes()));

        when(servletContext.getRealPath("")).thenReturn(tempDir.toString());

        servlet.doPost(request, response);

        verify(session).setAttribute(eq("flashMensaje"), contains("Material enviado correctamente"));
        verify(response).sendRedirect(anyString());
    }

    @Test
    void testSubirMaterialSinArchivo() throws ServletException, IOException {
        Usuario tutor = Usuario.builder()
                .nombre("Test Tutor")
                .rol(Rol.TUTOR)
                .build();

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(tutor);

        when(request.getParameter("titulo")).thenReturn("Material de Prueba");
        when(request.getParameter("descripcion")).thenReturn("Descripcion de prueba");
        when(request.getParameter("nombreMateria")).thenReturn("FISICA");

        when(request.getPart("archivo")).thenReturn(filePart);
        when(filePart.getSubmittedFileName()).thenReturn(""); // No hay archivo seleccionado

        // En el código actual, si archivoPart.getSubmittedFileName() es vacío, el idx será -1
        // y extension será "", lo cual no está en extensionesPermitidas.

        servlet.doPost(request, response);

        verify(request).setAttribute(eq("error"), anyString());
        verify(request).getRequestDispatcher(anyString());
    }
}


