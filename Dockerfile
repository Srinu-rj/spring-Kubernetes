# # Dockerfile
# FROM eclipse-temurin:17-jdk-alpine AS build
# COPY . .
# LABEL maintainer="sreenivasa raju | dnsrinu143@gmail.com"
# LABEL description="A Docker image for a Spring Boot application."
# EXPOSE 1199
# ENTRYPOINT ["java","-jar", "spring-application-k8s.jar"]

# FROM openjdk:26-oraclelinux8
# WORKDIR /app
# COPY target/spring-application-k8s.jar /app/spring-application-k8s.jar
# COPY src ./src
# COPY pom.xml .
# LABEL maintainer="sreenivasa raju | dnsrinu143@gmail.com"
# LABEL description="A Docker image for a Spring Boot application."
# EXPOSE 1199
# ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]

#
# FROM openjdk:17-jdk-alpine
# WORKDIR /app
# COPY target/spring-application-k8s.jar /app/spring-application-k8s.jar
# EXPOSE 1199
# ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]

# # Step 1: Use official OpenJDK as base image
# FROM openjdk:17-jdk-slim
# # Step 2: Set working directory inside the container
# WORKDIR /app
# # Step 3: Copy the JAR file from the host to the container
# COPY target/spring-application-k8s.jar spring-application-k8s.jar
# # Step 4: Expose the application port
# EXPOSE  1199
# # Step 5: Run the Spring Boot application
# ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]


# FROM maven:3.9.6-eclipse-temurin-22-jammy as build
# COPY . .
# RUN mvn clean package -DskipTests
#
# FROM openjdk:22-jdk
# COPY --from=build /target/spring-application-k8s.jar spring-application-k8s.jar
# EXPOSE 1199
# ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]


FROM maven:3.9.6-eclipse-temurin-22-jammy AS build
COPY . .
FROM openjdk:17 AS builder
COPY --from=build /target/spring-application-k8s.jar spring-application-k8s.jar
EXPOSE 1199
ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]

USER nobody



# TODO  DOCKER REF LINKS
# https://medium.com/@digitaldata03/docker-cmd-vs-entrypoint-key-differences-and-best-practices-2c6d5208d060
# https://phoenixnap.com/kb/docker-cmd-vs-entrypoint


