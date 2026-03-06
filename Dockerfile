# Etapa 1: build
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .
RUN chmod +x mvnw || true
RUN ./mvnw -q -DskipTests dependency:go-offline || mvn -q -DskipTests dependency:go-offline

COPY src src
RUN ./mvnw -q -DskipTests clean package || mvn -q -DskipTests clean package

# Etapa 2: runtime
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]