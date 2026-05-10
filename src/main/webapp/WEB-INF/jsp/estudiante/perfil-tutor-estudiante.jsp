<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: perfil-tutor-estudiante.jsp
     Servlet: VerPerfilTutorServlet → GET /estudiante/tutor/perfil
     Session: usuarioLogueado (Rol.ESTUDIANTE)
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Perfil del Tutor - OwlShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
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
        <h1 class="text-lg font-extrabold text-indigo-900 tracking-tight">OwlShare</h1>
        <p class="text-xs text-slate-500 font-medium">Portal de estudiante</p>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <%-- Inicio --%>
        <a href="${pageContext.request.contextPath}/estudiante/dashboard"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">home</span>
            Inicio
        </a>
        <%-- Buscar Tutor (activo: esta pantalla pertenece al flujo de búsqueda) --%>
        <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">search</span>
            Buscar Tutor
        </a>
        <%-- Gestión de tutorías --%>
        <a href="#"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">calendar_today</span>
            Gestión de tutorías
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

    <%-- Header --%>
    <header class="w-full sticky top-0 z-40 bg-white/80 backdrop-blur-md shadow-sm h-16 flex justify-between items-center px-8">
        <div class="flex items-center gap-4">
            <%-- Migas de pan --%>
            <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
               class="flex items-center gap-1 text-slate-500 hover:text-indigo-600 transition-colors text-sm font-medium">
                <span class="material-symbols-outlined text-base">arrow_back</span>
                <span class="hidden md:inline">Volver al buscador</span>
            </a>
            <span class="text-slate-300 hidden md:inline">|</span>
            <span class="hidden md:block text-base font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Perfil del Tutor
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
    <div class="flex-1 p-6 md:p-10 pb-20 md:pb-10">
        <div class="max-w-4xl w-full mx-auto space-y-8">

            <%-- ── Acción principal ── --%>
            <div class="flex justify-end">
                <a href="#"
                   class="flex items-center gap-3 bg-primary text-on-primary font-bold text-lg
                          px-8 py-4 rounded-xl shadow-lg hover:opacity-90 active:scale-95 transition-all">
                    <span class="material-symbols-outlined">calendar_month</span>
                    Quiero agendar una tutoría
                </a>
            </div>

            <%-- ── Tarjeta de identidad del tutor ── --%>
            <div class="bg-surface-container-lowest p-8 rounded-xl shadow-sm flex items-start gap-8">
                <%-- Avatar con inicial --%>
                <div class="relative shrink-0">
                    <div class="w-28 h-28 rounded-xl bg-primary-fixed flex items-center justify-center
                                text-on-primary-fixed font-extrabold text-5xl shadow-sm">
                        E
                    </div>
                    <%-- Insignia de verificado --%>
                    <div class="absolute -bottom-2 -right-2 bg-secondary text-white p-1 rounded-full border-4 border-white">
                        <span class="material-symbols-outlined text-sm"
                              style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">verified</span>
                    </div>
                </div>
                <%-- Info del tutor --%>
                <div class="flex-1 pt-1">
                    <h2 class="text-3xl font-extrabold text-on-surface tracking-tight mb-2">
                        Dra. Elena Rodríguez
                    </h2>
                    <div class="flex items-center gap-2 text-slate-600 mb-1">
                        <span class="material-symbols-outlined text-base">mail</span>
                        <span class="text-sm font-medium">elena.rodriguez@olwshare.edu</span>
                    </div>
                    <div class="flex items-center gap-2 text-slate-500">
                        <span class="material-symbols-outlined text-base">school</span>
                        <span class="text-sm">6to Semestre — Ingeniería en Computación</span>
                    </div>
                </div>
            </div>

            <%-- ── Biografía profesional ── --%>
            <section class="bg-surface-container-low p-8 rounded-xl">
                <h3 class="text-xl font-bold text-primary mb-5 flex items-center gap-2">
                    <span class="material-symbols-outlined">menu_book</span>
                    Biografía Profesional
                </h3>
                <div class="space-y-4 text-on-surface-variant leading-relaxed">
                    <p>
                        Con más de 10 años de experiencia en el ámbito académico y consultoría financiera,
                        mi enfoque pedagógico se centra en la aplicación práctica de conceptos complejos.
                        Soy Doctora en Economía con especialidad en Mercados Emergentes, lo que me permite
                        brindar una perspectiva global a mis estudiantes.
                    </p>
                    <p>
                        Creo firmemente que el aprendizaje efectivo ocurre cuando el estudiante logra
                        conectar la teoría con casos reales de la industria. Mis sesiones no son clases
                        magistrales, sino diálogos dinámicos donde resolvemos problemas y analizamos
                        escenarios actuales, garantizando que el conocimiento sea útil y duradero.
                    </p>
                </div>
            </section>

            <%-- ── Materias relacionadas ── --%>
            <section class="bg-surface-container-lowest p-8 rounded-xl shadow-sm">
                <h3 class="text-xl font-bold text-primary mb-6 flex items-center gap-2">
                    <span class="material-symbols-outlined">school</span>
                    Materias relacionadas
                </h3>
                <div class="flex flex-wrap gap-3">
                    <span class="px-4 py-1.5 text-white text-sm font-semibold rounded-full shadow-sm"
                          style="background-color:#81d4fa">Álgebra Lineal</span>
                    <span class="px-4 py-1.5 text-white text-sm font-semibold rounded-full shadow-sm"
                          style="background-color:#81d4fa">Cálculo en una Variable</span>
                    <span class="px-4 py-1.5 text-white text-sm font-semibold rounded-full shadow-sm"
                          style="background-color:#81d4fa">Ec. Diferenciales Ordinarias</span>
                    <span class="px-4 py-1.5 text-white text-sm font-semibold rounded-full shadow-sm"
                          style="background-color:#81d4fa">Probabilidad y Estadística</span>
                    <span class="px-4 py-1.5 text-white text-sm font-semibold rounded-full shadow-sm"
                          style="background-color:#81d4fa">Matemáticas Computacionales</span>
                </div>
            </section>

        </div>
    </div>

    <footer class="p-8 text-center text-slate-400 text-xs font-medium tracking-widest uppercase">
        © 2025 OwlShare · Plataforma Educativa Colaborativa
    </footer>
</main>

<%-- Mobile Bottom Nav --%>
<nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-lg border-t border-slate-100
            flex justify-around items-center h-16 px-4 z-50">
    <a href="${pageContext.request.contextPath}/estudiante/dashboard"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">home</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">search</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Buscar</span>
    </a>
    <a href="#" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">event_note</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Sesiones</span>
    </a>
    <a href="${pageContext.request.contextPath}/logout"
       class="flex flex-col items-center justify-center text-slate-400 hover:text-red-500">
        <span class="material-symbols-outlined">logout</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Salir</span>
    </a>
</nav>

</body>
</html>
