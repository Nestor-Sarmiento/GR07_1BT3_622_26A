<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, schemas.Usuario" %>
<%-- =============================================
     Vista: usuarios.jsp
     Servlet que la llama: UsuarioServlet → GET /usuarios
     Atributos recibidos del request:
       - usuarios: List<Usuario>  (todos los usuarios)
     Atributos de session:
       - adminLogueado: Usuario   (admin autenticado)
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Gestión de Cuentas - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: {
            "surface": "#f7f9fc", "surface-container": "#eceef1",
            "surface-container-low": "#f2f4f7", "surface-container-lowest": "#ffffff",
            "surface-container-high": "#e6e8eb", "on-surface": "#191c1e",
            "on-surface-variant": "#454652", "primary": "#24389c",
            "primary-container": "#3f51b5", "on-primary": "#ffffff",
            "secondary": "#006a60", "outline": "#757684", "outline-variant": "#c5c5d4",
            "error": "#ba1a1a"
        }}}}
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; }
        body { font-family: 'Inter', sans-serif; }
        h1,h2,h3 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface">

<%-- ── Protección de ruta: redirige al login si no hay sesión ── --%>
<%
    Usuario adminSes = (Usuario) session.getAttribute("adminLogueado");
    if (adminSes == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
%>

<%-- ── Top Nav ── --%>
<%@ include file="/WEB-INF/jsp/fragments/topnav.jsp" %>

<%-- ── Sidebar ── --%>
<% request.setAttribute("activeMenu", "cuentas"); %>
<%@ include file="/WEB-INF/jsp/fragments/sidebar.jsp" %>

<%-- ── Main ── --%>
<main class="ml-64 min-h-screen pt-16 flex flex-col">

    <%-- Mensaje flash (éxito/error desde el servlet) --%>
    <% if (request.getAttribute("mensaje") != null) { %>
    <div class="mx-12 mt-6 flex items-center gap-3 bg-green-50 text-green-700 text-sm font-medium px-4 py-3 rounded-lg">
        <span class="material-symbols-outlined text-base">check_circle</span>
        <%= request.getAttribute("mensaje") %>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="mx-12 mt-6 flex items-center gap-3 bg-red-50 text-red-700 text-sm font-medium px-4 py-3 rounded-lg">
        <span class="material-symbols-outlined text-base">error</span>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="p-12 max-w-7xl w-full mx-auto space-y-10">

        <%-- Header --%>
        <section class="space-y-2">
            <h1 class="text-4xl font-extrabold text-on-surface tracking-tight">Gestión de Cuentas</h1>
            <p class="text-on-surface-variant text-lg">Administración de perfiles y roles del sistema</p>
        </section>

        <%-- ── Tabla de usuarios ── --%>
        <div class="bg-surface-container-lowest shadow-sm rounded-xl overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-surface-container-low/50">
                        <th class="px-8 py-5 text-sm font-semibold text-primary uppercase tracking-wider">Nombre</th>
                        <th class="px-8 py-5 text-sm font-semibold text-primary uppercase tracking-wider">Apellido</th>
                        <th class="px-8 py-5 text-sm font-semibold text-primary uppercase tracking-wider">Email</th>
                        <th class="px-8 py-5 text-sm font-semibold text-primary uppercase tracking-wider">Rol</th>
                        <th class="px-8 py-5 text-sm font-semibold text-primary uppercase tracking-wider text-right">Estado</th>
                        <th class="px-8 py-5 text-sm font-semibold text-primary uppercase tracking-wider text-center">Acción</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-surface-container">
                    <%-- ── Filas dinámicas desde el servlet ── --%>
                    <%
                        if (usuarios != null && !usuarios.isEmpty()) {
                            int seq = 1;
                            for (Usuario u : usuarios) {
                                boolean activo = u.getEstado() != null && "ACTIVO".equals(u.getEstado().name());
                    %>
                    <tr class="hover:bg-surface-container-low transition-colors duration-200">
                        <td class="px-8 py-5">
                            <a href="${pageContext.request.contextPath}/usuario/detalle?id=<%= u.getId_usuario() %>"
                               class="text-on-surface font-semibold hover:text-primary transition-colors cursor-pointer">
                                <%= u.getNombre() != null ? u.getNombre() : "—" %>
                            </a>
                        </td>
                        <td class="px-8 py-5 text-on-surface-variant"><%= u.getApellido() != null ? u.getApellido() : "—" %></td>
                        <td class="px-8 py-5 text-on-surface-variant"><%= u.getEmail() %></td>
                        <td class="px-8 py-5">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold
                                <%= "ADMIN".equals(u.getRol() != null ? u.getRol().name() : "") ? "bg-indigo-100 text-indigo-700" : "bg-teal-50 text-teal-700" %>">
                                <%= u.getRol() != null ? u.getRol().name() : "—" %>
                            </span>
                        </td>
                        <td class="px-8 py-5 text-right">
                            <span class="inline-flex items-center gap-1.5 font-medium <%= activo ? "text-secondary" : "text-error" %>">
                                <span class="w-2 h-2 rounded-full <%= activo ? "bg-secondary" : "bg-error" %>"></span>
                                <%= activo ? "Activo" : "Inactivo" %>
                            </span>
                        </td>
                        <td class="px-8 py-5 text-center">
                            <a href="${pageContext.request.contextPath}/usuario/detalle?id=<%= u.getId_usuario() %>"
                               class="inline-flex items-center gap-1 text-xs font-bold text-primary hover:underline">
                                <span class="material-symbols-outlined text-sm">manage_accounts</span>
                                Gestionar
                            </a>
                        </td>
                    </tr>
                    <%  seq++; } } else { %>
                    <tr>
                        <td colspan="6" class="px-8 py-16 text-center">
                            <div class="flex flex-col items-center gap-3 opacity-40">
                                <span class="material-symbols-outlined text-6xl">person_search</span>
                                <p class="text-lg font-semibold" style="font-family:'Manrope',sans-serif">No hay usuarios registrados</p>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <%-- ── Botón crear admin ── --%>
        <div class="flex justify-end">
            <a href="${pageContext.request.contextPath}/usuario/crear"
               class="inline-flex items-center gap-3 h-14 px-8 bg-gradient-to-br from-primary to-primary-container text-on-primary rounded-lg font-bold shadow-lg hover:shadow-xl transition-all active:scale-95">
                <span class="material-symbols-outlined">person_add</span>
                Crear Cuenta de Administrador
            </a>
        </div>

    </div>
</main>
</body>
</html>
