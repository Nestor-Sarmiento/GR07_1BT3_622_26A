<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: materiales.jsp
     Servlet: MaterialServlet → GET /materiales  (pendiente de crear en back)
     Atributos del request:
       - materiales: List<Material>  (cuando el servlet exista)
     Session: adminLogueado
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Gestión de Materiales - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
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
                "on-primary-fixed-variant": "#293ca0",
                "secondary": "#006a60", "secondary-container": "#85f6e5",
                "on-secondary-container": "#007166",
                "tertiary-fixed": "#ffdcc6", "on-tertiary-fixed-variant": "#713700",
                "outline": "#757684", "outline-variant": "#c5c5d4",
                "error": "#ba1a1a"
            }}}
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
        body { font-family: 'Inter', sans-serif; }
        h1, h2, h3 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface">

<%-- Protección de ruta --%>
<c:if test="${empty sessionScope.adminLogueado}">
    <c:redirect url="/login"/>
</c:if>

<%-- ── Sidebar ── --%>
<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-slate-50 py-6 space-y-4 z-50">
    <div class="px-6 mb-4">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-lg bg-primary-container flex items-center justify-center text-white">
                <span class="material-symbols-outlined">auto_stories</span>
            </div>
            <div>
                <h2 class="text-lg font-extrabold text-indigo-900 tracking-tight">OlwShare</h2>
                <p class="text-[10px] uppercase tracking-widest font-bold text-indigo-600/60">Administración</p>
            </div>
        </div>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <%-- Panel Principal --%>
        <a href="${pageContext.request.contextPath}/dashboardAdmin"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">dashboard</span>
            Panel Principal
        </a>
        <%-- Gestión de Materiales (activo) --%>
        <a href="${pageContext.request.contextPath}/materiales"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">library_books</span>
            Gestión de Materiales
        </a>
        <%-- Gestión de Cuentas --%>
        <a href="${pageContext.request.contextPath}/usuarios"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">manage_accounts</span>
            Gestión de Cuentas
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
<main class="ml-64 min-h-screen bg-surface flex flex-col">

    <%-- Top Nav --%>
    <header class="w-full sticky top-0 z-40 bg-white/80 backdrop-blur-md shadow-sm h-16 flex justify-between items-center px-8">
        <div class="flex items-center gap-4 flex-1">
            <div class="relative max-w-md w-full">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-lg">search</span>
                <input class="w-full bg-slate-100/50 border-none rounded-full py-2 pl-10 pr-4 focus:ring-2 focus:ring-indigo-200 text-sm outline-none"
                       placeholder="Buscar recursos..." type="text"/>
            </div>
        </div>
        <div class="flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/dashboardAdmin"
               class="p-2 text-slate-600 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">settings</span>
            </a>
            <div class="h-8 w-px bg-outline-variant/30"></div>
            <div class="text-right hidden sm:block">
                <p class="text-xs font-bold text-indigo-900" style="font-family:'Manrope',sans-serif">
                    <c:out value="${sessionScope.adminLogueado.nombre}"/>
                    <c:out value="${sessionScope.adminLogueado.apellido}"/>
                </p>
                <p class="text-[10px] text-slate-500">Administrador</p>
            </div>
            <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
                <c:out value="${sessionScope.adminLogueado.nombre.substring(0,1).toUpperCase()}"/>
            </div>
        </div>
    </header>

    <%-- Contenido --%>
    <div class="p-12 max-w-7xl mx-auto w-full">

        <%-- Header --%>
        <div class="mb-12">
            <h1 class="text-4xl font-extrabold text-indigo-900 tracking-tight mb-2">Gestión de Materiales</h1>
            <p class="text-lg text-slate-500">Listado de recursos pendientes de revisión</p>
        </div>

        <%-- Mensajes flash --%>
        <c:if test="${not empty requestScope.mensaje}">
            <div class="mb-6 flex items-center gap-3 bg-green-50 text-green-700 text-sm font-medium px-4 py-3 rounded-lg">
                <span class="material-symbols-outlined text-base">check_circle</span>
                <c:out value="${requestScope.mensaje}"/>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="mb-6 flex items-center gap-3 bg-red-50 text-red-700 text-sm font-medium px-4 py-3 rounded-lg">
                <span class="material-symbols-outlined text-base">error</span>
                <c:out value="${requestScope.error}"/>
            </div>
        </c:if>

        <%-- Tabla --%>
        <div class="bg-surface-container-low rounded-xl overflow-hidden">
            <div class="bg-surface-container-lowest p-1 shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="text-slate-500 font-semibold text-xs uppercase tracking-widest bg-surface-container-low/50">
                                <th class="px-8 py-5">Nombre del Material</th>
                                <th class="px-8 py-5">Materia</th>
                                <th class="px-8 py-5">Usuario</th>
                                <th class="px-8 py-5">Fecha de Envío</th>
                                <th class="px-8 py-5">Estado</th>
                                <th class="px-8 py-5">Costo</th>
                                <th class="px-8 py-5 text-right">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty materiales}">
                                    <c:forEach var="m" items="${materiales}">
                                        <tr class="hover:bg-slate-100/50 transition-colors border-t border-outline-variant/20">
                                            <td class="px-8 py-6">
                                                <div class="flex items-center gap-4">
                                                    <div class="w-10 h-10 rounded bg-indigo-50 flex items-center justify-center text-indigo-600">
                                                        <span class="material-symbols-outlined">description</span>
                                                    </div>
                                                    <span class="font-semibold text-on-surface" style="font-family:'Manrope',sans-serif">
                                                        <c:out value="${m.titulo}"/>
                                                    </span>
                                                </div>
                                            </td>
                                            <td class="px-8 py-6">
                                                <span class="px-3 py-1 rounded-full bg-secondary-container text-on-secondary-container text-[11px] font-bold uppercase tracking-wider">
                                                    <c:out value="${m.materia}"/>
                                                </span>
                                            </td>
                                            <td class="px-8 py-6 text-sm text-slate-600">
                                                <c:out value="${m.usuario}"/>
                                            </td>
                                            <td class="px-8 py-6 text-sm text-slate-500">
                                                <c:out value="${m.fechaEnvio}"/>
                                            </td>
                                            <td class="px-8 py-6">
                                                <span class="px-3 py-1 rounded-full text-[11px] font-bold uppercase tracking-wider
                                                    ${m.estado == 'PENDIENTE' ? 'bg-orange-100 text-orange-700' : 'bg-green-100 text-green-700'}">
                                                    <c:out value="${m.estado}"/>
                                                </span>
                                            </td>
                                            <td class="px-8 py-6 text-sm text-slate-600">
                                                $<c:out value="${m.costo}"/>
                                            </td>
                                            <td class="px-8 py-6 text-right">
                                                <%-- TODO: conectar con MaterialDetalleServlet cuando exista --%>
                                                <a href="${pageContext.request.contextPath}/material/detalle?id=${m.id}"
                                                   class="text-primary hover:text-primary-container font-bold text-sm tracking-tight transition-colors">
                                                    Ver Detalles
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <%-- Datos de ejemplo mientras no existe el servlet --%>
                                    <tr class="hover:bg-slate-100/50 transition-colors border-t border-outline-variant/20">
                                        <td class="px-8 py-6">
                                            <div class="flex items-center gap-4">
                                                <div class="w-10 h-10 rounded bg-indigo-50 flex items-center justify-center text-indigo-600">
                                                    <span class="material-symbols-outlined">description</span>
                                                </div>
                                                <span class="font-semibold text-on-surface" style="font-family:'Manrope',sans-serif">
                                                    Introducción a la Microeconomía v2
                                                </span>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="px-3 py-1 rounded-full bg-secondary-container text-on-secondary-container text-[11px] font-bold uppercase tracking-wider">
                                                Economía
                                            </span>
                                        </td>
                                        <td class="px-8 py-6 text-sm text-slate-600">Dr. Ricardo Silva</td>
                                        <td class="px-8 py-6 text-sm text-slate-500">12 Oct 2023</td>
                                        <td class="px-8 py-6">
                                            <span class="px-3 py-1 rounded-full bg-orange-100 text-orange-700 text-[11px] font-bold uppercase tracking-wider">
                                                Pendiente
                                            </span>
                                        </td>
                                        <td class="px-8 py-6 text-sm text-slate-600">$15.00</td>
                                        <td class="px-8 py-6 text-right">
                                            <a href="${pageContext.request.contextPath}/material/detalle?id=1" class="text-primary hover:text-primary-container font-bold text-sm tracking-tight transition-colors">
                                                Ver Detalles
                                            </a>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-slate-100/50 transition-colors border-t border-outline-variant/20">
                                        <td class="px-8 py-6">
                                            <div class="flex items-center gap-4">
                                                <div class="w-10 h-10 rounded bg-indigo-50 flex items-center justify-center text-indigo-600">
                                                    <span class="material-symbols-outlined">menu_book</span>
                                                </div>
                                                <span class="font-semibold text-on-surface" style="font-family:'Manrope',sans-serif">
                                                    Guía Didáctica: Literatura Siglo de Oro
                                                </span>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="px-3 py-1 rounded-full bg-orange-50 text-on-tertiary-fixed-variant text-[11px] font-bold uppercase tracking-wider">
                                                Humanidades
                                            </span>
                                        </td>
                                        <td class="px-8 py-6 text-sm text-slate-600">Elena Martínez</td>
                                        <td class="px-8 py-6 text-sm text-slate-500">10 Oct 2023</td>
                                        <td class="px-8 py-6">
                                            <span class="px-3 py-1 rounded-full bg-orange-100 text-orange-700 text-[11px] font-bold uppercase tracking-wider">
                                                Pendiente
                                            </span>
                                        </td>
                                        <td class="px-8 py-6 text-sm text-slate-600">$10.00</td>
                                        <td class="px-8 py-6 text-right">
                                            <a href="#" class="text-primary hover:text-primary-container font-bold text-sm tracking-tight transition-colors">
                                                Ver Detalles
                                            </a>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Paginación --%>
            <div class="px-8 py-4 bg-surface-container-low flex justify-between items-center text-xs text-slate-500 font-medium">
                <p>Mostrando materiales del sistema</p>
                <div class="flex gap-2">
                    <button class="w-8 h-8 flex items-center justify-center rounded bg-surface-container-lowest hover:bg-white transition-colors">
                        <span class="material-symbols-outlined text-sm">chevron_left</span>
                    </button>
                    <button class="w-8 h-8 flex items-center justify-center rounded bg-primary text-white font-bold">1</button>
                    <button class="w-8 h-8 flex items-center justify-center rounded bg-surface-container-lowest hover:bg-white transition-colors">
                        <span class="material-symbols-outlined text-sm">chevron_right</span>
                    </button>
                </div>
            </div>
        </div>

        <%-- Indicador de estado --%>
        <div class="mt-12 flex flex-col items-center justify-center opacity-30 select-none">
            <span class="material-symbols-outlined text-6xl mb-4">inventory_2</span>
            <p class="text-sm font-semibold italic" style="font-family:'Manrope',sans-serif">
                Curated Workspace Experience
            </p>
        </div>

    </div>
</main>

<%-- Mobile Bottom Nav --%>
<nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-lg border-t border-slate-100
            flex justify-around items-center h-16 px-4 z-50">
    <a href="${pageContext.request.contextPath}/dashboardAdmin"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/materiales"
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined">library_books</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Materiales</span>
    </a>
    <a href="${pageContext.request.contextPath}/usuarios"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">manage_accounts</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Cuentas</span>
    </a>
</nav>

</body>
</html>
