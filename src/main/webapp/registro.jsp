<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Registro - OlwShare</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: {
                "primary": "#24389c", "primary-container": "#3f51b5", "on-primary": "#ffffff",
                "surface": "#f7f9fc", "on-surface": "#191c1e", "error": "#ba1a1a"
            }}}
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        h1, h2 { font-family: 'Manrope', sans-serif; }
    </style>
</head>
<body class="bg-surface text-on-surface min-h-screen flex items-center justify-center p-4">

<div class="max-w-2xl w-full bg-white rounded-2xl shadow-xl p-8 md:p-12">
    <div class="text-center mb-10">
        <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-indigo-50 text-primary mb-4">
            <span class="material-symbols-outlined text-4xl">person_add</span>
        </div>
        <h1 class="text-3xl font-extrabold text-indigo-900 tracking-tight">Crea tu cuenta</h1>
        <p class="text-slate-500 mt-2">Únete a la comunidad de OlwShare</p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-6 flex items-center gap-3 bg-red-50 text-red-700 text-sm font-medium px-4 py-3 rounded-lg border border-red-100">
            <span class="material-symbols-outlined text-base">error</span>
            <c:out value="${error}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/registro" method="POST" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <%-- Email --%>
            <div class="md:col-span-2">
                <label class="block text-sm font-bold text-indigo-900 mb-2">Correo Electrónico *</label>
                <input type="email" name="email" required
                       class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border"
                       placeholder="ejemplo@correo.com">
            </div>

            <%-- Password --%>
            <div class="md:col-span-2">
                <label class="block text-sm font-bold text-indigo-900 mb-2">Contraseña *</label>
                <input type="password" name="password" required
                       class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border"
                       placeholder="••••••••">
            </div>

            <%-- Nombre --%>
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Primer Nombre *</label>
                <input type="text" name="nombre" required
                       class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border"
                       placeholder="Nombre">
            </div>

            <%-- Segundo Nombre --%>
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Segundo Nombre</label>
                <input type="text" name="segundoNombre"
                       class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border"
                       placeholder="Segundo Nombre">
            </div>

            <%-- Apellido --%>
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Primer Apellido *</label>
                <input type="text" name="apellido" required
                       class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border"
                       placeholder="Apellido">
            </div>

            <%-- Segundo Apellido --%>
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Segundo Apellido</label>
                <input type="text" name="segundoApellido"
                       class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border"
                       placeholder="Segundo Apellido">
            </div>

            <%-- Semestre --%>
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Semestre</label>
                <select name="semestre"
                        class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border">
                    <option value="">-- Selecciona tu semestre --</option>
                    <c:forEach var="sem" items="${semestres}">
                        <option value="${sem.name()}"><c:out value="${sem.nombre}"/></option>
                    </c:forEach>
                </select>
            </div>

            <%-- Carrera --%>
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Carrera</label>
                <select name="carrera"
                        class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border">
                    <option value="">-- Selecciona tu carrera --</option>
                    <c:forEach var="car" items="${carreras}">
                        <option value="${car.name()}"><c:out value="${car.nombre}"/></option>
                    </c:forEach>
                </select>
            </div>

            <%-- Rol --%>
            <div class="md:col-span-2">
                <label class="block text-sm font-bold text-indigo-900 mb-2">Rol deseado *</label>
                <select id="rolSelect" name="rol" required
                        class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border">
                    <option value="" disabled selected>Selecciona un rol</option>
                    <option value="ESTUDIANTE">Estudiante</option>
                    <option value="TUTOR">Tutor</option>
                </select>
            </div>
        </div>

        <%-- Sección de materias (solo visible para TUTOR) --%>
        <div id="seccionMaterias" class="hidden space-y-4">
            <div>
                <label class="block text-sm font-bold text-indigo-900 mb-2">Materias relacionadas *</label>

                <%-- Chips seleccionados --%>
                <div id="chipsRegistro" class="flex flex-wrap gap-2 mb-3 min-h-[2rem]"></div>

                <%-- Dropdown de materias --%>
                <select id="selectMateriaRegistro"
                        class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border">
                    <option value="">-- Selecciona una materia --</option>
                    <c:forEach var="materia" items="${materias}">
                        <option value="${materia.name()}" data-nombre="${materia.nombre}">
                            <c:out value="${materia.nombre}"/> (<c:out value="${materia.id}"/>)
                        </option>
                    </c:forEach>
                </select>

                <p id="errorMaterias" class="hidden mt-2 text-sm text-red-600 font-medium flex items-center gap-1">
                    <span class="material-symbols-outlined text-base">error</span>
                    Debes seleccionar al menos una materia.
                </p>
            </div>
        </div>

        <button type="submit" id="btnRegistro"
                class="w-full bg-primary text-white font-bold py-3.5 rounded-xl hover:bg-primary-container transition-all shadow-lg shadow-indigo-200 mt-4">
            Registrarse
        </button>

        <p class="text-center text-sm text-slate-500">
            ¿Ya tienes una cuenta?
            <a href="${pageContext.request.contextPath}/login" class="text-primary font-bold hover:underline">Inicia sesión</a>
        </p>
    </form>
</div>

<script>
    (function () {
        var rolSelect       = document.getElementById('rolSelect');
        var seccionMaterias = document.getElementById('seccionMaterias');
        var selectMateria   = document.getElementById('selectMateriaRegistro');
        var chipsContainer  = document.getElementById('chipsRegistro');
        var errorMaterias   = document.getElementById('errorMaterias');
        var form            = document.querySelector('form');

        var selectedMaterias = new Set();

        rolSelect.addEventListener('change', function () {
            if (this.value === 'TUTOR') {
                seccionMaterias.classList.remove('hidden');
            } else {
                seccionMaterias.classList.add('hidden');
                clearMaterias();
            }
        });

        selectMateria.addEventListener('change', function () {
            var val    = this.value;
            var nombre = this.options[this.selectedIndex].dataset.nombre;
            this.value = '';

            if (!val || selectedMaterias.has(val)) return;

            selectedMaterias.add(val);
            errorMaterias.classList.add('hidden');

            var chip = document.createElement('span');
            chip.className = 'inline-flex items-center gap-1 px-3 py-1 rounded-full text-sm font-semibold text-white';
            chip.style.backgroundColor = '#56C7E6';
            chip.dataset.value = val;

            var hidden = document.createElement('input');
            hidden.type  = 'hidden';
            hidden.name  = 'materias';
            hidden.value = val;
            hidden.id    = 'hidden_' + val;

            var label = document.createElement('span');
            label.textContent = nombre;

            var btn = document.createElement('button');
            btn.type      = 'button';
            btn.className = 'ml-1 text-white/80 hover:text-white font-bold leading-none';
            btn.textContent = '×';
            btn.addEventListener('click', function () {
                selectedMaterias.delete(val);
                chip.remove();
                var h = document.getElementById('hidden_' + val);
                if (h) h.remove();
            });

            chip.appendChild(label);
            chip.appendChild(btn);
            chipsContainer.appendChild(chip);
            form.appendChild(hidden);
        });

        form.addEventListener('submit', function (e) {
            if (rolSelect.value === 'TUTOR' && selectedMaterias.size === 0) {
                e.preventDefault();
                errorMaterias.classList.remove('hidden');
                seccionMaterias.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });

        function clearMaterias() {
            selectedMaterias.forEach(function (val) {
                var h = document.getElementById('hidden_' + val);
                if (h) h.remove();
            });
            selectedMaterias.clear();
            chipsContainer.innerHTML = '';
            errorMaterias.classList.add('hidden');
        }
    })();
</script>
</body>
</html>

