# Usa una imagen base de Maven para construir la aplicación
FROM maven:3.9.8-openjdk-22.0.2 AS build

# Configura el directorio de trabajo
WORKDIR /app

# Copia el archivo pom.xml y las dependencias
COPY pom.xml .

# Descarga las dependencias sin compilar
RUN mvn dependency:go-offline -B

# Copia el resto de la aplicación y compila
COPY src ./src
RUN mvn clean package -DskipTests

# Usa una imagen base de OpenJDK para ejecutar la aplicación
FROM openjdk:17-jdk-slim

# Configura el directorio de trabajo
WORKDIR /app

# Copia el jar de la fase de compilación
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto que usa la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
