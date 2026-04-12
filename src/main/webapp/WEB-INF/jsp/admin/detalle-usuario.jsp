<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="schemas.Usuario" %>
<%-- =============================================
     Vista: detalle-usuario.jsp
     Servlet que la llama: UsuarioDetalleServlet → GET /usuario/detalle?id=X
     Atributos recibidos del request:
       - usuarioDetalle: Usuario   (el usuario a ver/editar)
     Atributos de session:
       - adminLogueado: Usuario
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Detalle de Cuenta - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: {
            "surface": "#f7f9fc", "surface-container": "#eceef1",
            "surface-container-low": "#f2f4f7", "surface-container-high": "#e6e8eb",
            "surface-container-lowest": "#ffffff", "on-surface": "#191c1e",
            "on-surface-variant": "#454652", "primary": "#24389c",
            "primary-container": "#3f51b5", "on-primary": "#ffffff",
            "secondary": "#006a60", "tertiary-fixed": "#ffdcc6",
            "outline": "#757684", "outline-variant": "#c5c5d4", "error": "#ba1a1a"
        }}}}
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; vertical-align:middle; }
        body { font-family: 'Inter', sans-serif; }
        h1,h2,h3 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface">

<%-- Protección de ruta --%>
<%
    Usuario adminSes2 = (Usuario) session.getAttribute("adminLogueado");
    if (adminSes2 == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Usuario u = (Usuario) request.getAttribute("usuarioDetalle");
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/usuarios");
        return;
    }
    boolean activo = u.getEstado() != null && "ACTIVO".equals(u.getEstado().name());
%>

<%@ include file="/WEB-INF/jsp/fragments/topnav.jsp" %>
<% request.setAttribute("activeMenu", "cuentas"); %>
<%@ include file="/WEB-INF/jsp/fragments/sidebar.jsp" %>

<main class="ml-64 min-h-screen pt-16">

    <%-- Mensajes flash --%>
    <% if (request.getAttribute("mensaje") != null) { %>
    <div class="mx-10 mt-6 flex items-center gap-3 bg-green-50 text-green-700 text-sm font-medium px-4 py-3 rounded-lg">
        <span class="material-symbols-outlined text-base">check_circle</span>
        <%= request.getAttribute("mensaje") %>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="mx-10 mt-6 flex items-center gap-3 bg-red-50 text-red-700 text-sm font-medium px-4 py-3 rounded-lg">
        <span class="material-symbols-outlined text-base">error</span>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="p-10 max-w-6xl mx-auto space-y-10">

        <%-- ── Breadcrumb ── --%>
        <div class="flex items-center gap-2 text-sm text-on-surface-variant">
            <a href="${pageContext.request.contextPath}/usuarios" class="hover:text-primary transition-colors">Gestión de Cuentas</a>
            <span class="material-symbols-outlined text-sm">chevron_right</span>
            <span class="text-on-surface font-medium"><%= u.getNombre() %> <%= u.getApellido() %></span>
        </div>

        <%-- ── Hero banner ── --%>
        <div class="relative bg-gradient-to-br from-indigo-900 to-indigo-700 rounded-2xl p-10 text-white overflow-hidden">
            <div class="flex items-center gap-6 relative z-10">
                <div class="w-20 h-20 rounded-2xl bg-white/20 flex items-center justify-center text-3xl font-black">
                    <%= u.getNombre() != null ? u.getNombre().substring(0,1).toUpperCase() : "?" %>
                </div>
                <div>
                    <h1 class="text-3xl font-extrabold tracking-tight"><%= u.getNombre() %> <%= u.getApellido() %></h1>
                    <p class="text-indigo-200 text-sm mt-1"><%= u.getEmail() %></p>
                    <span class="mt-2 inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold
                        <%= activo ? "bg-green-400/20 text-green-200" : "bg-red-400/20 text-red-200" %>">
                        <span class="w-1.5 h-1.5 rounded-full <%= activo ? "bg-green-300" : "bg-red-300" %>"></span>
                        <%= activo ? "Cuenta Activa" : "Cuenta Inactiva" %>
                    </span>
                </div>
            </div>
            <div class="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-white/5 to-transparent pointer-events-none"></div>
        </div>

        <%-- ── Bento grid ── --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <%-- ── Card: Editar información ── --%>
            <div class="md:col-span-2 bg-surface-container-lowest rounded-xl p-8 shadow-sm border border-outline-variant/10 space-y-6">
                <h3 class="text-sm font-bold text-slate-400 uppercase tracking-widest">Editar Información</h3>

                <%--
                    FORM: Editar datos del usuario
                    POST /usuario/editar
                    Parámetros: id, nombre, apellido, email, password (opcional)
                    El servlet:
                      - Lee los parámetros
                      - Actualiza en BD con usuarioRepository.save(usuario)
                      - Redirige a /usuario/detalle?id=X con mensaje de éxito
                --%>
                <form action="${pageContext.request.contextPath}/usuario/editar" method="post" class="space-y-5">
                    <input type="hidden" name="id" value="<%= u.getId_usuario() %>"/>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                        <%-- Nombre --%>
                        <div class="space-y-1">
                            <label class="block text-xs font-semibold text-primary uppercase tracking-wider" for="nombre">Nombre</label>
                            <input class="w-full px-4 py-3 bg-surface-container-high border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface outline-none transition-all"
                                   id="nombre" name="nombre" type="text"
                                   value="<%= u.getNombre() != null ? u.getNombre() : "" %>" required/>
                        </div>
                        <%-- Apellido --%>
                        <div class="space-y-1">
                            <label class="block text-xs font-semibold text-primary uppercase tracking-wider" for="apellido">Apellido</label>
                            <input class="w-full px-4 py-3 bg-surface-container-high border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface outline-none transition-all"
                                   id="apellido" name="apellido" type="text"
                                   value="<%= u.getApellido() != null ? u.getApellido() : "" %>"/>
                        </div>
                    </div>

                    <%-- Email con botón verificar --%>
                    <div class="space-y-1">
                        <label class="block text-xs font-semibold text-primary uppercase tracking-wider" for="email">Correo Electrónico</label>
                        <div class="flex gap-3">
                            <input class="flex-1 px-4 py-3 bg-surface-container-high border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface outline-none transition-all"
                                   id="email" name="email" type="email"
                                   value="<%= u.getEmail() %>" required/>
                            <%--
                                Botón Verificar Email:
                                POST /usuario/verificar-email
                                Parámetro: id
                                El servlet envía correo de verificación y redirige de vuelta con mensaje
                            --%>
                            <button type="button"
                                    onclick="document.getElementById('form-verificar').submit()"
                                    class="px-4 py-3 border-2 border-outline-variant/50 text-primary rounded-lg font-semibold text-sm hover:border-primary transition-all whitespace-nowrap">
                                <span class="material-symbols-outlined text-sm align-middle">mark_email_read</span>
                                Verificar
                            </button>
                        </div>
                    </div>

                    <%-- Contraseña (opcional) --%>
                    <div class="space-y-1">
                        <label class="block text-xs font-semibold text-primary uppercase tracking-wider" for="password">Nueva Contraseña</label>
                        <input class="w-full px-4 py-3 bg-surface-container-high border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface outline-none transition-all"
                               id="password" name="password" type="password"
                               placeholder="Dejar vacío para no cambiar"/>
                        <p class="text-xs text-slate-400 italic">Solo completa si deseas cambiar la contraseña del usuario.</p>
                    </div>

                    <div class="flex justify-end pt-2">
                        <button type="submit"
                                class="inline-flex items-center gap-2 px-8 py-3 bg-primary text-white font-bold rounded-lg hover:bg-primary-container transition-all shadow-sm hover:shadow-md">
                            <span class="material-symbols-outlined text-sm">save</span>
                            Guardar Cambios
                        </button>
                    </div>
                </form>

                <%-- Form oculto para verificar email --%>
                <form id="form-verificar" action="${pageContext.request.contextPath}/usuario/verificar-email" method="post" class="hidden">
                    <input type="hidden" name="id" value="<%= u.getId_usuario() %>"/>
                </form>
            </div>

            <%-- ── Sidebar: Acciones de gestión ── --%>
            <div class="space-y-5">

                <%-- Card acciones activar/desactivar --%>
                <div class="bg-indigo-900 rounded-xl p-6 text-white shadow-xl">
                    <h3 class="text-sm font-bold opacity-60 uppercase tracking-widest mb-5">Acciones de Gestión</h3>
                    <div class="space-y-3">

                        <%--
                            ACTIVAR CUENTA
                            POST /usuario/toggleEstado
                            Parámetros: id, estado = ACTIVO
                            El servlet actualiza usuario.estado y redirige con mensaje
                        --%>
                        <form action="${pageContext.request.contextPath}/usuario/toggleEstado" method="post">
                            <input type="hidden" name="id" value="<%= u.getId_usuario() %>"/>
                            <input type="hidden" name="estado" value="ACTIVO"/>
                            <button type="submit"
                                    class="w-full bg-white text-indigo-900 font-bold py-3 px-4 rounded-lg flex items-center justify-center gap-2 hover:bg-slate-100 transition-all active:scale-[0.98]
                                           <%= activo ? "opacity-40 cursor-not-allowed" : "" %>"
                                    <%= activo ? "disabled" : "" %>>
                                <span class="material-symbols-outlined">verified_user</span>
                                Activar cuenta
                            </button>
                        </form>

                        <%--
                            DESACTIVAR CUENTA
                            POST /usuario/toggleEstado
                            Parámetros: id, estado = INACTIVO
                        --%>
                        <form action="${pageContext.request.contextPath}/usuario/toggleEstado" method="post">
                            <input type="hidden" name="id" value="<%= u.getId_usuario() %>"/>
                            <input type="hidden" name="estado" value="INACTIVO"/>
                            <button type="submit"
                                    class="w-full bg-white/10 text-white font-bold py-3 px-4 rounded-lg flex items-center justify-center gap-2 hover:bg-white/20 border border-white/20 transition-all active:scale-[0.98]
                                           <%= !activo ? "opacity-40 cursor-not-allowed" : "" %>"
                                    <%= !activo ? "disabled" : "" %>>
                                <span class="material-symbols-outlined">block</span>
                                Desactivar cuenta
                            </button>
                        </form>
                    </div>
                    <div class="mt-6 pt-5 border-t border-white/10">
                        <p class="text-xs opacity-60 leading-relaxed">
                            Estas acciones afectarán el acceso inmediato del usuario a la plataforma.
                        </p>
                    </div>
                </div>

                <%-- Card info general (solo lectura) --%>
                <div class="bg-surface-container-high rounded-xl p-6 space-y-4">
                    <h4 class="text-sm font-bold text-slate-400 uppercase tracking-widest">Resumen</h4>
                    <div>
                        <p class="text-xs text-slate-400 uppercase tracking-wider mb-1">Rol</p>
                        <span class="inline-flex items-center gap-2 font-semibold text-indigo-900">
                            <span class="material-symbols-outlined text-base">
                                <%= "ADMIN".equals(u.getRol() != null ? u.getRol().name() : "") ? "admin_panel_settings" : "person" %>
                            </span>
                            <%= u.getRol() != null ? u.getRol().name() : "—" %>
                        </span>
                    </div>
                    <div>
                        <p class="text-xs text-slate-400 uppercase tracking-wider mb-1">ID de usuario</p>
                        <p class="text-sm font-mono text-slate-600">USR-<%= u.getId_usuario() %></p>
                    </div>
                </div>

                <%-- Volver --%>
                <a href="${pageContext.request.contextPath}/usuarios"
                   class="flex items-center gap-2 text-sm text-on-surface-variant hover:text-primary transition-colors">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    Volver a Gestión de Cuentas
                </a>
            </div>
        </div>
    </div>
</main>
</body>
</html>
