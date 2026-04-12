<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: perfil.jsp
     Servlet: PerfilServlet → GET /perfil
     Atributos en session:
       - adminLogueado: Usuario
     POST /perfil/datos   → primer_nombre, segundo_nombre, primer_apellido, segundo_apellido
     POST /perfil/password → passwordActual, passwordNuevo, passwordConfirm
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Configuración de Perfil - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "background": "#f7f9fc", "surface": "#f7f9fc",
                        "surface-container": "#eceef1", "surface-container-low": "#f2f4f7",
                        "surface-container-high": "#e6e8eb", "surface-container-highest": "#e0e3e6",
                        "surface-container-lowest": "#ffffff", "on-surface": "#191c1e",
                        "on-surface-variant": "#454652", "primary": "#24389c",
                        "primary-container": "#3f51b5", "primary-fixed": "#dee0ff",
                        "on-primary": "#ffffff", "secondary": "#006a60",
                        "outline": "#757684", "outline-variant": "#c5c5d4",
                        "error": "#ba1a1a", "error-container": "#ffdad6"
                    },
                    borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
                    fontFamily: { "headline": ["Manrope"], "body": ["Inter"], "label": ["Inter"] }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        body { font-family: 'Inter', sans-serif; }
        h1, h2, h3 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface antialiased">

<%-- Protección de ruta --%>
<c:if test="${empty sessionScope.adminLogueado}">
    <c:redirect url="/login.jsp"/>
</c:if>

<%-- ── Top Nav ── --%>
<header class="bg-white/80 backdrop-blur-xl fixed top-0 w-full z-50 shadow-sm flex justify-between items-center px-8 h-16">
    <div class="text-xl font-bold tracking-tight text-indigo-900" style="font-family:'Manrope',sans-serif">
        Editorial Intelligence
    </div>
    <div class="flex items-center gap-6">
        <nav class="hidden md:flex gap-8 items-center h-full">
            <a class="text-sm font-medium text-slate-500 hover:text-indigo-600 transition-colors"
               href="${pageContext.request.contextPath}/usuarios">Inicio</a>
            <a class="text-indigo-700 font-bold border-b-2 border-indigo-700 flex items-center gap-1 py-1 px-1 transition-colors hover:bg-slate-50 active:scale-95 duration-200"
               href="${pageContext.request.contextPath}/perfil">
                <span class="material-symbols-outlined">settings</span>
            </a>
        </nav>
        <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
            <c:out value="${sessionScope.adminLogueado.nombre.substring(0,1).toUpperCase()}"/>
        </div>
    </div>
</header>

<div class="flex pt-16">

    <%-- ── Sidebar ── --%>
    <aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-slate-50 py-6 space-y-4 z-50">
        <div class="px-6 mb-4">
            <h2 class="text-lg font-extrabold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">OlwShare</h2>
            <p class="text-xs text-slate-500">Administración</p>
        </div>
        <nav class="flex-1 space-y-1 px-4">
            <a href="${pageContext.request.contextPath}/perfil"
               class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
                <span class="material-symbols-outlined">dashboard</span>
                Mi Perfil
            </a>

            <a href="${pageContext.request.contextPath}/dashboardAdmin"
               class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
                <span class="material-symbols-outlined">dashboard</span>
                Panel Principal
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
    <main class="flex-grow lg:ml-64 p-8 min-h-screen bg-surface-container-low">
        <div class="max-w-4xl mx-auto">

            <%-- Header --%>
            <div class="mb-10">
                <h1 class="text-4xl font-extrabold tracking-tight text-indigo-900 mb-2">Configuración de Perfil</h1>
                <p class="text-on-surface-variant text-lg">Gestiona tu información personal y de seguridad</p>
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

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

                <%-- ── Columna principal ── --%>
                <div class="lg:col-span-8 space-y-6">
                    <div class="bg-surface-container-lowest rounded-xl p-8 shadow-sm">

                        <%-- ══ Sección 1: Datos personales ══ --%>
                        <section class="mb-10">
                            <h2 class="text-xl font-bold text-indigo-900 mb-6 flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">badge</span>
                                Información Actual
                            </h2>

                            <%--
                                POST /perfil/datos
                                Parámetros: primer_nombre, segundo_nombre, primer_apellido, segundo_apellido
                                El servlet actualiza el admin en BD y en session, luego redirect /perfil
                            --%>
                            <form action="${pageContext.request.contextPath}/perfil/datos" method="post" class="space-y-6">

                                <%-- Nombres --%>
                                <div class="bg-surface-container-low p-5 rounded-lg">
                                    <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-3">Nombres</p>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-xs font-medium text-slate-400 mb-1" for="primer_nombre">
                                                Primer nombre
                                            </label>
                                            <input class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2 text-on-surface font-medium focus:ring-2 focus:ring-primary-container outline-none transition-all"
                                                   id="primer_nombre" name="primer_nombre" type="text"
                                                   value="<c:out value='${sessionScope.adminLogueado.nombre}'/>"
                                                   required/>
                                        </div>
                                        <div>
                                            <label class="block text-xs font-medium text-slate-400 mb-1" for="segundo_nombre">
                                                Segundo nombre
                                            </label>
                                            <input class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2 text-on-surface font-medium focus:ring-2 focus:ring-primary-container outline-none transition-all"
                                                   id="segundo_nombre" name="segundo_nombre" type="text"
                                                   value="<c:out value='${sessionScope.adminLogueado.segundoNombre}'/>"/>
                                        </div>
                                    </div>
                                </div>

                                <%-- Apellidos --%>
                                <div class="bg-surface-container-low p-5 rounded-lg">
                                    <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-3">Apellidos</p>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-xs font-medium text-slate-400 mb-1" for="primer_apellido">
                                                Primer apellido
                                            </label>
                                            <input class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2 text-on-surface font-medium focus:ring-2 focus:ring-primary-container outline-none transition-all"
                                                   id="primer_apellido" name="primer_apellido" type="text"
                                                   value="<c:out value='${sessionScope.adminLogueado.apellido}'/>"
                                                   required/>
                                        </div>
                                        <div>
                                            <label class="block text-xs font-medium text-slate-400 mb-1" for="segundo_apellido">
                                                Segundo apellido
                                            </label>
                                            <input class="w-full bg-white border border-outline-variant rounded-lg px-4 py-2 text-on-surface font-medium focus:ring-2 focus:ring-primary-container outline-none transition-all"
                                                   id="segundo_apellido" name="segundo_apellido" type="text"
                                                   value="<c:out value='${sessionScope.adminLogueado.segundoApellido}'/>"/>
                                        </div>
                                    </div>
                                </div>

                                <%-- Correo (solo lectura) --%>
                                <div class="bg-surface-container-low p-5 rounded-lg">
                                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2"
                                           for="email_input">Correo electrónico</label>
                                    <input class="w-full border border-slate-200 rounded-lg px-4 py-2 text-slate-400 font-medium bg-slate-50 cursor-not-allowed"
                                           id="email_input" type="email"
                                           value="<c:out value='${sessionScope.adminLogueado.email}'/>"
                                           readonly/>
                                    <p class="mt-2 text-xs text-slate-400 italic">El correo no se puede modificar desde aquí.</p>
                                </div>

                                <%-- Botón guardar datos --%>
                                <div class="flex pt-2 justify-start">
                                    <button type="submit"
                                            class="h-11 px-8 bg-primary text-white text-sm font-bold rounded-lg hover:bg-primary-container transition-all shadow-sm hover:shadow-md flex items-center gap-2">
                                        <span class="material-symbols-outlined text-sm">save</span>
                                        Actualizar Datos Personales
                                    </button>
                                </div>

                            </form>
                        </section>

                        <%-- ══ Sección 2: Contraseña ══ --%>
                        <section>
                            <h2 class="text-xl font-bold text-indigo-900 mb-6 flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">lock</span>
                                Seguridad
                            </h2>

                            <%--
                                POST /perfil/password
                                Parámetros: passwordActual, passwordNuevo, passwordConfirm
                            --%>
                            <form action="${pageContext.request.contextPath}/perfil/password" method="post" class="space-y-4">

                                <div>
                                    <label class="block text-sm font-medium text-on-surface-variant mb-2" for="passwordActual">
                                        Contraseña actual
                                    </label>
                                    <input class="w-full h-12 bg-surface-container-highest border-0 rounded-lg focus:ring-2 focus:ring-primary-container outline-none transition-all px-4"
                                           id="passwordActual" name="passwordActual" type="password"
                                           placeholder="Tu contraseña actual"/>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-on-surface-variant mb-2" for="passwordNuevo">
                                        Nueva contraseña
                                    </label>
                                    <input class="w-full h-12 bg-surface-container-highest border-0 rounded-lg focus:ring-2 focus:ring-primary-container outline-none transition-all px-4"
                                           id="passwordNuevo" name="passwordNuevo" type="password"
                                           placeholder="Ingresa tu nueva contraseña segura"/>
                                    <p class="mt-2 text-xs text-slate-500 italic">Deja este campo en blanco si no deseas cambiar tu contraseña.</p>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-on-surface-variant mb-2" for="passwordConfirm">
                                        Confirmar nueva contraseña
                                    </label>
                                    <input class="w-full h-12 bg-surface-container-highest border-0 rounded-lg focus:ring-2 focus:ring-primary-container outline-none transition-all px-4"
                                           id="passwordConfirm" name="passwordConfirm" type="password"
                                           placeholder="Repite la nueva contraseña"/>
                                </div>

                                <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-slate-100">
                                    <button type="submit"
                                            class="flex-1 h-12 bg-gradient-to-br from-primary to-primary-container text-white font-bold rounded-lg hover:shadow-lg active:scale-[0.98] transition-all flex items-center justify-center gap-2">
                                        <span class="material-symbols-outlined">save</span>
                                        Guardar nueva contraseña
                                    </button>
                                </div>

                            </form>
                        </section>

                    </div>
                </div>

                <%-- ── Columna lateral ── --%>
                <div class="lg:col-span-4 space-y-6">
                    <div class="bg-indigo-900 rounded-xl p-6 text-white overflow-hidden relative">
                        <div class="relative z-10">
                            <h3 class="font-bold text-lg mb-2">Consejo de Seguridad</h3>
                            <p class="text-sm text-indigo-100 opacity-90 leading-relaxed">
                                Usa contraseñas de al menos 12 caracteres que incluyan símbolos y números para mayor protección.
                            </p>
                        </div>
                        <div class="absolute -bottom-10 -right-10 w-32 h-32 bg-primary-container rounded-full opacity-20"></div>
                    </div>

                    <div class="bg-surface-container-lowest rounded-xl p-6 shadow-sm space-y-3">
                        <h4 class="text-sm font-bold text-slate-400 uppercase tracking-widest">Tu cuenta</h4>
                        <p class="text-sm font-semibold text-indigo-900">
                            <c:out value="${sessionScope.adminLogueado.nombre}"/>
                            <c:out value="${sessionScope.adminLogueado.apellido}"/>
                        </p>
                        <p class="text-xs text-slate-400"><c:out value="${sessionScope.adminLogueado.email}"/></p>
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-indigo-50 text-indigo-700">
                            <span class="material-symbols-outlined text-xs">admin_panel_settings</span>
                            <c:out value="${sessionScope.adminLogueado.rol}"/>
                        </span>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

<%-- Mobile Bottom NavBar --%>
<nav class="md:hidden fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-lg border-t border-slate-100 flex justify-around items-center h-16 px-4 z-50">
    <a href="${pageContext.request.contextPath}/perfil" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/materiales" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">library_books</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Materiales</span>
    </a>
    <a href="${pageContext.request.contextPath}/dashboardAdmin" class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">dashboard</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Cuentas</span>
    </a>
</nav>

</body>
</html>
