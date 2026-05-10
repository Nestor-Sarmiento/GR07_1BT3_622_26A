package servlets;

import Enums.CategoriaMaterial;
import Enums.EstadoMaterial;
import Enums.MateriasCatalogo;
import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import schemas.Material;
import schemas.Usuario;
import repositories.MaterialRepository;
import servlets.validators.ArchivoMaterialValidator;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet(name = "subirMaterialServlet", urlPatterns = "/tutor/subir")
@MultipartConfig(maxFileSize = 25 * 1024 * 1024)
public class SubirMaterialServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/jsp/tutor/subir-material.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!esTutor(req, resp)) return;

        HttpSession session = req.getSession(false);
        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        prepararMateriasYPerfil(req, u);

        req.setAttribute("categorias", CategoriaMaterial.values());
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private static void prepararMateriasYPerfil(HttpServletRequest req, Usuario u) {
        if (u != null && u.getIdPersona() != null) {
            jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager();
            try {
                schemas.Tutor tutorPerfil = em.find(schemas.Tutor.class, u.getIdPersona());
                req.setAttribute("tutorPerfil", tutorPerfil);
                if (tutorPerfil != null && tutorPerfil.getCarrera() != null) {
                    req.setAttribute("materiasOpciones", MateriasCatalogo.porCarrera(tutorPerfil.getCarrera()));
                } else {
                    req.setAttribute("materiasOpciones", MateriasCatalogo.todasOpcionesBusqueda());
                }
            } finally {
                em.close();
            }
        } else {
            req.setAttribute("materiasOpciones", MateriasCatalogo.todasOpcionesBusqueda());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String titulo = req.getParameter("titulo");
        String descripcion = req.getParameter("descripcion");
        String categoria = req.getParameter("nombreMateria");
        String materiaCodigo = ServletUtils.value(req.getParameter("materia"));
        String precioStr = req.getParameter("costo");
        Part archivoPart = req.getPart("archivo");
        if (titulo == null || titulo.isBlank()) {
            req.setAttribute("error", "El título es obligatorio.");
            req.setAttribute("categorias", CategoriaMaterial.values());
            prepararMateriasYPerfil(req, (Usuario) session.getAttribute("usuarioLogueado"));
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        String nombreArchivoOriginal = archivoPart.getSubmittedFileName();
        String extension = ArchivoMaterialValidator.obtenerExtension(nombreArchivoOriginal);

        if (!ArchivoMaterialValidator.esExtensionPermitida(extension)) {
            req.setAttribute("error", "Extensión no permitida");
            req.setAttribute("categorias", CategoriaMaterial.values());
            prepararMateriasYPerfil(req, (Usuario) session.getAttribute("usuarioLogueado"));
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        String uploadsDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "materiales";
        Files.createDirectories(Paths.get(uploadsDir));
        String nombreArchivoGuardado = UUID.randomUUID() + extension;
        String rutaArchivo = uploadsDir + File.separator + nombreArchivoGuardado;

        try (InputStream input = archivoPart.getInputStream();
            OutputStream output = new FileOutputStream(rutaArchivo)) {
            input.transferTo(output);
        }

        Double costo = 0.0;
        if (precioStr != null && !precioStr.isBlank()) {
            try {
                costo = Double.parseDouble(precioStr);
            } catch (NumberFormatException ignored) {}
        }
        Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
        String nombreUsuario = "Tutor";

        if (u.getIdPersona() != null) {
            jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager();
            try {
                schemas.Tutor tutor = em.find(schemas.Tutor.class, u.getIdPersona());
                if (tutor != null && tutor.getNombre() != null) {
                    nombreUsuario = tutor.getNombre();
                }
            } finally {
                em.close();
            }
        }

        String idMateriaVal = materiaCodigo.isBlank() ? categoria : materiaCodigo;
        String nombreMateriaVal = MateriasCatalogo.buscarPorCodigo(materiaCodigo)
                .map(MateriasCatalogo.Opcion::getNombre)
                .orElse(categoria != null && !categoria.isBlank() ? categoria : materiaCodigo);

        Material material = Material.builder()
                .titulo(titulo)
                .descripcion(descripcion)
                .nombreArchivo(nombreArchivoGuardado)
                .idMateria(idMateriaVal)
                .nombreMateria(nombreMateriaVal)
                .rutaArchivo("uploads/materiales/" + nombreArchivoGuardado)
                .tipoArchivo(extension.substring(1))
                .costo(costo)
                .estado(EstadoMaterial.PENDIENTE)
                .fechaEnvio(java.time.LocalDateTime.now())
                .usuario(nombreUsuario)
                .build();

        new MaterialRepository().save(material);

        session.setAttribute("flashMensaje", "Material enviado correctamente");
        resp.sendRedirect(req.getContextPath() + "/tutor/subir");
    }

    private boolean esTutor(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario u)
                || u.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
