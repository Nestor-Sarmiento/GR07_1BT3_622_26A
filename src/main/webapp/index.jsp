
 <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>OlwShare - Encuentra a tu tutor ideal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Manrope:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: { extend: { colors: {
                "surface": "#f7f9fc", "surface-container": "#eceef1",
                "surface-container-low": "#f2f4f7", "surface-container-high": "#e6e8eb",
                "surface-container-highest": "#e0e3e6", "surface-container-lowest": "#ffffff",
                "on-surface": "#191c1e", "on-surface-variant": "#454652",
                "primary": "#24389c", "primary-container": "#3f51b5",
                "primary-fixed": "#dee0ff", "on-primary": "#ffffff",
                "secondary": "#006a60", "secondary-fixed": "#85f6e5",
                "on-secondary-fixed": "#00201c", "outline": "#757684",
                "outline-variant": "#c5c5d4", "on-background": "#191c1e"
            }}}
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body { font-family: 'Inter', sans-serif; }
        h1, h2, h3 { font-family: 'Manrope', sans-serif; }
        .editorial-gradient {
            background: linear-gradient(135deg, #24389c, #3f51b5);
        }
        .glass-panel {
            backdrop-filter: blur(12px);
        }
    </style>
</head>
<body class="bg-surface text-on-surface">

<%-- ── Top Nav ── --%>
<header class="bg-white/80 backdrop-blur-xl sticky top-0 z-50 shadow-[0_20px_40px_rgba(25,28,30,0.08)]">
    <nav class="flex justify-between items-center w-full px-8 py-4 max-w-screen-2xl mx-auto">
        <div class="flex items-center gap-12">
            <span class="text-2xl font-extrabold text-indigo-900 tracking-tighter" style="font-family:'Manrope',sans-serif">OlwShare</span>
            <div class="hidden md:flex items-center gap-8 text-sm font-bold" style="font-family:'Manrope',sans-serif">
                <a class="text-indigo-700 border-b-2 border-indigo-600 transition-all" href="#">Home</a>
                <a class="text-slate-600 hover:text-indigo-600 transition-all" href="#">Tutores</a>
                <a class="text-slate-600 hover:text-indigo-600 transition-all" href="#">Materiales</a>
            </div>
        </div>
        <div class="flex items-center gap-3">
            <%-- Login → va a login.jsp directamente --%>
            <a href="${pageContext.request.contextPath}/login"
               class="px-5 py-2 text-sm font-bold text-slate-600 hover:text-indigo-600 transition-all"
               style="font-family:'Manrope',sans-serif">
                Login
            </a>
            <%-- Register → placeholder por ahora --%>
            <a href="#"
               class="px-5 py-2 text-sm font-bold editorial-gradient text-white rounded-lg shadow-sm hover:opacity-90 transition-all"
               style="font-family:'Manrope',sans-serif">
                Register
            </a>
        </div>
    </nav>
</header>

<main class="flex-grow">

    <%-- ── Hero ── --%>
    <section class="relative pt-20 pb-32 overflow-hidden bg-surface">
        <div class="max-w-7xl mx-auto px-8 relative z-10">
            <div class="grid lg:grid-cols-2 gap-16 items-center">

                <%-- Texto izquierdo --%>
                <div class="space-y-8 max-w-xl">
                    <div class="inline-flex items-center px-3 py-1 rounded-full bg-secondary-fixed text-on-secondary-fixed text-xs font-semibold tracking-wider uppercase">
                        Plataforma Educativa Premium
                    </div>
                    <h1 class="text-5xl md:text-7xl font-extrabold text-on-background leading-[1.1] tracking-tight">
                        Encuentra a tu <span class="text-primary italic">tutor ideal</span>
                    </h1>
                    <p class="text-lg text-on-surface-variant leading-relaxed">
                        Eleva tu aprendizaje con mentores seleccionados por su excelencia académica.
                        Accede a sesiones personalizadas y una red global de conocimiento.
                    </p>
                    <div class="flex flex-wrap gap-4 pt-4">
                        <a href="${pageContext.request.contextPath}/login"
                           class="px-8 py-4 editorial-gradient text-white rounded-lg font-bold text-lg shadow-xl hover:shadow-indigo-200 transition-all active:scale-95"
                           style="font-family:'Manrope',sans-serif">
                            Comenzar ahora
                        </a>
                        <a href="${pageContext.request.contextPath}/login"
                           class="px-8 py-4 bg-surface-container-highest text-primary rounded-lg font-bold text-lg hover:bg-surface-container transition-all active:scale-95"
                           style="font-family:'Manrope',sans-serif">
                            Iniciar sesión
                        </a>
                    </div>
                    <div class="flex items-center gap-6 pt-6 opacity-50">
                        <span class="font-bold text-sm tracking-widest uppercase" style="font-family:'Manrope',sans-serif">Avalado por:</span>
                        <div class="flex gap-4">
                            <span class="material-symbols-outlined">school</span>
                            <span class="material-symbols-outlined">auto_stories</span>
                            <span class="material-symbols-outlined">architecture</span>
                        </div>
                    </div>
                </div>

                <%-- Card derecha --%>
                <div class="relative">
                    <div class="absolute inset-0 bg-primary/5 rounded-[2rem] rotate-3 translate-x-4"></div>
                    <div class="relative rounded-[2rem] overflow-hidden shadow-2xl bg-surface-container-lowest p-8 space-y-6">
                        <div class="flex items-center gap-4 p-5 bg-surface-container-low rounded-2xl">
                            <div class="w-12 h-12 rounded-full bg-indigo-100 flex items-center justify-center">
                                <span class="material-symbols-outlined text-primary">person</span>
                            </div>
                            <div>
                                <p class="font-bold text-on-surface" style="font-family:'Manrope',sans-serif">Dr. Elena Rodríguez</p>
                                <p class="text-xs text-on-surface-variant">Cálculo & Álgebra · ⭐ 4.9</p>
                            </div>
                            <div class="ml-auto">
                                <span class="material-symbols-outlined text-secondary" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">verified</span>
                            </div>
                        </div>
                        <div class="flex items-center gap-4 p-5 bg-surface-container-low rounded-2xl">
                            <div class="w-12 h-12 rounded-full bg-teal-50 flex items-center justify-center">
                                <span class="material-symbols-outlined text-secondary">person</span>
                            </div>
                            <div>
                                <p class="font-bold text-on-surface" style="font-family:'Manrope',sans-serif">Marco Villavicencio</p>
                                <p class="text-xs text-on-surface-variant">Programación & Datos · ⭐ 4.8</p>
                            </div>
                            <div class="ml-auto">
                                <span class="material-symbols-outlined text-secondary" style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">verified</span>
                            </div>
                        </div>
                        <div class="grid grid-cols-3 gap-4 pt-2">
                            <div class="text-center p-4 bg-primary/5 rounded-xl">
                                <p class="text-2xl font-extrabold text-primary" style="font-family:'Manrope',sans-serif">500+</p>
                                <p class="text-xs text-on-surface-variant mt-1">Tutores</p>
                            </div>
                            <div class="text-center p-4 bg-secondary/5 rounded-xl">
                                <p class="text-2xl font-extrabold text-secondary" style="font-family:'Manrope',sans-serif">10k+</p>
                                <p class="text-xs text-on-surface-variant mt-1">Sesiones</p>
                            </div>
                            <div class="text-center p-4 bg-primary/5 rounded-xl">
                                <p class="text-2xl font-extrabold text-primary" style="font-family:'Manrope',sans-serif">4.9★</p>
                                <p class="text-xs text-on-surface-variant mt-1">Valoración</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%-- Decoración de fondo --%>
        <div class="absolute top-0 right-0 w-[600px] h-[600px] bg-primary/5 rounded-full blur-[100px] -translate-y-1/4 translate-x-1/4 pointer-events-none"></div>
        <div class="absolute bottom-0 left-0 w-[400px] h-[400px] bg-secondary/5 rounded-full blur-[80px] pointer-events-none"></div>
    </section>

    <%-- ── Features ── --%>
    <section class="py-24 bg-surface-container-low">
        <div class="max-w-7xl mx-auto px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-extrabold text-on-background mb-4">¿Por qué OlwShare?</h2>
                <p class="text-on-surface-variant text-lg max-w-2xl mx-auto">
                    Todo lo que necesitas para aprender y enseñar en un solo lugar.
                </p>
            </div>
            <div class="grid md:grid-cols-3 gap-8">
                <div class="bg-surface-container-lowest p-8 rounded-2xl shadow-sm">
                    <div class="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center mb-6">
                        <span class="material-symbols-outlined text-primary">person_search</span>
                    </div>
                    <h3 class="text-xl font-bold text-on-surface mb-3">Tutores verificados</h3>
                    <p class="text-on-surface-variant text-sm leading-relaxed">
                        Cada tutor pasa por un proceso de verificación académica para garantizar la calidad de las sesiones.
                    </p>
                </div>
                <div class="bg-surface-container-lowest p-8 rounded-2xl shadow-sm">
                    <div class="w-12 h-12 bg-secondary/10 rounded-xl flex items-center justify-center mb-6">
                        <span class="material-symbols-outlined text-secondary">menu_book</span>
                    </div>
                    <h3 class="text-xl font-bold text-on-surface mb-3">Material académico</h3>
                    <p class="text-on-surface-variant text-sm leading-relaxed">
                        Accede a documentos, guías y recursos compartidos por la comunidad de estudiantes y tutores.
                    </p>
                </div>
                <div class="bg-surface-container-lowest p-8 rounded-2xl shadow-sm">
                    <div class="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center mb-6">
                        <span class="material-symbols-outlined text-primary">event_note</span>
                    </div>
                    <h3 class="text-xl font-bold text-on-surface mb-3">Sesiones flexibles</h3>
                    <p class="text-on-surface-variant text-sm leading-relaxed">
                        Agenda sesiones según tu disponibilidad. Aprende a tu ritmo con seguimiento personalizado.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <%-- ── CTA Final ── --%>
    <section class="py-24 bg-surface">
        <div class="max-w-3xl mx-auto px-8 text-center">
            <h2 class="text-4xl font-extrabold text-on-background mb-6">
                ¿Listo para mejorar tu rendimiento académico?
            </h2>
            <p class="text-on-surface-variant text-lg mb-10">
                Únete a miles de estudiantes que ya están aprendiendo con los mejores tutores.
            </p>
            <a href="${pageContext.request.contextPath}/login"
               class="inline-flex items-center gap-3 px-10 py-5 editorial-gradient text-white rounded-xl font-bold text-lg shadow-xl hover:shadow-indigo-200 transition-all active:scale-95"
               style="font-family:'Manrope',sans-serif">
                <span>Empezar gratis</span>
                <span class="material-symbols-outlined">arrow_forward</span>
            </a>
        </div>
    </section>
</main>

<%-- ── Footer ── --%>
<footer class="w-full py-12 border-t border-slate-100 bg-slate-50">
    <div class="flex flex-col md:flex-row justify-between items-center px-12 max-w-7xl mx-auto gap-8">
        <div class="flex flex-col items-center md:items-start gap-2">
            <span class="font-extrabold uppercase text-slate-900" style="font-family:'Manrope',sans-serif">OlwShare</span>
            <span class="text-xs text-slate-400">© 2025 OlwShare. Plataforma educativa colaborativa.</span>
        </div>
        <div class="flex gap-6">
            <a class="text-slate-400 hover:text-indigo-500 text-xs transition-opacity" href="#">Términos de servicio</a>
            <a class="text-slate-400 hover:text-indigo-500 text-xs transition-opacity" href="#">Privacidad</a>
            <a class="text-slate-400 hover:text-indigo-500 text-xs transition-opacity" href="#">Soporte</a>
        </div>
    </div>
</footer>

</body>
</html>
