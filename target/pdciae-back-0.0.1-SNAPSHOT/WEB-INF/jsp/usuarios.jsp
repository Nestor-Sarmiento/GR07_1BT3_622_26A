<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<title>Usuarios</title>
</head>
<body>
<h2>Usuarios</h2>

<form method="post" action="${pageContext.request.contextPath}/usuarios">
	<input type="text" name="email" placeholder="Email" required />
	<input type="text" name="nombre" placeholder="Nombre" required />
	<input type="text" name="apellido" placeholder="Apellido" required />
	<input type="password" name="password" placeholder="Password" required />
	<span>Rol fijo: ADMIN</span>
	<button type="submit">Guardar</button>
</form>

<table border="1" cellpadding="6">
	<thead>
	<tr>
		<th>ID</th>
		<th>Email</th>
		<th>Nombre</th>
		<th>Apellido</th>
		<th>Rol</th>
		<th>Estado</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach var="u" items="${usuarios}">
		<tr>
			<td>${u.id_usuario}</td>
			<td>${u.email}</td>
			<td>${u.nombre}</td>
			<td>${u.apellido}</td>
			<td>${u.rol}</td>
			<td>${u.estado}</td>
		</tr>
	</c:forEach>
	</tbody>
</table>

<p><a href="${pageContext.request.contextPath}/index.jsp">Volver</a></p>
</body>
</html>

