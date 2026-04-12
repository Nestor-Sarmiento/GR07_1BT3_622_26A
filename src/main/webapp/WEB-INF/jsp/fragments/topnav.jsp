<%-- =============================================
     Fragment: topnav.jsp
     Uso: <%@ include file="/WEB-INF/jsp/fragments/topnav.jsp" %>
     Variable esperada en session: adminLogueado (Usuario)
     ============================================= --%>
<%@ page import="schemas.Usuario" %>
<%
    Usuario adminNav = (Usuario) session.getAttribute("adminLogueado");
    String nombreAdmin = (adminNav != null) ? adminNav.getNombre() : "Admin";
%>
<nav class="fixed top-0 left-0 right-0 h-16 z-50 bg-white/80 backdrop-blur-xl shadow-sm flex justify-between items-center px-8">
    <div class="text-xl font-bold tracking-tight text-indigo-900" style="font-family:'Manrope',sans-serif">
        OlwShare
    </div>
    <div class="flex items-center gap-4">
        <span class="text-sm text-slate-600 font-medium">Hola, <%= nombreAdmin %></span>
        <a href="${pageContext.request.contextPath}/perfil"
           class="flex items-center gap-2 text-slate-500 hover:text-indigo-600 transition-colors">
            <span class="material-symbols-outlined">settings</span>
        </a>
        <div class="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-sm">
            <%= nombreAdmin.substring(0,1).toUpperCase() %>
        </div>
    </div>
</nav>
