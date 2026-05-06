<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: subir-material.jsp
     Servlet: SubirMaterialServlet → POST /tutor/subir
     Session: usuarioLogueado (Rol.TUTOR)
     Atributos de request: error (String)
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Subir Material - OlwShare</title>
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
        .field-error { display: none; }
        .field-error.visible { display: flex; }
        input.invalid, select.invalid, textarea.invalid { ring: 2px; --tw-ring-color: #ba1a1a; outline: 2px solid #ba1a1a; }
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
        <a href="${pageContext.request.contextPath}/tutor/materiales"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">folder_open</span>
            Mis Materiales
        </a>
        <%-- Subir Material (activo) --%>
        <a href="${pageContext.request.contextPath}/tutor/subir"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
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
                <span class="material-symbols-outlined text-primary">upload_file</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Publicar nuevo material
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${sessionScope.usuarioLogueado.nombre}"/></strong>
            </span>
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
        <div class="max-w-4xl w-full mx-auto space-y-6">

            <%-- Encabezado de sección --%>
            <div class="mb-2">
                <h2 class="text-3xl font-extrabold text-on-surface tracking-tight">Publicar nuevo material</h2>
                <p class="text-on-surface-variant mt-1">Comparte tus conocimientos con la comunidad académica.</p>
            </div>

            <%-- Mensaje de error del servidor --%>
            <c:if test="${not empty error}">
                <div class="flex items-center gap-3 bg-red-50 border border-error/30 text-error px-5 py-4 rounded-xl">
                    <span class="material-symbols-outlined">error</span>
                    <span class="text-sm font-semibold"><c:out value="${error}"/></span>
                </div>
            </c:if>

            <%-- Formulario --%>
            <div class="bg-surface-container-lowest rounded-xl p-8 md:p-10 shadow-sm border border-outline-variant/10">

                <%-- Identidad del creador --%>
                <div class="flex items-center gap-3 p-4 bg-surface-container-low rounded-lg mb-8">
                    <span class="material-symbols-outlined text-primary">account_circle</span>
                    <div>
                        <span class="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant block">Identidad del Creador</span>
                        <span class="text-on-surface font-semibold">
                            Autor: <c:out value="${sessionScope.usuarioLogueado.nombre}"/>
                            <c:if test="${not empty sessionScope.usuarioLogueado.apellido}">
                                <c:out value=" ${sessionScope.usuarioLogueado.apellido}"/>
                            </c:if>
                        </span>
                    </div>
                </div>

                <form id="formSubir"
                      action="${pageContext.request.contextPath}/tutor/subir"
                      method="post"
                      enctype="multipart/form-data"
                      novalidate
                      class="space-y-8">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

                        <%-- Columna izquierda --%>
                        <div class="space-y-6">

                            <%-- Título --%>
                            <div class="flex flex-col gap-1">
                                <label for="titulo" class="text-sm font-bold text-on-surface px-1">
                                    Título del material <span class="text-error">*</span>
                                </label>
                                <input id="titulo" name="titulo" type="text"
                                       placeholder="Ej. Guía Completa: Derivadas e Integrales"
                                       class="w-full bg-surface-container-highest border-0 rounded-t-lg py-3 px-4 focus:ring-2 focus:ring-primary transition-all text-on-surface placeholder:text-on-surface-variant/40"/>
                                <div id="err-titulo" class="field-error items-center gap-1 text-error text-xs px-1 mt-0.5">
                                    <span class="material-symbols-outlined text-sm">error</span>
                                    El título es obligatorio.
                                </div>
                            </div>

                            <%-- Categoría --%>
                            <div class="flex flex-col gap-1">
                                <label for="nombreMateria" class="text-sm font-bold text-on-surface px-1">Categoría académica</label>
                                <select id="nombreMateria" name="nombreMateria"
                                        class="w-full bg-surface-container-highest border-0 rounded-t-lg py-3 px-4 focus:ring-2 focus:ring-primary text-on-surface appearance-none">
                                    <c:forEach var="cat" items="${categorias}">
                                        <option value="${cat.nombre}"><c:out value="${cat.nombre}"/></option>
                                    </c:forEach>
                                </select>
                            </div>

                            <%-- Materia --%>
                            <div class="flex flex-col gap-1">
                                <label for="materia" class="text-sm font-bold text-on-surface px-1">Materia</label>
                                <select id="materia" name="materia"
                                        class="w-full bg-surface-container-highest border-0 rounded-t-lg py-3 px-4 focus:ring-2 focus:ring-primary text-on-surface appearance-none">
                                    <option value="">-- Seleccionar materia --</option>
                                    <c:forEach var="m" items="${materias}">
                                        <option value="${m}"><c:out value="${m.nombre}"/> (<c:out value="${m.id}"/>)</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <%-- Precio --%>
                            <div class="flex flex-col gap-1">
                                <label for="costo" class="text-sm font-bold text-on-surface px-1">
                                    Precio sugerido (USD) <span class="text-error">*</span>
                                </label>
                                <div class="relative">
                                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant/60 font-bold">$</span>
                                    <input id="costo" name="costo" type="number" step="0.01" min="0"
                                           placeholder="0.00"
                                           class="w-full bg-surface-container-highest border-0 rounded-t-lg py-3 pl-8 pr-4 focus:ring-2 focus:ring-primary text-on-surface placeholder:text-on-surface-variant/40"/>
                                </div>
                                <div id="err-costo" class="field-error items-center gap-1 text-error text-xs px-1 mt-0.5">
                                    <span class="material-symbols-outlined text-sm">error</span>
                                    El precio es obligatorio y debe ser mayor o igual a 0.
                                </div>
                            </div>

                        </div>

                        <%-- Columna derecha --%>
                        <div class="space-y-6">

                            <%-- Descripción --%>
                            <div class="flex flex-col gap-1">
                                <label for="descripcion" class="text-sm font-bold text-on-surface px-1">
                                    Descripción del contenido <span class="text-error">*</span>
                                </label>
                                <textarea id="descripcion" name="descripcion" rows="8"
                                          placeholder="Explica brevemente de qué trata este material, a quién va dirigido y qué temas cubre..."
                                          class="w-full bg-surface-container-highest border-0 rounded-t-lg py-3 px-4 focus:ring-2 focus:ring-primary text-on-surface placeholder:text-on-surface-variant/40 resize-none"></textarea>
                                <div id="err-descripcion" class="field-error items-center gap-1 text-error text-xs px-1 mt-0.5">
                                    <span class="material-symbols-outlined text-sm">error</span>
                                    La descripción es obligatoria.
                                </div>
                            </div>

                        </div>
                    </div>

                    <%-- Dropzone PDF --%>
                    <div class="flex flex-col gap-1">
                        <label class="text-sm font-bold text-on-surface px-1">
                            Archivo del material (.pdf) <span class="text-error">*</span>
                        </label>
                        <label for="archivo"
                               id="dropzone"
                               class="border-2 border-dashed border-outline-variant/40 rounded-xl p-10 flex flex-col items-center justify-center bg-surface hover:bg-surface-container-high transition-colors cursor-pointer group">
                            <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                                <span class="material-symbols-outlined text-primary text-3xl">picture_as_pdf</span>
                            </div>
                            <p id="dropzone-label" class="text-on-surface font-semibold">Arrastra y suelta tu archivo PDF aquí</p>
                            <p class="text-on-surface-variant text-sm mt-1">O haz clic para seleccionar desde tu ordenador</p>
                            <p class="text-[10px] text-on-surface-variant/50 uppercase tracking-widest mt-4">Tamaño máximo: 25 MB</p>
                            <input id="archivo" name="archivo" type="file" accept=".pdf,application/pdf" class="hidden"/>
                        </label>
                        <div id="err-archivo" class="field-error items-center gap-1 text-error text-xs px-1 mt-0.5">
                            <span class="material-symbols-outlined text-sm">error</span>
                            Debes adjuntar un archivo PDF.
                        </div>
                    </div>

                    <%-- Acciones --%>
                    <div class="pt-8 flex items-center justify-end gap-6 border-t border-outline-variant/15">
                        <a href="${pageContext.request.contextPath}/tutor/dashboard"
                           class="text-on-surface-variant font-bold hover:text-primary transition-colors">
                            Cancelar
                        </a>
                        <button type="submit"
                                class="flex items-center gap-2 bg-primary text-white px-10 py-4 rounded-lg font-bold shadow-lg hover:scale-[1.02] transition-all active:scale-95">
                            <span class="material-symbols-outlined">publish</span>
                            Subir material
                        </button>
                    </div>

                </form>
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
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">folder_open</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Materiales</span>
    </a>
    <a href="${pageContext.request.contextPath}/tutor/subir"
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined">upload_file</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Subir</span>
    </a>
    <a href="${pageContext.request.contextPath}/tutor/sesiones"
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">event</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Sesiones</span>
    </a>
</nav>

<script>
    (function () {
        const form = document.getElementById('formSubir');
        const fields = {
            titulo:      { el: document.getElementById('titulo'),      err: document.getElementById('err-titulo') },
            descripcion: { el: document.getElementById('descripcion'), err: document.getElementById('err-descripcion') },
            costo:       { el: document.getElementById('costo'),       err: document.getElementById('err-costo') },
            archivo:     { el: document.getElementById('archivo'),     err: document.getElementById('err-archivo') }
        };

        function showError(key, show) {
            const { el, err } = fields[key];
            err.classList.toggle('visible', show);
            if (show) {
                el.style.outline = '2px solid #ba1a1a';
            } else {
                el.style.outline = '';
            }
        }

        function validateTitulo()      { return fields.titulo.el.value.trim() !== ''; }
        function validateDescripcion() { return fields.descripcion.el.value.trim() !== ''; }
        function validateCosto()       { const v = fields.costo.el.value; return v !== '' && parseFloat(v) >= 0; }
        function validateArchivo()     { return fields.archivo.el.files.length > 0; }

        Object.keys(fields).forEach(key => {
            const input = fields[key].el;
            const event = (key === 'archivo') ? 'change' : 'input';
            input.addEventListener(event, () => {
                const validators = { titulo: validateTitulo, descripcion: validateDescripcion, costo: validateCosto, archivo: validateArchivo };
                showError(key, !validators[key]());
            });
        });

        form.addEventListener('submit', function (e) {
            const checks = {
                titulo:      validateTitulo(),
                descripcion: validateDescripcion(),
                costo:       validateCosto(),
                archivo:     validateArchivo()
            };
            const allValid = Object.entries(checks).every(([key, ok]) => { showError(key, !ok); return ok; });
            if (!allValid) {
                e.preventDefault();
                const firstErr = Object.keys(checks).find(k => !checks[k]);
                if (firstErr) fields[firstErr].el.focus();
            }
        });

        // Actualizar label del dropzone al seleccionar archivo
        fields.archivo.el.addEventListener('change', function () {
            const label = document.getElementById('dropzone-label');
            label.textContent = this.files.length > 0 ? this.files[0].name : 'Arrastra y suelta tu archivo PDF aquí';
        });
    })();
</script>

</body>
</html>
