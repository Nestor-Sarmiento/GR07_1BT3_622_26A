# Build stage
FROM eclipse-temurin:23-jdk AS build
WORKDIR /app

COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline

COPY src src
# Cambia esta línea en tu Build stage:
RUN ./mvnw -q clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:23-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Mapeo explícito de variables de entorno de Render a Propiedades de Spring
ENV SPRING_DATA_MONGODB_URI=${MONGODB_URI}
ENV SERVER_PORT=${PORT}

EXPOSE 10000

# Eliminamos -Dspring.profiles.active=prod si no tienes archivos de perfil, 
# para que no busque configuraciones inexistentes.
ENTRYPOINT ["java", "-jar", "app.jar"]