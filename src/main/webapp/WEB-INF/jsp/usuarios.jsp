
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: usuarios.jsp  (reemplaza la versión básica del back)
     Servlet: UsuarioServlet  →  GET /usuarios  ✅ YA EXISTE
     Atributos del request:
       - usuarios: List<Usuario>
     Atributos de session:
       - adminLogueado: Usuario  (protección de ruta)
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Gestión de Cuentas - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: {
            "surface": "#f7f9fc", "surface-container": "#eceef1",
            "surface-container-low": "#f2f4f7", "surface-container-lowest": "#ffffff",
            "surface-container-high": "#e6e8eb", "on-surface": "#191c1e",
            "on-surface-variant": "#454652", "primary": "#24389c",
            "primary-container": "#3f51b5", "on-primary": "#ffffff",
            "secondary": "#006a60", "outline": "#757684",
            "outline-variant": "#c5c5d4", "error": "#ba1a1a"
        }}}}
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; }
        body { font-family:'Inter',sans-serif; }
        h1,h2,h3 { font-family:'Manrope',sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface">

<%-- Protección de ruta --%>
<c:if test="${empty sessionScope.adminLogueado}">
    <c:redirect url="/login.jsp"/>
</c:if>

<%-- ── Top Nav ── --%>
<nav class="fixed top-0 left-0 right-0 h-16 z-50 bg-white/80 backdrop-blur-xl shadow-sm flex justify-between items-center px-8">
    <div class="text-xl font-bold tracking-tight text-indigo-900" style="font-family:'Manrope',sans-serif">OlwShare</div>
    <div class="flex items-center gap-4">
        <span class="text-sm text-slate-600 font-medium">
            Hola, <c:out value="${sessionScope.adminLogueado.nombre}"/>
        </span>
        <a href="${pageContext.request.contextPath}/perfil"
           class="text-slate-500 hover:text-indigo-600 transition-colors p-2 rounded-full hover:bg-indigo-50">
            <span class="material-symbols-outlined">settings</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout"
           class="text-slate-500 hover:text-red-500 transition-colors p-2 rounded-full hover:bg-red-50">
            <span class="material-symbols-outlined">logout</span>
        </a>
    </div>
</nav>

<%-- ── Sidebar ── --%>
<aside class="fixed left-0 top-0 h-full w-64 pt-4 bg-slate-100 flex flex-col gap-2 text-sm z-40">
    <div class="px-6 py-4 mb-4 mt-16">
        <h2 class="text-lg font-black text-indigo-800" style="font-family:'Manrope',sans-serif">Admin Panel</h2>
        <p class="text-xs text-slate-500">OlwShare</p>
    </div>
    <nav class="flex-1 space-y-1 px-2">
        <a href="${pageContext.request.contextPath}/usuarios"
           class="flex items-center gap-3 px-4 py-3 rounded-lg bg-white text-indigo-700 font-bold shadow-sm transition-all hover:translate-x-1">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Gestión de Cuentas</span>
        </a>
    </nav>
    <div class="mt-auto pb-8 px-2">
        <a href="${pageContext.request.contextPath}/logout"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 transition-all">
            <span class="material-symbols-outlined">logout</span>
            <span>Cerrar Sesión</span>
        </a>
    </div>
</aside>

<%-- ── Main ── --%>
<main class="ml-64 min-h-screen pt-16 flex flex-col">

    <%-- Mensajes flash --%>
    <c:if test="${not empty requestScope.mensaje}">
        <div class="mx-12 mt-6 flex items-center gap-3 bg-green-50 text-green-700 text-sm font-medium px-4 py-3 rounded-lg">
            <span class="material-symbols-outlined text-base">check_circle</span>
            <c:out value="${requestScope.mensaje}"/>
        </div>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="mx-12 mt-6 flex items-center gap-3 bg-red-50 text-red-700 text-sm font-medium px-4 py-3 rounded-lg">
            <span class="material-symbols-outlined text-base">error</span>
            <c:out value="${requestScope.error}"/>
        </div>
    </c:if>

    <div class="p-12 max-w-7xl w-full mx-auto space-y-10">

        <%-- Header --%>
        <section class="space-y-2">
            <h1 class="text-4xl font-extrabold text-on-surface tracking-tight">Gestión de Cuentas</h1>
            <p class="text-on-surface-variant text-lg">Administración de perfiles y roles del sistema</p>
        </section>

        <%-- ── Tabla ── --%>
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
                    <c:choose>
                        <c:when test="${not empty usuarios}">
                            <c:forEach var="u" items="${usuarios}">
                                <tr class="hover:bg-surface-container-low transition-colors duration-200">
                                    <td class="px-8 py-5">
                                        <a href="${pageContext.request.contextPath}/usuario/detalle?id=${u.id_usuario}"
                                           class="text-on-surface font-semibold hover:text-primary transition-colors cursor-pointer"
                                           style="font-family:'Manrope',sans-serif">
                                            <c:out value="${u.nombre}"/>
                                        </a>
                                    </td>
                                    <td class="px-8 py-5 text-on-surface-variant"><c:out value="${u.apellido}"/></td>
                                    <td class="px-8 py-5 text-on-surface-variant"><c:out value="${u.email}"/></td>
                                    <td class="px-8 py-5">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold
                                            ${u.rol == 'ADMIN' ? 'bg-indigo-100 text-indigo-700' : 'bg-teal-50 text-teal-700'}">
                                            <c:out value="${u.rol}"/>
                                        </span>
                                    </td>
                                    <td class="px-8 py-5 text-right">
                                        <span class="inline-flex items-center gap-1.5 font-medium
                                            ${u.estado == 'ACTIVO' ? 'text-secondary' : 'text-error'}">
                                            <span class="w-2 h-2 rounded-full
                                                ${u.estado == 'ACTIVO' ? 'bg-secondary' : 'bg-error'}"></span>
                                            <c:out value="${u.estado}"/>
                                        </span>
                                    </td>
                                    <td class="px-8 py-5 text-center">
                                        <a href="${pageContext.request.contextPath}/usuario/detalle?id=${u.id_usuario}"
                                           class="inline-flex items-center gap-1 text-xs font-bold text-primary hover:underline">
                                            <span class="material-symbols-outlined text-sm">manage_accounts</span>
                                            Gestionar
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="px-8 py-16 text-center">
                                    <div class="flex flex-col items-center gap-3 opacity-40">
                                        <span class="material-symbols-outlined text-6xl">person_search</span>
                                        <p class="text-lg font-semibold" style="font-family:'Manrope',sans-serif">
                                            No hay usuarios registrados
                                        </p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- ── Botón crear admin ── --%>
        <div class="flex justify-end">
            <a href="${pageContext.request.contextPath}/usuario/crear"
               class="inline-flex items-center gap-3 h-14 px-8 bg-gradient-to-br from-primary to-primary-container
                      text-on-primary rounded-lg font-bold shadow-lg hover:shadow-xl transition-all active:scale-95"
               style="font-family:'Manrope',sans-serif">
                <span class="material-symbols-outlined">person_add</span>
                Crear Cuenta de Administrador
            </a>
        </div>

    </div>
</main>
</body>
</html>


