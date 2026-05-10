<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: perfil-estudiante.jsp
     Servlet: PerfilServlet → GET /perfil
     Session: usuarioLogueado (Rol.ESTUDIANTE)
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Mi Perfil - OwlShare</title>
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

<%-- Sidebar --%>
<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-slate-50 py-6 space-y-4 z-50">
    <div class="px-6 mb-4">
        <h1 class="text-lg font-extrabold text-indigo-900 tracking-tight">OwlShare</h1>
        <p class="text-xs text-slate-500 font-medium">Portal de estudiante</p>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <a href="${pageContext.request.contextPath}/estudiante/dashboard"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">home</span>
            Inicio
        </a>
        <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">search</span>
            Buscar Tutor
        </a>
    </nav>
    <div class="px-4 mt-auto space-y-1">
        <a href="${pageContext.request.contextPath}/perfil"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">person</span>
            Mi Perfil
        </a>
        <a href="${pageContext.request.contextPath}/logout"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-error hover:bg-red-50 transition-all">
            <span class="material-symbols-outlined">logout</span>
            Cerrar Sesión
        </a>
    </div>
</aside>

<%-- Main --%>
<main class="flex-1 md:ml-64 min-h-screen bg-surface flex flex-col">
    <header class="w-full sticky top-0 z-40 bg-white/80 backdrop-blur-md shadow-sm h-16 flex justify-between items-center px-8">
        <div class="flex items-center gap-4">
            <div class="p-2 rounded-lg bg-indigo-50">
                <span class="material-symbols-outlined text-primary">person</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight">Mi Perfil</span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${requestScope.estudiantePerfil.nombre}"/></strong>
            </span>
            <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
                <c:out value="${requestScope.estudiantePerfil.nombre.substring(0,1).toUpperCase()}"/>
            </div>
        </div>
    </header>

    <div class="flex-1 p-6 md:p-10">
        <div class="max-w-3xl w-full mx-auto space-y-10">
            <div>
                <h2 class="text-4xl font-extrabold text-primary tracking-tight mb-2">Mi Perfil</h2>
                <p class="text-on-surface-variant text-lg">Gestiona tu información personal.</p>
            </div>

            <section>
                <div class="flex items-center gap-2 mb-5 text-primary">
                    <span class="material-symbols-outlined">badge</span>
                    <h3 class="text-xl font-bold">Información Actual</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="bg-surface-container-low p-6 rounded-xl border border-outline-variant/10">
                        <span class="text-xs font-semibold uppercase tracking-widest text-on-surface-variant mb-2 block">Nombre</span>
                        <p class="text-lg font-semibold text-on-surface">
                            <c:out value="${requestScope.estudiantePerfil.nombre}"/> <c:out value="${requestScope.estudiantePerfil.apellido}"/>
                        </p>
                    </div>
                    <div class="bg-surface-container-low p-6 rounded-xl border border-outline-variant/10">
                        <span class="text-xs font-semibold uppercase tracking-widest text-on-surface-variant mb-2 block">Correo Electrónico</span>
                        <p class="text-lg font-semibold text-on-surface">
                            <c:out value="${sessionScope.usuarioLogueado.email}"/>
                        </p>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>
</body>
</html>
