<<<<<<< HEAD
# pdciae-back
PLATAFORMA DIGITAL COLABORATIVA PARA EL INTERCAMBIO ACADÉMICO ENTRE ESTUDIANTES

## Stack actual

- Maven WAR (sin Spring Boot)
- Servlet + JSP (Jakarta EE)
- ORM con JPA (Hibernate)
- Base de datos de ejemplo H2 en memoria

## Ejecutar validaciones

```powershell
mvn clean test
mvn clean package
```

## Despliegue

1. Genera el WAR con Maven.
2. Despliega `target/pdciae-back-0.0.1-SNAPSHOT.war` en Tomcat/Jetty.
3. Abre la app y navega a:
   - `/index.jsp`
   - `/usuarios`
   - `/documentos`
   - `/health`

=======
# GR07_1BT3_622_26A
>>>>>>> upstream/main
