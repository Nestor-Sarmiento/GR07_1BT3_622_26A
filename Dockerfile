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

# Script que expande las variables de entorno antes de ejecutar Java
RUN echo '#!/bin/sh\nexec java -Dspring.docker.compose.enabled=false -Dspring.data.mongodb.uri="$MONGODB_URI" -Dserver.port="${PORT:-8080}" -jar app.jar' > /app/start.sh && chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]