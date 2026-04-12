<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="schemas.Usuario" %>
<%-- =============================================
     Vista: crear-admin.jsp
     Servlet que la llama: UsuarioCrearServlet → GET /usuario/crear
     POST /usuario/crear → recibe nombre, apellido, email
       El servlet crea un Admin con password temporal y redirige a /usuarios con mensaje
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Crear Administrador - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Manrope:wght@700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: {
            "surface": "#f7f9fc", "surface-container": "#eceef1",
            "surface-container-low": "#f2f4f7", "surface-container-lowest": "#ffffff",
            "surface-container-highest": "#e0e3e6", "on-surface": "#191c1e",
            "on-surface-variant": "#454652", "primary": "#24389c",
            "primary-container": "#3f51b5", "on-primary": "#ffffff",
            "secondary": "#006a60", "secondary-container": "#85f6e5",
            "on-secondary-container": "#007166", "outline": "#757684",
            "outline-variant": "#c5c5d4", "error": "#ba1a1a"
        }}}}
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; }
        body { font-family:'Inter',sans-serif; background-color:#f7f9fc; }
        .editorial-shadow { box-shadow: 0 20px 40px rgba(25,28,30,0.08); }
    </style>
</head>
<body class="bg-surface text-on-surface">

<%-- Protección --%>
<%
    Usuario adminSes3 = (Usuario) session.getAttribute("adminLogueado");
    if (adminSes3 == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%@ include file="/WEB-INF/jsp/fragments/topnav.jsp" %>
<% request.setAttribute("activeMenu", "cuentas"); %>
<%@ include file="/WEB-INF/jsp/fragments/sidebar.jsp" %>

<main class="ml-64 min-h-screen pt-16 flex flex-col items-center justify-center p-8">

    <%-- Mensaje de éxito (después de crear) --%>
    <% if (request.getAttribute("mensaje") != null) { %>
    <div class="mb-8 w-full max-w-lg flex items-start gap-3 p-4 bg-secondary-container text-on-secondary-container rounded-lg editorial-shadow">
        <span class="material-symbols-outlined text-secondary">check_circle</span>
        <p class="text-sm font-medium"><%= request.getAttribute("mensaje") %></p>
    </div>
    <% } %>

    <%-- Mensaje de error --%>
    <% if (request.getAttribute("error") != null) { %>
    <div class="mb-8 w-full max-w-lg flex items-start gap-3 p-4 bg-red-50 text-red-700 rounded-lg editorial-shadow">
        <span class="material-symbols-outlined">error</span>
        <p class="text-sm font-medium"><%= request.getAttribute("error") %></p>
    </div>
    <% } %>

    <%-- ── Formulario ── --%>
    <div class="w-full max-w-lg bg-surface-container-lowest rounded-xl p-10 editorial-shadow">
        <header class="mb-10 text-center">
            <h1 class="text-3xl font-extrabold text-on-surface tracking-tight" style="font-family:'Manrope',sans-serif">
                Crear Nueva Cuenta de Administrador
            </h1>
            <p class="mt-2 text-outline text-sm">
                Complete los datos. El sistema generará y enviará una contraseña temporal al correo del nuevo administrador.
            </p>
        </header>

        <%--
            POST /usuario/crear
            Parámetros esperados por el servlet:
              - nombre   (String)
              - apellido (String)
              - email    (String)
            El servlet:
              1. Valida que el email no exista (adminRepo.existsByEmail)
              2. Genera password temporal
              3. Crea Admin con estado ACTIVO
              4. Envía email con credenciales
              5. Redirige a /usuarios con mensaje="Cuenta creada..."
        --%>
        <form action="${pageContext.request.contextPath}/usuario/crear" method="post" class="space-y-6">

            <div class="grid grid-cols-2 gap-6">
                <%-- Nombre --%>
                <div class="space-y-1">
                    <label class="block text-xs font-semibold text-primary uppercase tracking-wider ml-1" for="nombre">Nombre</label>
                    <input class="w-full px-4 py-3 bg-surface-container-highest border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface placeholder:text-outline-variant outline-none transition-all"
                           id="nombre" name="nombre" type="text"
                           placeholder="Ej. Carlos"
                           value="${not empty param.nombre ? param.nombre : ''}"
                           required/>
                </div>
                <%-- Apellido --%>
                <div class="space-y-1">
                    <label class="block text-xs font-semibold text-primary uppercase tracking-wider ml-1" for="apellido">Apellido</label>
                    <input class="w-full px-4 py-3 bg-surface-container-highest border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface placeholder:text-outline-variant outline-none transition-all"
                           id="apellido" name="apellido" type="text"
                           placeholder="Ej. Mendoza"
                           value="${not empty param.apellido ? param.apellido : ''}"/>
                </div>
            </div>

            <%-- Email --%>
            <div class="space-y-1">
                <label class="block text-xs font-semibold text-primary uppercase tracking-wider ml-1" for="email">Email</label>
                <input class="w-full px-4 py-3 bg-surface-container-highest border-none rounded-lg focus:ring-2 focus:ring-indigo-300 text-on-surface placeholder:text-outline-variant outline-none transition-all"
                       id="email" name="email" type="email"
                       placeholder="admin@olwshare.com"
                       value="${not empty param.email ? param.email : ''}"
                       required/>
            </div>

            <%-- Botón crear --%>
            <div class="pt-4">
                <button type="submit"
                        class="w-full py-4 bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold rounded-lg shadow-lg hover:shadow-indigo-200 active:scale-[0.98] transition-all flex items-center justify-center gap-2"
                        style="font-family:'Manrope',sans-serif">
                    <span>Crear Cuenta</span>
                    <span class="material-symbols-outlined text-sm">person_add</span>
                </button>
            </div>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/usuarios"
                   class="text-xs text-outline hover:text-primary transition-colors">
                    ← Volver a Gestión de Cuentas
                </a>
            </div>
        </form>

        <footer class="mt-8 text-center">
            <p class="text-xs text-outline leading-relaxed">
                El usuario recibirá sus credenciales temporales por correo y deberá cambiarlas en su primer ingreso.
            </p>
        </footer>
    </div>

    <%-- Decoración --%>
    <div class="fixed top-20 right-20 w-64 h-64 bg-primary/5 rounded-full blur-3xl -z-10 pointer-events-none"></div>
    <div class="fixed bottom-20 left-40 w-96 h-96 bg-secondary/5 rounded-full blur-3xl -z-10 pointer-events-none"></div>
</main>
</body>
</html>
