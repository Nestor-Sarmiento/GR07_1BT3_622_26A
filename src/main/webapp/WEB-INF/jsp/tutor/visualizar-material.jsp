<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: visualizar-material.jsp
     Servlet: VisualizarMaterialServlet → GET /tutor/materiales
     Session: usuarioLogueado (Rol.TUTOR)
     Atributos de request: materiales (List), totalMateriales, materialesAprobados, materialesEnRevision
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Mis Materiales - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: { extend: { colors: {
                "surface": "#f7f9fc", "surface-container": "#eceef1",
                "surface-container-low": "#f2f4f7", "surface-container-lowest": "#ffffff",
                "surface-container-high": "#e6e8eb", "surface-container-highest": "#e0e3e6",
                "on-surface": "#191c1e", "on-surface-variant": "#454652",
                "primary": "#24389c", "primary-container": "#3f51b5",
                "primary-fixed": "#dee0ff", "on-primary": "#ffffff",
                "on-primary-fixed": "#00105c", "on-primary-fixed-variant": "#293ca0",
                "secondary": "#006a60", "secondary-container": "#85f6e5",
                "secondary-fixed": "#85f6e5", "on-secondary-container": "#007166",
                "tertiary-fixed": "#ffdcc6", "on-tertiary-fixed-variant": "#713700",
                "tertiary": "#6c3400", "tertiary-container": "#8f4700",
                "outline": "#757684", "outline-variant": "#c5c5d4",
                "error": "#ba1a1a", "error-container": "#ffdad6",
                "background": "#f7f9fc"
            }}}
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        body { font-family: 'Inter', sans-serif; }
        h1, h2, h3 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface min-h-screen flex">

<%-- Protección de ruta --%>
<c:if test="${empty sessionScope.usuarioLogueado}">
    <c:redirect url="/login"/>
</c:if>

<%-- ── Sidebar ── --%>
<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-slate-50 py-6 space-y-4 z-50">
    <div class="px-6 mb-4">
        <h1 class="text-lg font-extrabold text-indigo-900 tracking-tight">OlwShare</h1>
        <p class="text-xs text-slate-500 font-medium">Portal del Tutor</p>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <a href="${pageContext.request.contextPath}/tutor/dashboard"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">dashboard</span>
            Panel Principal
        </a>
        <%-- Mis Materiales (activo) --%>
        <a href="${pageContext.request.contextPath}/tutor/materiales"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">folder_open</span>
            Mis Materiales
        </a>
        <a href="${pageContext.request.contextPath}/tutor/subir"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">upload_file</span>
            Subir Material
        </a>
        <a href="${pageContext.request.contextPath}/tutor/sesiones"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">event</span>
            Sesiones Agendadas
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
<main class="flex-1 md:ml-64 min-h-screen bg-surface flex flex-col">

    <%-- Top Nav --%>
    <header class="w-full sticky top-0 z-40 bg-white/80 backdrop-blur-md shadow-sm h-16 flex justify-between items-center px-8">
        <div class="flex items-center gap-4">
            <div class="p-2 rounded-lg bg-indigo-50">
                <span class="material-symbols-outlined text-primary">folder_open</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Mis Materiales
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${sessionScope.usuarioLogueado.nombre}"/></strong>
            </span>
            <button class="p-2 text-slate-500 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">notifications</span>
            </button>
            <a href="${pageContext.request.contextPath}/logout"
               class="p-2 text-slate-600 hover:bg-red-50 hover:text-red-500 rounded-full transition-colors">
                <span class="material-symbols-outlined">logout</span>
            </a>
            <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
                <c:out value="${sessionScope.usuarioLogueado.nombre.substring(0,1).toUpperCase()}"/>
            </div>
        </div>
    </header>

    <%-- Contenido principal --%>
    <div class="flex-1 p-6 md:p-10">
        <div class="max-w-6xl w-full mx-auto space-y-8">

            <%-- Banner de estadísticas (Bento Style) --%>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

                <div class="bg-surface-container-lowest p-6 rounded-xl flex flex-col justify-between shadow-sm border border-outline-variant/10">
                    <div class="flex justify-between items-start">
                        <span class="material-symbols-outlined text-primary">description</span>
                        <span class="text-xs font-bold text-secondary px-2 py-1 bg-secondary-container/30 rounded-full">+4 este mes</span>
                    </div>
                    <div class="mt-4">
                        <p class="text-4xl font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                            <c:out value="${totalMateriales != null ? totalMateriales : 0}"/>
                        </p>
                        <p class="text-sm text-outline font-medium">Total de Materiales</p>
                    </div>
                </div>

                <div class="bg-surface-container-lowest p-6 rounded-xl flex flex-col justify-between shadow-sm border border-outline-variant/10">
                    <div class="flex justify-between items-start">
                        <span class="material-symbols-outlined text-secondary">verified_user</span>
                    </div>
                    <div class="mt-4">
                        <p class="text-4xl font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                            <c:out value="${materialesAprobados != null ? materialesAprobados : 0}"/>
                        </p>
                        <p class="text-sm text-outline font-medium">Aprobados</p>
                    </div>
                </div>

                <div class="bg-surface-container-lowest p-6 rounded-xl flex flex-col justify-between shadow-sm border border-outline-variant/10">
                    <div class="flex justify-between items-start">
                        <span class="material-symbols-outlined" style="color:#713700">schedule</span>
                    </div>
                    <div class="mt-4">
                        <p class="text-4xl font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                            <c:out value="${materialesEnRevision != null ? materialesEnRevision : 0}"/>
                        </p>
                        <p class="text-sm text-outline font-medium">En Revisión</p>
                    </div>
                </div>

            </div>

            <%-- Tabla de materiales --%>
            <div class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-sm border border-outline-variant/10">
                <div class="px-8 py-6 flex items-center justify-between border-b border-outline-variant/10">
                    <div>
                        <h3 class="text-xl font-bold text-on-surface" style="font-family:'Manrope',sans-serif">Gestión de Archivos</h3>
                        <p class="text-sm text-outline">Organiza y revisa el estado de tus contribuciones académicas.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/tutor/subir"
                       class="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-white bg-primary rounded-lg hover:opacity-90 transition-all">
                        <span class="material-symbols-outlined text-sm">add</span>
                        Nuevo Material
                    </a>
                </div>

                <div class="overflow-x-auto">
                    <c:choose>
                        <c:when test="${not empty materiales}">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-surface-container-low/50">
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Material</th>
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Publicación</th>
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Estado</th>
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-outline-variant/10">
                                    <c:forEach var="material" items="${materiales}">
                                        <tr class="hover:bg-surface-container/30 transition-colors group">
                                            <td class="px-8 py-5">
                                                <div class="flex items-center gap-4">
                                                    <div class="h-10 w-10 bg-error-container/20 text-error flex items-center justify-center rounded-lg flex-shrink-0">
                                                        <span class="material-symbols-outlined">picture_as_pdf</span>
                                                    </div>
                                                    <div>
                                                        <p class="font-semibold text-on-surface group-hover:text-primary transition-colors">
                                                            <c:out value="${material.titulo}"/>
                                                        </p>
                                                        <p class="text-xs text-outline">
                                                            <c:out value="${material.nombreMateria}"/>
                                                        </p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-8 py-5">
                                                <span class="text-sm text-outline">
                                                    <c:out value="${material.fechaSubida}"/>
                                                </span>
                                            </td>
                                            <td class="px-8 py-5">
                                                <c:choose>
                                                    <c:when test="${material.estado == 'APROBADO'}">
                                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-secondary/10 text-secondary">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-secondary inline-block"></span>
                                                            Aprobado
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${material.estado == 'EN_REVISION' || material.estado == 'PENDIENTE'}">
                                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold"
                                                              style="background-color:rgba(108,52,0,0.08);color:#6c3400">
                                                            <span class="w-1.5 h-1.5 rounded-full inline-block" style="background-color:#6c3400"></span>
                                                            En Revisión
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${material.estado == 'RECHAZADO'}">
                                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-error/10 text-error">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-error inline-block"></span>
                                                            Rechazado
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-outline/10 text-outline">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-outline inline-block"></span>
                                                            <c:out value="${material.estado}"/>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-8 py-5">
                                                <a href="${pageContext.request.contextPath}/tutor/material/detalle?id=${material.id}"
                                                   class="flex items-center gap-1.5 text-xs font-semibold text-primary hover:text-primary-container transition-colors">
                                                    <span class="material-symbols-outlined text-sm">visibility</span>
                                                    Ver detalles
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <%-- Paginación --%>
                            <div class="px-8 py-4 border-t border-outline-variant/10 flex items-center justify-between">
                                <p class="text-xs text-outline font-medium">
                                    Mostrando materiales de
                                    <c:out value="${sessionScope.usuarioLogueado.nombre}"/>
                                </p>
                                <div class="flex gap-2">
                                    <button class="w-8 h-8 flex items-center justify-center rounded border border-outline-variant/30 text-outline hover:bg-surface-container transition-all">
                                        <span class="material-symbols-outlined text-sm">chevron_left</span>
                                    </button>
                                    <button class="w-8 h-8 flex items-center justify-center rounded bg-primary text-white font-bold text-xs">1</button>
                                    <button class="w-8 h-8 flex items-center justify-center rounded border border-outline-variant/30 text-outline hover:bg-surface-container transition-all">
                                        <span class="material-symbols-outlined text-sm">chevron_right</span>
                                    </button>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <%-- Fila de demo: visible solo cuando no hay materiales reales --%>
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-surface-container-low/50">
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Material</th>
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Publicación</th>
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Estado</th>
                                        <th class="px-8 py-4 text-xs font-bold text-outline uppercase tracking-widest">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-outline-variant/10">
                                    <tr class="hover:bg-surface-container/30 transition-colors group">
                                        <td class="px-8 py-5">
                                            <div class="flex items-center gap-4">
                                                <div class="h-10 w-10 bg-error-container/20 text-error flex items-center justify-center rounded-lg flex-shrink-0">
                                                    <span class="material-symbols-outlined">picture_as_pdf</span>
                                                </div>
                                                <div>
                                                    <p class="font-semibold text-on-surface group-hover:text-primary transition-colors">Guía de Macroeconomía Avanzada</p>
                                                    <p class="text-xs text-outline">Macroeconomía I</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-8 py-5">
                                            <span class="text-sm text-outline">12 Oct, 2023</span>
                                        </td>
                                        <td class="px-8 py-5">
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-error/10 text-error">
                                                <span class="w-1.5 h-1.5 rounded-full bg-error inline-block"></span>
                                                Rechazado
                                            </span>
                                        </td>
                                        <td class="px-8 py-5">
                                            <a href="${pageContext.request.contextPath}/tutor/material/detalle"
                                               class="flex items-center gap-1.5 text-xs font-semibold text-primary hover:text-primary-container transition-colors">
                                                <span class="material-symbols-outlined text-sm">visibility</span>
                                                Ver detalles
                                            </a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="px-8 py-4 border-t border-outline-variant/10 flex items-center justify-between">
                                <p class="text-xs text-outline font-medium">Mostrando 1 material (ejemplo de navegación)</p>
                                <a href="${pageContext.request.contextPath}/tutor/subir"
                                   class="inline-flex items-center gap-2 text-xs font-semibold text-primary hover:opacity-80 transition-all">
                                    <span class="material-symbols-outlined text-sm">add_circle</span>
                                    Subir material real
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>

    <footer class="p-8 text-center text-slate-400 text-xs font-medium tracking-widest uppercase">
        © 2025 OlwShare · Plataforma Educativa Colaborativa
    </footer>
</main>

<%-- Mobile Bottom Nav --%>
<nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-lg border-t border-slate-100
            flex justify-around items-center h-16 px-4 z-50">
    <a href="${pageContext.request.contextPath}/tutor/dashboard"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/tutor/materiales"
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined">folder_open</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Materiales</span>
    </a>
    <a href="${pageContext.request.contextPath}/tutor/subir"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">upload_file</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Subir</span>
    </a>
    <a href="${pageContext.request.contextPath}/tutor/sesiones"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">event</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Sesiones</span>
    </a>
</nav>

</body>
</html>
