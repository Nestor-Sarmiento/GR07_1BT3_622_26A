<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: detalle-visualizar-material-tutor.jsp
     Servlet: DetalleMaterialTutorServlet → GET /tutor/material/detalle
     Session: usuarioLogueado (Rol.TUTOR)
     Atributos de request: material (objeto), o datos de demo si es null
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Detalle de Material - OlwShare</title>
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
                "on-error-container": "#93000a",
                "background": "#f7f9fc"
            }}}
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        body { font-family: 'Inter', sans-serif; }
        h1, h2, h3, h4 { font-family: 'Manrope', sans-serif; }
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
        <%-- Mis Materiales (activo, porque venimos de esa sección) --%>
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
            <a href="${pageContext.request.contextPath}/tutor/materiales"
               class="flex items-center gap-2 text-primary font-semibold hover:opacity-80 transition-all group">
                <span class="material-symbols-outlined group-hover:-translate-x-1 transition-transform">arrow_back</span>
                <span style="font-family:'Manrope',sans-serif">Volver a Mis Materiales</span>
            </a>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${sessionScope.usuarioLogueado.nombre}"/></strong>
            </span>
            <button class="p-2 text-slate-500 hover:bg-indigo-50 rounded-full transition-colors relative">
                <span class="material-symbols-outlined">notifications</span>
                <span class="absolute top-2 right-2 w-2 h-2 bg-error rounded-full"></span>
            </button>
            <button class="p-2 text-slate-500 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">help_outline</span>
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
        <div class="max-w-6xl w-full mx-auto">

            <%-- Encabezado de página --%>
            <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-10">
                <div>
                    <div class="inline-flex items-center gap-2 px-3 py-1 bg-primary/10 text-primary rounded-full text-xs font-bold tracking-wider uppercase mb-4">
                        <span class="material-symbols-outlined text-sm">description</span>
                        Detalle de Recurso
                    </div>
                    <h2 class="text-4xl font-extrabold text-on-surface tracking-tight leading-tight" style="font-family:'Manrope',sans-serif">
                        <c:out value="${not empty material.titulo ? material.titulo : 'Sin título'}"/>
                    </h2>
                </div>

                <%-- Indicador de estado --%>
                <div class="flex flex-col items-start md:items-end gap-2">
                    <span class="text-xs font-bold text-outline/60 uppercase tracking-widest">Estado Actual</span>
                    <c:choose>
                        <c:when test="${material.estado == 'APROBADO'}">
                            <div class="flex items-center gap-3 px-6 py-3 bg-secondary/10 text-secondary rounded-xl">
                                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">check_circle</span>
                                <span class="font-bold text-lg" style="font-family:'Manrope',sans-serif">Aprobado</span>
                            </div>
                        </c:when>
                        <c:when test="${material.estado == 'PENDIENTE'}">
                            <div class="flex items-center gap-3 px-6 py-3 rounded-xl" style="background-color:rgba(108,52,0,0.1);color:#6c3400">
                                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">schedule</span>
                                <span class="font-bold text-lg" style="font-family:'Manrope',sans-serif">En Revisión</span>
                            </div>
                        </c:when>
                        <c:when test="${material.estado == 'RECHAZADO'}">
                            <div class="flex items-center gap-3 px-6 py-3 bg-error-container text-on-error-container rounded-xl">
                                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">cancel</span>
                                <span class="font-bold text-lg" style="font-family:'Manrope',sans-serif">Rechazado</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex items-center gap-3 px-6 py-3 bg-slate-100 text-slate-500 rounded-xl">
                                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">help_outline</span>
                                <span class="font-bold text-lg" style="font-family:'Manrope',sans-serif">Desconocido</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Layout asimétrico: 8/12 izquierda · 4/12 derecha --%>
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

                <%-- Columna principal (izquierda) --%>
                <div class="lg:col-span-8 space-y-8">

                    <%-- Tarjeta de resumen del archivo --%>
                    <div class="bg-surface-container-lowest rounded-xl p-8 shadow-sm border border-outline-variant/10">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <div class="space-y-1">
                                <label class="text-xs font-bold text-outline/60 uppercase tracking-widest">Nombre del archivo</label>
                                <p class="text-lg font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                                    <c:out value="${not empty material.nombreArchivo ? material.nombreArchivo : 'Sin archivo'}"/>
                                </p>
                            </div>
                            <div class="space-y-1">
                                <label class="text-xs font-bold text-outline/60 uppercase tracking-widest">Materia</label>
                                <p class="text-lg font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                                    <c:out value="${not empty material.nombreMateria ? material.nombreMateria : 'Sin materia'}"/>
                                    <span class="text-primary/60 font-normal ml-2 text-base"><c:out value="${material.idMateria}"/></span>
                                </p>
                            </div>
                            <div class="space-y-1">
                                <label class="text-xs font-bold text-outline/60 uppercase tracking-widest">Tipo de Archivo</label>
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-error">description</span>
                                    <p class="text-on-surface font-medium"><c:out value="${not empty material.tipoArchivo ? material.tipoArchivo : 'N/A'}"/></p>
                                </div>
                            </div>
                            <div class="space-y-1">
                                <label class="text-xs font-bold text-outline/60 uppercase tracking-widest">Costo Sugerido</label>
                                <p class="text-2xl font-extrabold text-secondary" style="font-family:'Manrope',sans-serif">
                                    $<span class="cost-value"><c:out value="${not empty material.costo ? material.costo : '0.00'}"/></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <%-- Descripción --%>
                    <div class="bg-surface-container-low rounded-xl p-8 border border-outline-variant/10">
                        <h3 class="text-xl font-bold mb-4 flex items-center gap-2 text-on-surface" style="font-family:'Manrope',sans-serif">
                            <span class="material-symbols-outlined text-primary">notes</span>
                            Descripción Detallada
                        </h3>
                        <div class="text-on-surface-variant leading-relaxed space-y-4">
                            <p><c:out value="${not empty material.descripcion ? material.descripcion : 'Sin descripción disponible.'}"/></p>
                        </div>
                    </div>

                    <%-- Motivo de rechazo (visible solo cuando el estado es RECHAZADO) --%>
                    <c:if test="${material.estado == 'RECHAZADO'}">
                        <div class="bg-error-container/40 rounded-xl p-8 border-l-4 border-error">
                            <div class="flex items-start gap-4">
                                <div class="p-2 bg-error-container rounded-lg text-error flex-shrink-0">
                                    <span class="material-symbols-outlined">report</span>
                                </div>
                                <div>
                                    <h4 class="text-lg font-bold text-on-error-container mb-2" style="font-family:'Manrope',sans-serif">Motivo del Rechazo</h4>
                                    <p class="text-on-error-container/80 leading-relaxed">
                                        <c:out value="${not empty material.motivoRechazo ? material.motivoRechazo : 'No se especificó un motivo.'}"/>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/tutor/subir"
                                       class="mt-6 inline-flex items-center gap-2 px-6 py-2 bg-error text-white rounded-lg font-bold hover:opacity-90 transition-all">
                                        <span class="material-symbols-outlined text-sm">edit</span>
                                        Subir Nueva Versión
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>

                </div>

                <%-- Columna secundaria (derecha) --%>
                <div class="lg:col-span-4 space-y-8">

                    <%-- Tarjeta del autor --%>
                    <div class="bg-surface-container-lowest rounded-xl p-6 shadow-sm border border-outline-variant/10">
                        <h4 class="text-xs font-bold text-outline/60 uppercase tracking-widest mb-6">Autor del Material</h4>
                        <div class="flex items-center gap-4">
                            <div class="w-14 h-14 rounded-full bg-primary-fixed flex items-center justify-center text-primary font-bold text-xl flex-shrink-0" style="font-family:'Manrope',sans-serif">
                                <c:out value="${sessionScope.usuarioLogueado.nombre.substring(0,1).toUpperCase()}"/>
                            </div>
                            <div>
                                <p class="font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                                    <c:out value="${sessionScope.usuarioLogueado.nombre}"/>
                                    <c:if test="${not empty sessionScope.usuarioLogueado.apellido}">
                                        <c:out value=" ${sessionScope.usuarioLogueado.apellido}"/>
                                    </c:if>
                                </p>
                                <p class="text-sm text-on-surface-variant">Tutor · OlwShare</p>
                            </div>
                        </div>
                        <div class="mt-6 pt-6 border-t border-surface-container space-y-3">
                            <div class="flex justify-between items-center text-sm">
                                <span class="text-on-surface-variant">Fecha de subida</span>
                                <span class="font-bold text-on-surface">
                                    <c:out value="${material.fechaEnvio != null ? material.fechaEnvio : 'N/A'}"/>
                                </span>
                            </div>
                            <div class="flex justify-between items-center text-sm">
                                <span class="text-on-surface-variant">Categoría</span>
                                <span class="font-bold text-on-surface">
                                    <c:out value="${not empty material.nombreMateria ? material.nombreMateria : 'General'}"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <%-- Acciones rápidas --%>
                    <div class="bg-surface-container-lowest rounded-xl p-6 shadow-sm border border-outline-variant/10">
                        <h4 class="text-xs font-bold text-outline/60 uppercase tracking-widest mb-4">Acciones</h4>
                        <div class="space-y-3">
                            <a href="${pageContext.request.contextPath}/tutor/subir"
                               class="flex items-center gap-3 w-full px-4 py-3 bg-primary text-white rounded-lg font-bold hover:opacity-90 transition-all">
                                <span class="material-symbols-outlined text-sm">upload_file</span>
                                Subir nueva versión
                            </a>
                            <a href="${pageContext.request.contextPath}/tutor/materiales"
                               class="flex items-center gap-3 w-full px-4 py-3 border border-outline-variant/30 text-on-surface-variant rounded-lg font-semibold hover:bg-surface-container transition-all">
                                <span class="material-symbols-outlined text-sm">arrow_back</span>
                                Volver al listado
                            </a>
                        </div>
                    </div>

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
