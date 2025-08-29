# # Dockerfile
# FROM eclipse-temurin:17-jdk-alpine AS build
# COPY . .
# LABEL maintainer="sreenivasa raju | dnsrinu143@gmail.com"
# LABEL description="A Docker image for a Spring Boot application."
# EXPOSE 1199
# ENTRYPOINT ["java","-jar", "spring-application-k8s.jar"]




FROM maven:3.9.6-eclipse-temurin-22-jammy as build
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:22-jdk
COPY --from=build /target/spring-application-k8s.jar spring-application-k8s.jar
EXPOSE 1199
ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]



# FROM openjdk:17-jdk-slim
# WORKDIR /app
# COPY build/libs/spring-application-k8s.jar /app
# EXPOSE 8080
# CMD ["java", "-jar", "spring-application-k8s.jar"]