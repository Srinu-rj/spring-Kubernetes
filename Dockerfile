# FROM eclipse-temurin:21-jdk-jammy AS builder
# WORKDIR /build
# COPY . .
#
# FROM gcr.io/distroless/java21-debian12
# COPY --from=builder /build/target/*.jar /spring-application-k8s.jar
# EXPOSE 1199
# ENTRYPOINT ["java", "-jar", "/spring-application-k8s.jar"]

FROM maven:3.9.6-eclipse-temurin-22-jammy AS build
COPY . .
FROM openjdk:17 AS builder
COPY --from=build /target/spring-application-k8s.jar spring-application-k8s.jar
EXPOSE 8998
ENTRYPOINT ["java","-jar","spring-application-k8s.jar"]
LABEL maintainer="SREENIVASA RAJU"
LABEL version="1.0.0"
LABEL description="Spring Boot Application with Postgress Database"
USER nobody


