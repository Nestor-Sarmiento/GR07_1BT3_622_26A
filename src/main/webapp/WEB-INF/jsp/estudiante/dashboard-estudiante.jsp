<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: dashboard-estudiante.jsp
     Servlet: EstudianteDashboardServlet → GET /estudiante/dashboard
     Session: usuarioLogueado (Rol.ESTUDIANTE)
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Dashboard del Estudiante - OwlShare</title>
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
        .editorial-shadow { box-shadow: 0 20px 40px rgba(25, 28, 30, 0.12); }
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
        <%-- Inicio (activo) --%>
        <a href="${pageContext.request.contextPath}/estudiante/dashboard"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">home</span>
            Inicio
        </a>
        <%-- Buscar Tutor --%>
        <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">search</span>
            Buscar Tutor
        </a>
        <%-- Mi Perfil --%>
        <a href="${pageContext.request.contextPath}/perfil"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">person</span>
            Mi Perfil
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
            <div class="p-2 rounded-lg bg-indigo-50">
                <span class="material-symbols-outlined text-primary">school</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Dashboard del Estudiante
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${requestScope.estudiantePerfil.nombre}"/></strong>
            </span>
            <button class="p-2 text-slate-500 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">notifications</span>
            </button>
            <a href="${pageContext.request.contextPath}/perfil"
               class="p-2 text-slate-600 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">settings</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="p-2 text-slate-600 hover:bg-red-50 hover:text-red-500 rounded-full transition-colors">
                <span class="material-symbols-outlined">logout</span>
            </a>
            <a href="${pageContext.request.contextPath}/perfil"
               class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm hover:ring-2 hover:ring-indigo-400 transition-all"
               title="Mi Perfil">
                <c:out value="${requestScope.estudiantePerfil.nombre.substring(0,1).toUpperCase()}"/>
            </a>
        </div>
    </header>

    <%-- Contenido principal --%>
    <div class="flex-1 p-6 md:p-10 pb-20 md:pb-10">
        <div class="max-w-5xl w-full mx-auto">

            <%-- Bienvenida --%>
            <header class="mb-12">
                <h2 class="text-4xl md:text-5xl font-extrabold tracking-tight text-on-surface mb-2">
                    Hola, <c:out value="${requestScope.estudiantePerfil.nombre}"/> &#x1F44B;
                </h2>
                <p class="text-lg text-on-surface-variant font-medium">
                    Bienvenido de nuevo a tu espacio de aprendizaje.
                </p>
            </header>

            <%-- Grid principal --%>
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

                <%-- Columna izquierda: reservada para secciones futuras --%>
                <div class="lg:col-span-8"></div>

                <%-- Columna derecha: tarjeta de acción --%>
                <aside class="lg:col-span-4">
                    <div class="bg-primary-container p-8 rounded-2xl text-white editorial-shadow relative overflow-hidden group">
                        <div class="relative z-10">
                            <h3 class="text-2xl font-extrabold mb-2 leading-tight">
                                &#191;Necesitas ayuda extra?
                            </h3>
                            <p class="mb-6 text-sm leading-relaxed" style="color:rgba(222,224,255,0.85)">
                                Encuentra al tutor ideal para resolver tus dudas en minutos.
                            </p>
                            <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
                               class="w-full py-4 bg-white text-primary font-bold rounded-xl shadow-lg
                                      hover:bg-primary-fixed transition-all active:scale-95
                                      flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined">person_search</span>
                                <span>Buscar un Tutor</span>
                            </a>
                        </div>
                        <div class="absolute -bottom-10 -right-10 w-40 h-40 bg-white/10 rounded-full blur-3xl
                                    group-hover:scale-150 transition-transform duration-500 pointer-events-none"></div>
                    </div>
                </aside>

            </div>
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
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">home</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="#" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">search</span>
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
