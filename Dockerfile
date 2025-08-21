# FROM eclipse-temurin:17-jdk-alpine AS build
# COPY . .
# LABEL maintainer="sreenivasa raju | dnsrinu143@gmail.com"
# LABEL version="v:1.0.0"
# LABEL description="A Docker image for a Spring Boot application."
# EXPOSE 1199
# ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0","-jar", "spring-application-k8s.jar"]
# USER nobody

# Step 1: Use official OpenJDK as base image
FROM openjdk:17-jdk-slim
# Step 2: Set working directory inside the container
WORKDIR /app
# Step 3: Copy the JAR file from the host to the container
COPY target/spring-application-k8s.jar spring-application-k8s.jar
# Step 4: Expose the application port
EXPOSE  1199
# Step 5: Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]