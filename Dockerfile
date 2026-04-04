# Build stage
FROM eclipse-temurin:23-jdk AS build
WORKDIR /app

COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline

COPY src src
RUN ./mvnw -q -DskipTests package

# Runtime stage
FROM eclipse-temurin:23-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Pasa TODAS las propiedades como parámetros JVM para Render
ENTRYPOINT ["sh", "-c", "java -Dspring.profiles.active=prod -Dspring.docker.compose.enabled=false -Dspring.data.mongodb.uri='mongodb+srv://servidor_render:8RuVUs2hKBCw0ceR@pdciae.kmjvbbb.mongodb.net/pdciae?retryWrites=true&w=majority&appName=PDCIAE' -Dserver.port=${PORT:-8080} -jar app.jar"]
