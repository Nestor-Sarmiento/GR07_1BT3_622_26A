<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: usuarios.jsp  (reemplaza la versión básica del back)
     Servlet: EstudianteServlet  →  GET /estudiantes
     Atributos del request:
       - estudiantes: List<Usuario>
     Atributos de session:
       - adminLogueado: Usuario  (protección de ruta)
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Gestión de Estudiantes - OlwShare</title>
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
    <c:redirect url="/login"/>
</c:if>

<%-- ── Top Nav ── --%>
<nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-lg border-t border-slate-100 flex justify-around items-center h-16 px-4 z-50">
    <a href="${pageContext.request.contextPath}/dashboardAdmin" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/materiales" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">library_books</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Materiales</span>
    </a>
    <a href="${pageContext.request.contextPath}/estudiantes" class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined">manage_accounts</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Cuentas</span>
    </a>
</nav>

<%-- ── Sidebar ── --%>
<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-slate-50 py-6 space-y-4 z-50">
    <div class="px-6 mb-4">
        <h2 class="text-lg font-extrabold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">OlwShare</h2>
        <p class="text-xs text-slate-500">Administración</p>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <a href="${pageContext.request.contextPath}/dashboardAdmin"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">dashboard</span>
            Panel Principal
        </a>
         <a href="${pageContext.request.contextPath}/materiales"
            class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
             <span class="material-symbols-outlined">library_books</span>
             Gestión de Materiales
         </a>
         <a href="${pageContext.request.contextPath}/usuarios"
            class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
             <span class="material-symbols-outlined">manage_accounts</span>
             Gestión de Cuentas
         </a>
         <a href="${pageContext.request.contextPath}/estudiantes"
            class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
             <span class="material-symbols-outlined">school</span>
             Gestión de Estudiantes
         </a>
     </nav>
    <div class="px-4 mt-auto">
        <a href="${pageContext.request.contextPath}/logout"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-error hover:bg-red-50 transition-all">
            <span class="material-symbols-outlined">logout</span>
            Cerrar Sesión
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
            <h1 class="text-4xl font-extrabold text-on-surface tracking-tight">Gestión de Estudiantes</h1>
            <p class="text-on-surface-variant text-lg">Administración de cuentas de estudiantes</p>
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
                    <c:when test="${not empty estudiantes}">
                        <c:forEach var="u" items="${estudiantes}">
                            <tr class="hover:bg-surface-container-low transition-colors duration-200">
                                <td class="px-8 py-5">
                                    <a href="${pageContext.request.contextPath}/estudiante/detalle?id=${u.id_usuario}"
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
                                    <a href="${pageContext.request.contextPath}/estudiante/detalle?id=${u.id_usuario}"
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
                                        No hay estudiantes registrados
                                    </p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <%-- ── Botón crear estudiante ── --%>
        <div class="flex justify-end">
            <a href="${pageContext.request.contextPath}/estudiante/crear"
               class="inline-flex items-center gap-3 h-14 px-8 bg-gradient-to-br from-primary to-primary-container
                      text-on-primary rounded-lg font-bold shadow-lg hover:shadow-xl transition-all active:scale-95"
               style="font-family:'Manrope',sans-serif">
                <span class="material-symbols-outlined">person_add</span>
                Crear Cuenta de Estudiante
            </a>
        </div>

    </div>
</main>
</body>
</html>
