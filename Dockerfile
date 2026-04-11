# Build stage
FROM eclipse-temurin:23-jdk AS build
WORKDIR /app

# Copiamos los archivos de configuración de Maven para aprovechar el caché de capas
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline

# Copiamos el código fuente y compilamos asegurando una limpieza previa
COPY src src
RUN ./mvnw -q clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:23-jre
WORKDIR /app

# Copiamos el archivo JAR generado en la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Render detecta automáticamente el puerto abierto; Spring lo toma de PORT.
EXPOSE 8080

# Ejecución de la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]