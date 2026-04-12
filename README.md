# pdciae-back
PLATAFORMA DIGITAL COLABORATIVA PARA EL INTERCAMBIO ACADÉMICO ENTRE ESTUDIANTES

## Stack actual

- Maven WAR (sin Spring Boot)
- Servlet + JSP (Jakarta EE)
- ORM con JPA (Hibernate)
- PostgreSQL en la nube vía variables de entorno (`DB_URL`, `DB_USER`, `DB_PASSWORD`)

## Configuración de la base de datos

El proyecto lee credenciales desde `.env` o variables de entorno del sistema.

Variables necesarias para Supabase/PostgreSQL:

```powershell
DB_URL=jdbc:postgresql://db.yszzewnynkvmkeygvksh.supabase.co:5432/postgres?sslmode=require
DB_USER=postgres
DB_PASSWORD=owlshare2026
DB_DRIVER=org.postgresql.Driver
HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQLDialect
HIBERNATE_HBM2DDL_AUTO=update
```

## Ejecutar en local

1. Crea el archivo `.env` en la raíz del proyecto con las variables anteriores.
2. Ejecuta:

```powershell
mvn clean test
mvn clean package
```

## Despliegue

1. Crea una base PostgreSQL administrada en Supabase.
2. Copia la URL JDBC al `.env` o al panel de variables de entorno del hosting.
3. Sube el WAR a tu contenedor Servlet/Tomcat.
4. Verifica que las tablas se creen con `HIBERNATE_HBM2DDL_AUTO=update`.
5. Cuando el esquema quede estable, cambia a `validate` y usa migraciones.

## Notas

- El valor `sb_publishable_*` de Supabase no se usa para JDBC; sirve para API cliente.
- Para producción real, conviene usar migraciones SQL y dejar `HIBERNATE_HBM2DDL_AUTO=validate`.
