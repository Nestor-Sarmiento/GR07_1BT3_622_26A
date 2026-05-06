<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: tutorDashboard.jsp
     Servlet: TutorDashboardServlet → GET /tutor/dashboard
     Session: usuarioLogueado (Rol.TUTOR)
     Atributos de request: materialesAprobados, materialesPendientes, sesiones
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Panel del Tutor - OlwShare</title>
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
                "outline": "#757684", "outline-variant": "#c5c5d4",
                "error": "#ba1a1a", "background": "#f7f9fc"
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
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">dashboard</span>
            Panel Principal
        </a>
        <a href="${pageContext.request.contextPath}/tutor/materiales"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
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
                <span class="material-symbols-outlined text-primary">school</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Dashboard del Tutor
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
        <div class="max-w-5xl w-full mx-auto space-y-8">

            <%-- Bienvenida --%>
            <section class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
                <div class="space-y-1">
                    <p class="text-on-surface-variant font-medium uppercase tracking-widest text-[10px]">Portal del Tutor</p>
                    <h2 class="text-4xl font-extrabold text-on-surface tracking-tight">
                        Hola, <c:out value="${sessionScope.usuarioLogueado.nombre}"/>
                    </h2>
                </div>
                <a href="${pageContext.request.contextPath}/tutor/subir"
                   class="flex items-center gap-2 bg-secondary-container text-on-secondary-container px-6 py-3 rounded-xl font-bold hover:opacity-90 transition-all shadow-sm w-fit">
                    <span class="material-symbols-outlined">add_circle</span>
                    Subir Nuevo Material
                </a>
            </section>

            <%-- Tarjetas de estadísticas --%>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant/10 flex flex-col justify-between h-32">
                    <span class="text-xs font-semibold uppercase text-on-surface-variant tracking-wide">Materiales Aprobados</span>
                    <div class="flex items-baseline gap-2">
                        <span class="text-3xl font-bold text-primary">
                            <c:out value="${materialesAprobados != null ? materialesAprobados : 0}"/>
                        </span>
                        <span class="text-xs text-secondary font-bold">publicados</span>
                    </div>
                </div>
                <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant/10 flex flex-col justify-between h-32">
                    <span class="text-xs font-semibold uppercase text-on-surface-variant tracking-wide">Materiales Pendientes</span>
                    <div class="flex items-baseline gap-2">
                        <span class="text-3xl font-bold text-primary">
                            <c:out value="${materialesPendientes != null ? materialesPendientes : 0}"/>
                        </span>
                        <span class="text-xs font-bold" style="color:#713700">Revisión requerida</span>
                    </div>
                </div>
            </div>

            <%-- Próximas Tutorías --%>
            <div class="bg-surface-container-lowest rounded-xl overflow-hidden">
                <div class="p-6 flex justify-between items-center border-b border-surface-container">
                    <h3 class="text-xl font-bold text-on-surface flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">calendar_today</span>
                        Próximas Tutorías
                    </h3>
                    <a href="${pageContext.request.contextPath}/tutor/sesiones"
                       class="text-primary text-sm font-bold hover:underline">Ver calendario completo</a>
                </div>
                <div class="p-2">
                    <c:choose>
                        <c:when test="${not empty sesiones}">
                            <c:forEach var="sesion" items="${sesiones}">
                                <div class="p-4 hover:bg-surface-container-low transition-colors rounded-lg flex items-center justify-between group">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-12 rounded-full bg-primary-fixed flex items-center justify-center text-on-primary-fixed font-bold">
                                            <c:out value="${sesion.iniciales}"/>
                                        </div>
                                        <div>
                                            <h4 class="font-bold text-on-surface"><c:out value="${sesion.nombreEstudiante}"/></h4>
                                            <p class="text-xs text-on-surface-variant"><c:out value="${sesion.tema}"/></p>
                                        </div>
                                    </div>
                                    <div class="text-right flex items-center gap-6">
                                        <div>
                                            <p class="font-bold text-on-surface text-sm"><c:out value="${sesion.fecha}"/></p>
                                            <p class="text-[10px] text-on-surface-variant uppercase tracking-tighter"><c:out value="${sesion.duracion}"/></p>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/tutor/sesiones/${sesion.id}"
                                           class="opacity-0 group-hover:opacity-100 bg-primary text-white p-2 rounded-lg transition-all active:scale-90">
                                            <span class="material-symbols-outlined text-sm">info</span>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="py-12 text-center text-on-surface-variant">
                                <span class="material-symbols-outlined text-4xl mb-2 block">event_busy</span>
                                <p class="text-sm">No hay sesiones programadas próximamente.</p>
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
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/tutor/materiales"
       class="flex flex-col items-center justify-center text-slate-400">
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
