<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: perfil-tutor.jsp
     Servlet: PerfilTutorServlet → GET|POST /tutor/perfil
     Session: usuarioLogueado (Rol.TUTOR)
     Atributos: carreras, materiasPorCarreraJson, tutorPerfil, flashOk, flashError
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Configuración de Perfil - OwlShare</title>
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
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
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
    <div class="px-4 mt-auto space-y-1">
        <%-- Mi Perfil (activo) --%>
        <a href="${pageContext.request.contextPath}/tutor/perfil"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">settings</span>
            Mi Perfil
        </a>
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
                <span class="material-symbols-outlined text-primary">settings</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Configuración de Perfil
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${requestScope.tutorPerfil.nombre}"/></strong>
            </span>
            <button class="p-2 text-slate-500 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">notifications</span>
            </button>
            <a href="${pageContext.request.contextPath}/logout"
               class="p-2 text-slate-600 hover:bg-red-50 hover:text-red-500 rounded-full transition-colors">
                <span class="material-symbols-outlined">logout</span>
            </a>
            <div class="h-8 w-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
                <c:out value="${requestScope.tutorPerfil.nombre.substring(0,1).toUpperCase()}"/>
            </div>
        </div>
    </header>

    <%-- Contenido --%>
    <div class="flex-1 p-6 md:p-10">
        <div class="max-w-3xl w-full mx-auto space-y-10">

            <%-- Título de página --%>
            <div>
                <h2 class="text-4xl font-extrabold text-primary tracking-tight mb-2">Configuración de Perfil</h2>
                <p class="text-on-surface-variant text-lg leading-relaxed">Gestiona tu información académica y personal.</p>
            </div>

            <c:if test="${not empty flashOk}">
                <div class="rounded-xl bg-green-50 border border-green-200 text-green-900 px-4 py-3 text-sm font-medium">
                    <c:out value="${flashOk}"/>
                </div>
            </c:if>
            <c:if test="${not empty flashError}">
                <div class="rounded-xl bg-red-50 border border-red-200 text-red-900 px-4 py-3 text-sm font-medium">
                    <c:out value="${flashError}"/>
                </div>
            </c:if>

            <%-- ── Sección 1: Información Actual ── --%>
            <section>
                <div class="flex items-center gap-2 mb-5 text-primary">
                    <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">badge</span>
                    <h3 class="text-xl font-bold">Información Actual</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="bg-surface-container-low p-6 rounded-xl border border-outline-variant/10">
                        <span class="text-xs font-semibold uppercase tracking-widest text-on-surface-variant mb-2 block">Nombre Actual</span>
                        <p class="text-lg font-semibold text-on-surface">
                            <c:out value="${requestScope.tutorPerfil.nombre}"/>
                            <c:if test="${not empty requestScope.tutorPerfil.apellido}">
                                <c:out value=" ${requestScope.tutorPerfil.apellido}"/>
                            </c:if>
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

            <%-- ── Sección 2: Actualizar Perfil ── --%>
            <section class="bg-surface-container-lowest p-8 rounded-xl border border-outline-variant/10 shadow-sm">
                <div class="flex items-center gap-2 mb-6 text-primary">
                    <span class="material-symbols-outlined">edit_square</span>
                    <h3 class="text-xl font-bold">Actualizar Perfil</h3>
                </div>
                <form action="${pageContext.request.contextPath}/tutor/perfil" method="post" class="max-w-xl">
                    <input type="hidden" name="accion" value="nombre"/>
                    <label class="block text-sm font-semibold text-on-surface-variant mb-2" for="new_name">
                        Nuevo Nombre de Cuenta
                    </label>
                    <input id="new_name" name="nombre" type="text"
                           placeholder="Ej. Juan Pérez García"
                           value="<c:out value="${requestScope.tutorPerfil.nombre}"/>"
                           class="w-full bg-surface-container-high border-none rounded-lg p-4 text-on-surface
                                  focus:ring-2 focus:ring-primary/30 transition-all mb-6"/>
                    <button type="submit"
                            class="flex items-center gap-2 bg-primary text-on-primary font-semibold
                                   px-6 py-3 rounded-lg hover:opacity-90 active:scale-95 transition-all shadow-sm">
                        <span class="material-symbols-outlined text-lg">save_as</span>
                        Actualizar Datos Personales
                    </button>
                </form>
            </section>

            <%-- ── Semestre académico (define el tope de materias que puede dar) ── --%>
            <section class="bg-surface-container-lowest p-8 rounded-xl border border-outline-variant/10 shadow-sm">
                <div class="flex items-center gap-2 mb-6 text-primary">
                    <span class="material-symbols-outlined">calendar_month</span>
                    <h3 class="text-xl font-bold">Semestre que cursas</h3>
                </div>
                <p class="text-sm text-on-surface-variant mb-4 max-w-xl">
                    Solo puedes registrar como tutorías las asignaturas de <strong>semestres anteriores</strong> al que cursas
                    (ej. si estás en 5.º, hasta 4.º).
                </p>
                <form action="${pageContext.request.contextPath}/tutor/perfil" method="post" class="max-w-xl flex flex-col sm:flex-row gap-3 items-end">
                    <input type="hidden" name="accion" value="semestre"/>
                    <div class="flex-1 w-full">
                        <label class="block text-sm font-semibold text-on-surface-variant mb-2" for="selectSemestrePerfil">Semestre actual</label>
                        <select id="selectSemestrePerfil" name="semestre" required
                                class="w-full bg-surface-container-high border-none rounded-lg p-4 text-on-surface
                                       focus:ring-2 focus:ring-primary/30 transition-all cursor-pointer appearance-none">
                            <option value="">— Selecciona —</option>
                            <c:forEach var="sem" items="${semestres}">
                                <option value="${sem.name()}"
                                    <c:if test="${not empty requestScope.tutorPerfil.semestre and requestScope.tutorPerfil.semestre == sem}">selected="selected"</c:if>>
                                    <c:out value="${sem.nombre}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit"
                            class="shrink-0 flex items-center gap-2 bg-secondary-container text-on-secondary-container font-semibold
                                   px-6 py-3 rounded-lg hover:opacity-90 transition-all shadow-sm whitespace-nowrap">
                        <span class="material-symbols-outlined text-lg">save</span>
                        Guardar semestre
                    </button>
                </form>
            </section>

            <%-- ── Sección 3: Carrera y materias relacionadas (por plan FIS) ── --%>
            <section class="bg-surface-container-lowest p-8 rounded-xl border border-outline-variant/10 shadow-sm">
                <div class="flex items-center gap-2 mb-6 text-primary">
                    <span class="material-symbols-outlined">school</span>
                    <h3 class="text-xl font-bold">Materias relacionadas</h3>
                </div>
                <div class="max-w-xl">
                    <label class="block text-sm font-semibold text-on-surface-variant mb-2" for="selectCarreraPerfil">
                        Carrera (plan de estudios) <span class="text-error">*</span>
                    </label>
                    <div class="relative mb-6">
                        <select id="selectCarreraPerfil"
                                class="w-full bg-surface-container-high border-none rounded-lg p-4 text-on-surface
                                       focus:ring-2 focus:ring-primary/30 transition-all cursor-pointer appearance-none pr-10">
                            <option value="">— Selecciona tu carrera —</option>
                            <c:forEach var="car" items="${carreras}">
                                <option value="${car.name()}"
                                    <c:if test="${not empty requestScope.tutorPerfil and requestScope.tutorPerfil.carrera == car}">selected="selected"</c:if>>
                                    <c:out value="${car.nombre}"/>
                                </option>
                            </c:forEach>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-on-surface-variant pointer-events-none">
                            expand_more
                        </span>
                    </div>
                    <p class="text-xs text-on-surface-variant mb-4">
                        Las materias dependen de tu <strong>carrera</strong> y del <strong>semestre</strong> guardado arriba (solo niveles ya cursados).
                    </p>

                    <%-- Chips de materias seleccionadas --%>
                    <div id="chipsContainer" class="flex flex-wrap gap-3 mb-5 min-h-[2.5rem]">
                    </div>

                    <label class="block text-sm font-semibold text-on-surface-variant mb-2">
                        Añadir materia
                    </label>
                    <div class="relative mb-6">
                        <select id="selectMateria"
                                class="w-full bg-surface-container-high border-none rounded-lg p-4 text-on-surface
                                       focus:ring-2 focus:ring-primary/30 transition-all cursor-pointer appearance-none pr-10">
                            <option value="">— Primero elige carrera —</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-on-surface-variant pointer-events-none">
                            expand_more
                        </span>
                    </div>

                    <form id="formMaterias" action="${pageContext.request.contextPath}/tutor/perfil" method="post" class="hidden">
                        <input type="hidden" name="accion" value="materias"/>
                        <input type="hidden" name="carrera" id="inputCarreraPayload" value=""/>
                        <input type="hidden" name="materias" id="inputMateriasPayload" value=""/>
                    </form>

                    <%-- Guardar materias --%>
                    <button type="button" id="btnGuardarMaterias" onclick="guardarMaterias()"
                            class="flex items-center gap-2 bg-primary text-on-primary font-semibold
                                   px-6 py-3 rounded-lg hover:opacity-90 active:scale-95 transition-all shadow-sm">
                        <span class="material-symbols-outlined text-lg">save</span>
                        Guardar materias
                    </button>
                </div>
            </section>

            <%-- ── Sección 4: Descripción ── --%>
            <section class="bg-surface-container-lowest p-8 rounded-xl border border-outline-variant/10 shadow-sm">
                <div class="flex items-center gap-2 mb-6 text-primary">
                    <span class="material-symbols-outlined">description</span>
                    <h3 class="text-xl font-bold">Descripción</h3>
                </div>
                <form id="formDescripcion" action="${pageContext.request.contextPath}/tutor/perfil" method="post" class="max-w-xl">
                    <input type="hidden" name="accion" value="bio"/>
                    <label class="block text-sm font-semibold text-on-surface-variant mb-2" for="bio">
                        Biografía Profesional <span class="text-error">*</span>
                    </label>
                    <textarea id="bio" name="bio" required rows="6"
                              placeholder="Escribe un breve resumen sobre tu trayectoria académica y experiencia profesional..."
                              class="w-full bg-surface-container-high border-none rounded-lg p-4 text-on-surface
                                     focus:ring-2 focus:ring-primary/30 transition-all resize-none mb-1"><c:out value="${requestScope.tutorPerfil.descripcionProfesional}"/></textarea>
                    <p id="bioError" class="hidden text-xs text-error font-semibold mb-3">
                        La descripción es obligatoria.
                    </p>
                    <p class="text-xs text-on-surface-variant mb-6">
                        Este resumen será visible en tu perfil público para los estudiantes.
                    </p>
                    <button type="submit" id="btnDescripcion"
                            class="flex items-center gap-2 bg-primary text-on-primary font-semibold
                                   px-6 py-3 rounded-lg hover:opacity-90 active:scale-95 transition-all shadow-sm">
                        <span class="material-symbols-outlined text-lg">save</span>
                        Guardar descripción
                    </button>
                </form>
            </section>

        </div>
    </div>

    <footer class="p-8 text-center text-slate-400 text-xs font-medium tracking-widest uppercase">
        © 2025 OlwShare · Plataforma Educativa Colaborativa
    </footer>
</main>

<script type="application/json" id="materiasPorCarreraJson"><c:out value="${materiasPorCarreraJson}" escapeXml="false"/></script>
<script type="application/json" id="initialCarreraJson"><c:choose><c:when test="${not empty requestScope.tutorPerfil.carrera}">"<c:out value="${requestScope.tutorPerfil.carrera.name()}"/>"</c:when><c:otherwise>null</c:otherwise></c:choose></script>
<c:choose>
    <c:when test="${empty requestScope.tutorPerfil or empty requestScope.tutorPerfil.codigosMateriaRelacionadas}">
        <script type="application/json" id="initialMateriasJson">[]</script>
    </c:when>
    <c:otherwise>
        <script type="application/json" id="initialMateriasJson">[<c:forEach var="cod" items="${requestScope.tutorPerfil.codigosMateriaRelacionadas}" varStatus="st">"<c:out value="${cod}"/>"<c:if test="${!st.last}">,</c:if></c:forEach>]</script>
    </c:otherwise>
</c:choose>

<script>
    const tutorSemestreTopeExclusivo = <c:choose><c:when test="${not empty requestScope.tutorPerfil.semestre}">${requestScope.tutorPerfil.semestre.numero}</c:when><c:otherwise>null</c:otherwise></c:choose>;
    const materiasPorCarrera = JSON.parse(document.getElementById('materiasPorCarreraJson').textContent);
    const selectCarrera = document.getElementById('selectCarreraPerfil');
    const selectMateria = document.getElementById('selectMateria');
    const chipsContainer = document.getElementById('chipsContainer');
    const selectedMaterias = new Set();

    function chipId(codigo) {
        return 'chip-' + codigo.replace(/[^a-zA-Z0-9]/g, '_');
    }

    function hintOpt(text) {
        const h = document.createElement('option');
        h.value = '';
        h.disabled = true;
        h.textContent = text;
        selectMateria.appendChild(h);
    }

    function refillMateriaSelect(carreraName) {
        selectMateria.innerHTML = '<option value="">— Seleccionar materia —</option>';
        if (!carreraName || !materiasPorCarrera[carreraName]) {
            hintOpt('— Primero elige tu carrera arriba —');
            return;
        }
        if (tutorSemestreTopeExclusivo == null) {
            hintOpt('— Primero guarda tu semestre en la sección anterior —');
            return;
        }
        if (tutorSemestreTopeExclusivo <= 1) {
            hintOpt('— En 1.er semestre no puedes ofrecer materias —');
            return;
        }
        const list = materiasPorCarrera[carreraName].slice().filter(function (m) {
            return m.semestre < tutorSemestreTopeExclusivo;
        }).sort(function (a, b) {
            if (a.semestre !== b.semestre) return a.semestre - b.semestre;
            return a.nombre.localeCompare(b.nombre);
        });
        if (list.length === 0) {
            hintOpt('— No hay materias de semestres anteriores —');
            return;
        }
        list.forEach(function (m) {
            const opt = document.createElement('option');
            opt.value = m.codigo;
            opt.setAttribute('data-nombre', m.nombre);
            opt.textContent = m.nombre + ' — ' + m.codigo;
            selectMateria.appendChild(opt);
        });
    }

    function addChip(codigo, nombre) {
        const chip = document.createElement('div');
        chip.id = chipId(codigo);
        chip.className = 'flex items-center gap-2 text-white px-3 py-2 rounded-lg text-sm font-semibold transition-all';
        chip.style.backgroundColor = '#56C7E6';
        const sp = document.createElement('span');
        sp.textContent = nombre;
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'ml-1 text-white/70 hover:text-white font-bold text-base leading-none';
        btn.textContent = '\u00d7';
        btn.addEventListener('click', function () {
            selectedMaterias.delete(codigo);
            chip.remove();
        });
        chip.appendChild(sp);
        chip.appendChild(btn);
        chipsContainer.appendChild(chip);
    }

    selectCarrera.addEventListener('change', function () {
        selectedMaterias.clear();
        chipsContainer.innerHTML = '';
        refillMateriaSelect(this.value);
    });

    selectMateria.addEventListener('change', function () {
        const opt = this.options[this.selectedIndex];
        if (!opt.value) return;
        const codigo = opt.value;
        const nombre = opt.getAttribute('data-nombre') || codigo;
        this.value = '';
        if (selectedMaterias.has(codigo)) return;
        selectedMaterias.add(codigo);
        addChip(codigo, nombre);
    });

    (function initPerfilMaterias() {
        try {
            const carreraIni = JSON.parse(document.getElementById('initialCarreraJson').textContent);
            if (carreraIni && selectCarrera.querySelector('option[value="' + carreraIni + '"]')) {
                selectCarrera.value = carreraIni;
            }
        } catch (e) { /* ignore */ }
        refillMateriaSelect(selectCarrera.value);
        try {
            const codigos = JSON.parse(document.getElementById('initialMateriasJson').textContent || '[]');
            codigos.forEach(function (codigo) {
                if (!codigo || selectedMaterias.has(codigo)) return;
                selectedMaterias.add(codigo);
                const opt = selectMateria.querySelector('option[value="' + codigo + '"]');
                const nombre = opt ? (opt.getAttribute('data-nombre') || codigo) : codigo;
                addChip(codigo, nombre);
            });
        } catch (e) { /* ignore */ }
    })();

    function guardarMaterias() {
        if (tutorSemestreTopeExclusivo === null) {
            alert('Primero guarda tu semestre en la sección anterior para filtrar las materias que puedes dar.');
            return;
        }
        document.getElementById('inputMateriasPayload').value = Array.from(selectedMaterias).join(',');
        document.getElementById('inputCarreraPayload').value = selectCarrera.value || '';
        document.getElementById('formMaterias').submit();
    }

    /* ── Validación descripción (antes de enviar al servidor) ── */
    document.getElementById('formDescripcion').addEventListener('submit', function (e) {
        const bio = document.getElementById('bio').value.trim();
        const errorMsg = document.getElementById('bioError');
        if (!bio) {
            e.preventDefault();
            errorMsg.classList.remove('hidden');
            document.getElementById('bio').focus();
            return;
        }
        errorMsg.classList.add('hidden');
    });
</script>

</body>
</html>
