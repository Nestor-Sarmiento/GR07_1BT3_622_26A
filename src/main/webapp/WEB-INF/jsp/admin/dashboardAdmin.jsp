<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: dashboard.jsp
     Servlet: PerfilServlet → GET /perfil
     Redirige a: /usuarios y /usuario/crear
     Session: adminLogueado
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Panel Principal - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
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
<c:if test="${empty sessionScope.adminLogueado}">
    <c:redirect url="/login"/>
</c:if>

<%-- ── Sidebar ── --%>
<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-slate-50 py-6 space-y-4 z-50">
    <div class="px-6 mb-4">
        <h1 class="text-lg font-extrabold text-indigo-900 tracking-tight">OlwShare</h1>
        <p class="text-xs text-slate-500 font-medium">Administración</p>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <%-- Panel Principal (activo) --%>
        <a href="${pageContext.request.contextPath}/perfil"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">dashboard</span>
            Panel Principal
        </a>
        <%-- Gestión de Materiales --%>
        <a href="${pageContext.request.contextPath}/materiales"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
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
<main class="flex-1 md:ml-64 min-h-screen bg-surface flex flex-col">

    <%-- Top Nav --%>
    <header class="w-full sticky top-0 z-40 bg-white/80 backdrop-blur-md shadow-sm h-16 flex justify-between items-center px-8">
        <div class="flex items-center gap-4">
            <span class="text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Editorial Intelligence
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${sessionScope.adminLogueado.nombre}"/></strong>
            </span>
            <a href="${pageContext.request.contextPath}/perfil"
               class="p-2 text-slate-600 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">settings</span>
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="p-2 text-slate-600 hover:bg-red-50 hover:text-red-500 rounded-full transition-colors">
                <span class="material-symbols-outlined">logout</span>
            </a>
            <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
                <c:out value="${sessionScope.adminLogueado.nombre.substring(0,1).toUpperCase()}"/>
            </div>
        </div>
    </header>

    <%-- Contenido principal --%>
    <div class="flex-1 flex items-center justify-center p-6 md:p-12">
        <div class="max-w-5xl w-full">

            <%-- Bienvenida --%>
            <div class="mb-12 text-center md:text-left">
                <h2 class="text-4xl md:text-5xl font-extrabold text-primary tracking-tight mb-4">
                    Bienvenido al panel de control.
                </h2>
                <p class="text-lg text-on-surface-variant max-w-2xl leading-relaxed">
                    Seleccione una sección para comenzar. Administre sus recursos educativos
                    y perfiles de usuario con herramientas diseñadas para la excelencia.
                </p>
            </div>

            <%-- Tarjetas de acceso --%>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

                <%-- Tarjeta: Gestión de Materiales --%>
                <a href="${pageContext.request.contextPath}/materiales"
                   class="group relative overflow-hidden rounded-xl bg-surface-container-lowest
                          transition-all duration-300 hover:-translate-y-1 shadow-sm hover:shadow-lg">
                    <div class="p-10 flex flex-col h-full min-h-[280px] justify-between relative z-10">
                        <div>
                            <div class="w-16 h-16 rounded-lg bg-primary-fixed flex items-center justify-center text-primary mb-8
                                        transition-transform duration-300 group-hover:scale-110">
                                <span class="material-symbols-outlined text-4xl">library_books</span>
                            </div>
                            <h3 class="text-2xl font-bold text-on-surface mb-3">Gestión de Materiales</h3>
                            <p class="text-on-surface-variant leading-relaxed">
                                Organice, edite y publique nuevos contenidos académicos.
                                Acceda a la biblioteca centralizada de recursos multimedia.
                            </p>
                        </div>
                        <div class="flex items-center text-primary font-semibold text-sm tracking-wide mt-6">
                            EXPLORAR CATÁLOGO
                            <span class="material-symbols-outlined ml-2 text-lg transition-transform duration-300 group-hover:translate-x-2">
                                arrow_forward
                            </span>
                        </div>
                    </div>
                    <div class="absolute -bottom-12 -right-12 w-48 h-48 bg-indigo-50/50 rounded-full blur-3xl
                                group-hover:bg-indigo-100/60 transition-colors pointer-events-none"></div>
                </a>

                <%-- Tarjeta: Gestión de Cuentas --%>
                <a href="${pageContext.request.contextPath}/usuarios"
                   class="group relative overflow-hidden rounded-xl bg-surface-container-lowest
                          transition-all duration-300 hover:-translate-y-1 shadow-sm hover:shadow-lg">
                    <div class="p-10 flex flex-col h-full min-h-[280px] justify-between relative z-10">
                        <div>
                            <div class="w-16 h-16 rounded-lg bg-secondary-container flex items-center justify-center text-on-secondary-container mb-8
                                        transition-transform duration-300 group-hover:scale-110">
                                <span class="material-symbols-outlined text-4xl">manage_accounts</span>
                            </div>
                            <h3 class="text-2xl font-bold text-on-surface mb-3">Gestión de Cuentas</h3>
                            <p class="text-on-surface-variant leading-relaxed">
                                Administre permisos de usuario, roles de instructores y perfiles de estudiantes.
                                Mantenga la seguridad del ecosistema.
                            </p>
                        </div>
                        <div class="flex items-center text-secondary font-semibold text-sm tracking-wide mt-6">
                            CONFIGURAR USUARIOS
                            <span class="material-symbols-outlined ml-2 text-lg transition-transform duration-300 group-hover:translate-x-2">
                                arrow_forward
                            </span>
                        </div>
                    </div>
                    <div class="absolute -bottom-12 -right-12 w-48 h-48 bg-secondary-fixed/30 rounded-full blur-3xl
                                group-hover:bg-secondary-fixed/50 transition-colors pointer-events-none"></div>
                </a>

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
    <a href="${pageContext.request.contextPath}/perfil"
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/materiales"
       class="flex flex-col items-center justify-center text-slate-400">
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
