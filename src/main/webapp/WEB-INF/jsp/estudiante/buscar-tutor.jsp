<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- =============================================
     Vista: buscar-tutor.jsp
     Servlet: BuscarTutorServlet → GET /estudiante/buscar-tutor
     Session: usuarioLogueado (Rol.ESTUDIANTE)
     Atributos: materias (MateriaFIS[])
     ============================================= --%>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Buscar Tutor - OwlShare</title>
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
        <%-- Inicio --%>
        <a href="${pageContext.request.contextPath}/estudiante/dashboard"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 hover:bg-slate-100 transition-all">
            <span class="material-symbols-outlined">home</span>
            Inicio
        </a>
        <%-- Buscar Tutor (activo) --%>
        <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-indigo-700 font-bold border-r-4 border-indigo-600 bg-indigo-50/50 transition-all">
            <span class="material-symbols-outlined">search</span>
            Buscar Tutor
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
                <span class="material-symbols-outlined text-primary">search</span>
            </div>
            <span class="hidden md:block text-xl font-bold text-indigo-900 tracking-tight" style="font-family:'Manrope',sans-serif">
                Buscar Tutor
            </span>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-slate-600 hidden sm:block">
                Hola, <strong><c:out value="${sessionScope.usuarioLogueado.nombre}"/></strong>
            </span>
            <button class="p-2 text-slate-500 hover:bg-indigo-50 rounded-full transition-colors">
                <span class="material-symbols-outlined">notifications</span>
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
    <div class="flex-1 p-6 md:p-10 pb-20 md:pb-10">
        <div class="max-w-5xl w-full mx-auto space-y-10">

            <%-- Hero --%>
            <section>
                <h2 class="text-4xl md:text-5xl font-extrabold tracking-tight text-on-surface mb-3 leading-tight">
                    Encuentra a tu <span class="text-primary italic">Tutor Ideal</span>
                </h2>
                <p class="text-lg text-on-surface-variant font-medium max-w-2xl leading-relaxed">
                    Explora nuestra red de expertos académicos listos para potenciar tu aprendizaje.
                </p>
            </section>

            <%-- Selector de materia --%>
            <section class="bg-surface-container-lowest rounded-2xl p-8 shadow-sm">
                <label class="block text-sm font-semibold text-on-surface-variant uppercase tracking-widest mb-3">
                    Selecciona una materia
                </label>
                <div class="relative flex items-center bg-surface-container-high rounded-xl overflow-hidden
                            focus-within:ring-2 focus-within:ring-primary/30 focus-within:bg-surface-container-lowest
                            focus-within:shadow-lg transition-all">
                    <span class="material-symbols-outlined text-on-surface-variant ml-4 shrink-0">school</span>
                    <select name="materia"
                            class="w-full bg-transparent border-none focus:ring-0 py-5 px-4 text-on-surface
                                   text-base appearance-none cursor-pointer">
                        <option disabled selected value="">Seleccionar materia (ej. Programación I, Álgebra Lineal...)</option>
                        <c:forEach var="materia" items="${materias}">
                            <option value="${materia.name()}">
                                <c:out value="${materia.nombre}"/> — <c:out value="${materia.id}"/>
                            </option>
                        </c:forEach>
                    </select>
                    <span class="material-symbols-outlined text-on-surface-variant mr-4 shrink-0">expand_more</span>
                </div>

                <%-- Sugerencias (materias reales de MateriaFIS) --%>
                <div class="flex flex-wrap items-center gap-3 mt-5">
                    <span class="text-[10px] font-bold text-primary uppercase tracking-widest">SUGERENCIAS:</span>
                    <button type="button"
                            class="bg-surface-container-high hover:bg-primary-fixed/40 text-on-surface
                                   px-4 py-1.5 rounded-full text-xs font-medium transition-colors">
                        Programación I
                    </button>
                    <button type="button"
                            class="bg-surface-container-high hover:bg-primary-fixed/40 text-on-surface
                                   px-4 py-1.5 rounded-full text-xs font-medium transition-colors">
                        Álgebra Lineal
                    </button>
                    <button type="button"
                            class="bg-surface-container-high hover:bg-primary-fixed/40 text-on-surface
                                   px-4 py-1.5 rounded-full text-xs font-medium transition-colors">
                        Inteligencia Artificial
                    </button>
                    <button type="button"
                            class="bg-surface-container-high hover:bg-primary-fixed/40 text-on-surface
                                   px-4 py-1.5 rounded-full text-xs font-medium transition-colors">
                        Fundamentos de Bases de Datos
                    </button>
                </div>
            </section>

            <%-- Sección de resultados (visual, sin datos reales aún) --%>
            <section>
                <h3 class="text-xl font-bold text-on-surface mb-6 flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary">group</span>
                    Tutores disponibles
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

                    <%-- Tarjeta visual 1 --%>
                    <div class="group bg-surface-container-lowest rounded-xl overflow-hidden shadow-sm
                                hover:shadow-lg transition-all duration-300 flex flex-col">
                        <div class="h-3 bg-primary-container"></div>
                        <div class="p-6 flex flex-col flex-grow">
                            <div class="flex items-center gap-4 mb-4">
                                <div class="w-14 h-14 rounded-full bg-primary-fixed flex items-center justify-center
                                            text-on-primary-fixed font-bold text-2xl shrink-0">
                                    E
                                </div>
                                <div>
                                    <h4 class="font-bold text-on-surface text-base">Dra. Elena Martínez</h4>
                                    <p class="text-xs text-on-surface-variant">Doctora en Ciencias Exactas</p>
                                </div>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-5">
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Álgebra Lineal
                                </span>
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Cálculo en una Variable
                                </span>
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Ec. Diferenciales
                                </span>
                            </div>
                            <div class="mt-auto">
                                <a href="${pageContext.request.contextPath}/estudiante/tutor/perfil"
                                   class="flex items-center justify-center gap-2 w-full py-2.5
                                          bg-primary/5 hover:bg-primary hover:text-on-primary text-primary
                                          rounded-lg text-sm font-bold transition-all duration-300">
                                    Ver Perfil
                                </a>
                            </div>
                        </div>
                    </div>

                    <%-- Tarjeta visual 2 --%>
                    <div class="group bg-surface-container-lowest rounded-xl overflow-hidden shadow-sm
                                hover:shadow-lg transition-all duration-300 flex flex-col">
                        <div class="h-3 bg-secondary-container"></div>
                        <div class="p-6 flex flex-col flex-grow">
                            <div class="flex items-center gap-4 mb-4">
                                <div class="w-14 h-14 rounded-full bg-secondary-container flex items-center justify-center
                                            text-on-secondary-container font-bold text-2xl shrink-0">
                                    C
                                </div>
                                <div>
                                    <h4 class="font-bold text-on-surface text-base">Carlos Ruiz</h4>
                                    <p class="text-xs text-on-surface-variant">Ingeniero en Computación</p>
                                </div>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-5">
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Programación I
                                </span>
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Programación II
                                </span>
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Inteligencia Artificial
                                </span>
                            </div>
                            <div class="mt-auto">
                                <a href="${pageContext.request.contextPath}/estudiante/tutor/perfil"
                                   class="flex items-center justify-center gap-2 w-full py-2.5
                                          bg-primary/5 hover:bg-primary hover:text-on-primary text-primary
                                          rounded-lg text-sm font-bold transition-all duration-300">
                                    Ver Perfil
                                </a>
                            </div>
                        </div>
                    </div>

                    <%-- Tarjeta visual 3 --%>
                    <div class="group bg-surface-container-lowest rounded-xl overflow-hidden shadow-sm
                                hover:shadow-lg transition-all duration-300 flex flex-col">
                        <div class="h-3" style="background-color:#dee0ff"></div>
                        <div class="p-6 flex flex-col flex-grow">
                            <div class="flex items-center gap-4 mb-4">
                                <div class="w-14 h-14 rounded-full flex items-center justify-center
                                            font-bold text-2xl shrink-0"
                                     style="background-color:#dee0ff; color:#00105c">
                                    S
                                </div>
                                <div>
                                    <h4 class="font-bold text-on-surface text-base">Sofía Valladares</h4>
                                    <p class="text-xs text-on-surface-variant">Magister en Lingüística</p>
                                </div>
                            </div>
                            <div class="flex flex-wrap gap-2 mb-5">
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Comunicación Oral y Escrita
                                </span>
                                <span class="bg-secondary-container/40 text-on-secondary-container px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider">
                                    Liderazgo y Comunicación
                                </span>
                            </div>
                            <div class="mt-auto">
                                <a href="${pageContext.request.contextPath}/estudiante/tutor/perfil"
                                   class="flex items-center justify-center gap-2 w-full py-2.5
                                          bg-primary/5 hover:bg-primary hover:text-on-primary text-primary
                                          rounded-lg text-sm font-bold transition-all duration-300">
                                    Ver Perfil
                                </a>
                            </div>
                        </div>
                    </div>

                </div>
            </section>

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
       class="flex flex-col items-center justify-center text-slate-400">
        <span class="material-symbols-outlined">home</span>
        <span class="text-[10px] font-bold mt-1 uppercase tracking-tighter">Inicio</span>
    </a>
    <a href="${pageContext.request.contextPath}/estudiante/buscar-tutor"
       class="flex flex-col items-center justify-center text-indigo-700">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">search</span>
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
