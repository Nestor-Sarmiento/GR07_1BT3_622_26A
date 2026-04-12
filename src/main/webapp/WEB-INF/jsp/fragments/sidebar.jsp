<%-- =============================================
     Fragment: sidebar.jsp
     Uso: <%@ include file="/WEB-INF/jsp/fragments/sidebar.jsp" %>
     Variable esperada: activeMenu (String) — valores: "cuentas", "materiales"
     ============================================= --%>
<aside class="fixed left-0 top-0 h-full w-64 pt-4 bg-slate-100 flex flex-col gap-2 text-sm z-40">
    <div class="px-6 py-4 mb-4 mt-16">
        <h2 class="text-lg font-black text-indigo-800" style="font-family:'Manrope',sans-serif">Admin Panel</h2>
        <p class="text-xs text-slate-500">OlwShare</p>
    </div>
    <nav class="flex-1 space-y-1 px-2">
        <a href="${pageContext.request.contextPath}/usuarios"
           class="flex items-center gap-3 px-4 py-3 rounded-lg transition-all hover:translate-x-1
                  ${'cuentas' eq activeMenu ? 'bg-white text-indigo-700 font-bold shadow-sm' : 'text-slate-500 hover:text-indigo-600'}">
            <span class="material-symbols-outlined">manage_accounts</span>
            <span>Gestión de Cuentas</span>
        </a>
        <%-- Puedes agregar más items de menú aquí --%>
    </nav>
    <div class="mt-auto pb-8 px-2">
        <a href="${pageContext.request.contextPath}/logout"
           class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-500 hover:text-indigo-600 transition-all">
            <span class="material-symbols-outlined">logout</span>
            <span>Cerrar Sesión</span>
        </a>
    </div>
</aside>
