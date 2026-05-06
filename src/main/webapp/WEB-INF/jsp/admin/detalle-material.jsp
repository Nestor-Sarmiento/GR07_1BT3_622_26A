<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: detalle-material.jsp
     Servlet: MaterialDetalleServlet → GET /material/detalle?id=X
     Atributos del request:
       - material: Material (el material a revisar)
     Session: adminLogueado
     ============================================= --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Detalle de Material - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
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
                "on-primary-fixed-variant": "#293ca0", "on-primary-container": "#cacfff",
                "secondary": "#006a60", "secondary-container": "#85f6e5",
                "on-secondary-container": "#007166",
                "tertiary-fixed": "#ffdcc6", "on-tertiary-fixed-variant": "#713700",
                "outline": "#757684", "outline-variant": "#c5c5d4",
                "error": "#ba1a1a", "error-container": "#ffdad6"
            }}}
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; vertical-align:middle; }
        body { font-family:'Inter', sans-serif; }
        h1,h2,h3 { font-family:'Manrope', sans-serif; }
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
        <h2 class="text-lg font-extrabold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">OlwShare</h2>
        <p class="text-xs text-slate-500">Administración</p>
    </div>
    <nav class="flex-1 space-y-1 px-4">
        <a href="${pageContext.request.contextPath}/dashboardAdmin"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">dashboard</span>
            Panel Principal
        </a>
        <%-- Gestión de Materiales activo --%>
        <a href="${pageContext.request.contextPath}/materiales"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">library_books</span>
            Gestión de Materiales
        </a>
         <a href="${pageContext.request.contextPath}/usuarios"
            class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
             <span class="material-symbols-outlined">manage_accounts</span>
             Gestión de Cuentas
         </a>
         <a href="${pageContext.request.contextPath}/estudiantes"
            class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
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
<main class="ml-64 min-h-screen bg-surface flex flex-col">

    <%-- Top Nav --%>
    <header class="w-full sticky top-0 z-40 bg-white/80 backdrop-blur-md shadow-sm h-16 flex justify-between items-center px-8">
        <div class="flex items-center gap-4">
            <span class="text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Editorial Intelligence
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                <c:out value="${sessionScope.adminLogueado.nombre}"/>
                <c:out value="${sessionScope.adminLogueado.apellido}"/>
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

    <%-- Contenido --%>
    <div class="p-10 max-w-7xl mx-auto w-full space-y-8">

        <%-- Mensajes flash --%>
        <c:if test="${not empty requestScope.mensaje}">
            <div class="flex items-center gap-3 bg-green-50 text-green-700 text-sm font-medium px-4 py-3 rounded-lg">
                <span class="material-symbols-outlined text-base">check_circle</span>
                <c:out value="${requestScope.mensaje}"/>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="flex items-center gap-3 bg-red-50 text-red-700 text-sm font-medium px-4 py-3 rounded-lg">
                <span class="material-symbols-outlined text-base">error</span>
                <c:out value="${requestScope.error}"/>
            </div>
        </c:if>

        <%-- Breadcrumb + título --%>
        <div>
            <nav class="flex text-xs text-slate-500 mb-1 gap-2">
                <a href="${pageContext.request.contextPath}/materiales"
                   class="hover:underline hover:text-primary transition-colors">Materiales</a>
                <span>/</span>
                <span class="text-indigo-600 font-semibold">Detalle del Recurso</span>
            </nav>
            <h1 class="text-3xl font-extrabold text-indigo-900 tracking-tight">Detalle de Material</h1>
        </div>

        <%-- Grid principal --%>
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <%-- ── Columna izquierda: datos del material ── --%>
            <div class="lg:col-span-2 space-y-6">

                <%-- Card principal --%>
                <div class="bg-surface-container-lowest rounded-2xl p-8 shadow-sm border border-outline-variant/30">
                    <div class="flex items-start justify-between mb-6">
                        <div class="flex items-center gap-4">
                            <div class="w-14 h-14 rounded-xl bg-indigo-50 flex items-center justify-center text-indigo-600">
                                <span class="material-symbols-outlined text-3xl">description</span>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                                        <c:out value="${material.titulo}"/>
                                </h2>
                                <p class="text-sm text-slate-500">
                                        ID: <c:out value="${material.id}"/>
                                </p>
                                    <p class="text-xs text-slate-500 mt-1">
                                        Archivo: <c:out value="${material.titulo}"/>
                                    </p>
                            </div>
                        </div>
                        <%-- Badge de estado --%>
                            <span id="estadoBadge" class="px-4 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest border border-outline-variant/20 flex items-center gap-2
                                ${material.estado == 'PENDIENTE' ? 'bg-orange-50 text-orange-700' : (material.estado == 'APROBADO' ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700')}">
                                <span id="estadoPunto" class="w-2 h-2 rounded-full ${material.estado == 'PENDIENTE' ? 'bg-orange-500' : (material.estado == 'APROBADO' ? 'bg-green-500' : 'bg-red-500')} "></span>
                                <span id="estadoTexto"><c:out value="${material.estado}"/></span>
                            </span>
                    </div>

                    <div class="space-y-6">
                        <%-- Descripción --%>
                        <div>
                            <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 mb-2">Descripción</h3>
                            <p class="text-on-surface/80 leading-relaxed">
                                <c:out value="${material.descripcion}"/>
                            </p>
                        </div>

                        <%-- Grid de metadatos --%>
                        <div class="grid grid-cols-2 lg:grid-cols-4 gap-8 pt-6 border-t border-outline-variant/20">
                            <div>
                                <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 mb-2">ID Materia</h3>
                                <div class="text-on-surface font-semibold text-sm">
                                    <c:out value="${material.idMateria}"/>
                                </div>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 mb-2">Materia</h3>
                                <span class="px-3 py-1 rounded bg-secondary-container text-on-secondary-container text-xs font-bold uppercase tracking-wider">
                                    <c:out value="${material.nombreMateria}"/>
                                </span>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 mb-2">Tipo de Archivo</h3>
                                <div class="flex items-center gap-2 text-on-surface font-semibold text-sm">
                                    <span class="material-symbols-outlined text-indigo-500">picture_as_pdf</span>
                                    <c:out value="${material.tipoArchivo}"/>
                                </div>
                            </div>
                            <div>
                                <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 mb-2">Costo</h3>
                                <div class="flex items-center gap-2 text-on-surface font-semibold text-sm">
                                    <span class="material-symbols-outlined text-indigo-500">payments</span>
                                    $<c:out value="${material.costo}"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Previsualización --%>
                <div class="bg-surface-container-low rounded-2xl p-8 border-2 border-dashed border-outline-variant/50
                            flex flex-col items-center justify-center min-h-[200px] text-center">
                    <span class="material-symbols-outlined text-5xl text-slate-300 mb-4">visibility_off</span>
                    <p class="text-slate-500 font-semibold" style="font-family:'Manrope',sans-serif">
                        Previsualización no disponible para este formato
                    </p>
                    <button class="mt-4 px-6 py-2 rounded-full bg-white text-indigo-600 font-bold text-xs shadow-sm
                                   border border-indigo-100 hover:bg-indigo-50 transition-colors">
                        Descargar para revisión
                    </button>
                </div>

                <%-- Motivo de Rechazo (se muestra tras confirmar rechazo) --%>
                <div id="seccionMotivoRechazo"
                     class="hidden bg-red-50 border border-red-200 rounded-2xl p-6 space-y-3"
                     role="region" aria-live="polite">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 rounded-full bg-red-100 flex items-center justify-center text-red-600 shrink-0">
                            <span class="material-symbols-outlined text-base">cancel</span>
                        </div>
                        <h3 class="text-sm font-bold uppercase tracking-widest text-red-700"
                            style="font-family:'Manrope',sans-serif">
                            Motivo de Rechazo
                        </h3>
                    </div>
                    <p id="textoMotivoRechazo"
                       class="text-sm text-red-800 leading-relaxed pl-12"></p>
                </div>
            </div>

            <%-- ── Columna derecha: acciones ── --%>
            <div class="space-y-6">
                <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-sm border border-outline-variant/30">
                    <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 mb-6">Información de Envío</h3>

                    <div class="flex items-center gap-4 mb-6">
                        <div class="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-slate-500">
                            <span class="material-symbols-outlined">person</span>
                        </div>
                        <div>
                            <p class="text-sm font-bold text-indigo-900" style="font-family:'Manrope',sans-serif">
                                <c:out value="${material.usuario}"/>
                            </p>
                            <p class="text-[10px] text-slate-500 uppercase tracking-wider">
                                Enviado el
                                <c:out value="${material.fechaEnvio}"/>
                            </p>
                        </div>
                    </div>

                    <%-- Botones Aceptar / Rechazar
                         POST /material/accion
                         Parámetros: id, accion = ACEPTAR | RECHAZAR
                    --%>
                    <div class="flex flex-col gap-3">
                        <form action="${pageContext.request.contextPath}/material/accion" method="post">
                            <input type="hidden" name="id" value="${material.id}"/>
                            <input type="hidden" name="accion" value="ACEPTAR"/>
                            <button type="submit"
                                    class="w-full py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white
                                           font-bold text-sm shadow-sm transition-all active:scale-[0.98]
                                           flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-lg">check_circle</span>
                                Aceptar
                            </button>
                        </form>

                        <form id="formRechazar" action="${pageContext.request.contextPath}/material/accion" method="post">
                            <input type="hidden" name="id" value="${material.id}"/>
                            <input type="hidden" name="accion" value="RECHAZAR"/>
                            <input type="hidden" name="motivo" id="motivoRechazoCampo"/>
                            <button type="button" onclick="abrirModalRechazo()"
                                    class="w-full py-2.5 rounded-xl border border-indigo-100 bg-white text-indigo-600
                                           font-bold text-sm hover:bg-indigo-50 transition-all active:scale-[0.98]
                                           flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-lg">cancel</span>
                                Rechazar
                            </button>
                        </form>
                    </div>
                </div>

                <%-- Volver --%>
                <a href="${pageContext.request.contextPath}/materiales"
                   class="flex items-center gap-2 text-sm text-on-surface-variant hover:text-primary transition-colors">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    Volver a Gestión de Materiales
                </a>
            </div>
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

<%-- ── Modal: Motivo de Rechazo ── --%>
<div id="modalRechazo"
     class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm"
     role="dialog" aria-modal="true" aria-labelledby="modalRechazoTitulo">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md mx-4 p-6 space-y-5">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-full bg-red-50 flex items-center justify-center text-red-600 shrink-0">
                <span class="material-symbols-outlined">cancel</span>
            </div>
            <h2 id="modalRechazoTitulo" class="text-lg font-bold text-on-surface" style="font-family:'Manrope',sans-serif">
                Rechazar Material
            </h2>
        </div>

        <p class="text-sm text-slate-500">
            Indica el motivo por el que se rechaza este material. Este mensaje será registrado.
        </p>

        <div>
            <label for="motivoRechazoTexto" class="block text-xs font-bold uppercase tracking-widest text-slate-400 mb-2">
                Motivo del rechazo <span class="text-red-500">*</span>
            </label>
            <textarea id="motivoRechazoTexto" rows="4"
                      placeholder="Escribe el motivo aquí..."
                      class="w-full rounded-xl border border-outline-variant/60 bg-surface px-4 py-3 text-sm
                             text-on-surface resize-none focus:outline-none focus:ring-2 focus:ring-indigo-500
                             focus:border-transparent transition"></textarea>
            <p id="motivoRechazoError"
               class="hidden mt-1.5 text-xs text-red-600 flex items-center gap-1">
                <span class="material-symbols-outlined text-sm">error</span>
                El motivo no puede estar vacío.
            </p>
        </div>

        <div class="flex gap-3 pt-1">
            <button type="button" onclick="cerrarModalRechazo()"
                    class="flex-1 py-2.5 rounded-xl border border-outline-variant/60 bg-white text-on-surface-variant
                           font-bold text-sm hover:bg-surface-container transition-all active:scale-[0.98]">
                Cancelar
            </button>
            <button type="button" onclick="confirmarRechazo()"
                    class="flex-1 py-2.5 rounded-xl bg-red-600 hover:bg-red-700 text-white
                           font-bold text-sm shadow-sm transition-all active:scale-[0.98]
                           flex items-center justify-center gap-2">
                <span class="material-symbols-outlined text-lg">check</span>
                Confirmar Rechazo
            </button>
        </div>
    </div>
</div>

<script>
    var urlMateriales = '${pageContext.request.contextPath}/materiales';

    function abrirModalRechazo() {
        document.getElementById('motivoRechazoTexto').value = '';
        document.getElementById('motivoRechazoError').classList.add('hidden');
        document.getElementById('modalRechazo').classList.remove('hidden');
        document.getElementById('motivoRechazoTexto').focus();
    }

    function cerrarModalRechazo() {
        document.getElementById('modalRechazo').classList.add('hidden');
    }

    function confirmarRechazo() {
        var motivo = document.getElementById('motivoRechazoTexto').value.trim();
        if (!motivo) {
            document.getElementById('motivoRechazoError').classList.remove('hidden');
            return;
        }
        document.getElementById('motivoRechazoError').classList.add('hidden');
        document.getElementById('motivoRechazoCampo').value = motivo;

        // Actualizar badge de estado a RECHAZADO
        var badge = document.getElementById('estadoBadge');
        badge.classList.remove('bg-orange-50', 'text-orange-700', 'bg-green-50', 'text-green-700');
        badge.classList.add('bg-red-50', 'text-red-700');
        var punto = document.getElementById('estadoPunto');
        punto.classList.remove('bg-orange-500', 'bg-green-500');
        punto.classList.add('bg-red-500');
        document.getElementById('estadoTexto').textContent = 'RECHAZADO';

        // Mostrar sección de motivo y cerrar modal
        document.getElementById('textoMotivoRechazo').textContent = motivo;
        document.getElementById('seccionMotivoRechazo').classList.remove('hidden');
        document.getElementById('seccionMotivoRechazo').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        cerrarModalRechazo();

        // Redirigir al listado tras breve pausa para que el usuario vea el cambio
        setTimeout(function() {
            window.location.href = urlMateriales;
        }, 1800);
    }

    document.getElementById('modalRechazo').addEventListener('click', function(e) {
        if (e.target === this) cerrarModalRechazo();
    });

    document.getElementById('motivoRechazoTexto').addEventListener('input', function() {
        if (this.value.trim()) {
            document.getElementById('motivoRechazoError').classList.add('hidden');
        }
    });
</script>

</body>
</html>
