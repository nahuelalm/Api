# Etapa de construcción
FROM maven:3.9.8-eclipse-temurin-22 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean install -DskipTests -B

# Agregar comando para listar archivos en target (solo para depuración)
RUN ls -l /app/target

# Etapa de ejecución
FROM eclipse-temurin:22.0.2_9-jdk

WORKDIR /app

# Copiar el archivo JAR desde la etapa de construcción
COPY --from=build /app/target/primeraApi-0.0.1-SNAPSHOT.jar /app/tu-app.jar

EXPOSE 8080

CMD ["java", "-jar", "tu-app.jar"]
