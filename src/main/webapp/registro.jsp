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

            <%-- Rol --%>
            <div class="md:col-span-2">
                <label class="block text-sm font-bold text-indigo-900 mb-2">Rol deseado *</label>
                <select name="rol" required
                        class="w-full rounded-xl border-slate-200 focus:border-indigo-500 focus:ring focus:ring-indigo-200 transition-all text-sm outline-none p-3 border">
                    <option value="" disabled selected>Selecciona un rol</option>
                    <option value="ESTUDIANTE">Estudiante</option>
                    <option value="TUTOR">Tutor</option>
                </select>
            </div>
        </div>

        <button type="submit"
                class="w-full bg-primary text-white font-bold py-3.5 rounded-xl hover:bg-primary-container transition-all shadow-lg shadow-indigo-200 mt-4">
            Registrarse
        </button>

        <p class="text-center text-sm text-slate-500">
            ¿Ya tienes una cuenta?
            <a href="${pageContext.request.contextPath}/login" class="text-primary font-bold hover:underline">Inicia sesión</a>
        </p>
    </form>
</div>

</body>
</html>

