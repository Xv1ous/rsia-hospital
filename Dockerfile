# syntax=docker/dockerfile:1

# Build stage: Java + Node.js for frontend build
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Install Node.js and npm
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

WORKDIR /app

# Copy Maven files and download dependencies (cache step)
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B

# Copy the rest of the source code
COPY src ./src

# Build the project (this will run npm install/build via Maven plugin)
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests

# Runtime stage: only Java, smaller image
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app runs on (change if needed)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

# Untuk development: jalankan watch di container
# Uncomment baris berikut untuk mode development
# CMD ["/bin/bash", "-c", "cd src/main/frontend && npm install && npm run watch"]
