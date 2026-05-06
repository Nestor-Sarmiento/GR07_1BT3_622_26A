# Etapa 1 — Compilar
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2 — Desplegar en Tomcat
FROM tomcat:10.1-jdk17-temurin
# Limpiar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copiar el WAR como ROOT para que sea la app principal
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]