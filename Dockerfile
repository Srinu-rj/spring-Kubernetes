FROM amazoncorretto:17-alpine
COPY . .
LABEL maintainer="sreenivasa raju | dnsrinu143@gmail.com"
LABEL version="v:1.0.0"
LABEL description="A Docker image for a Spring Boot application."
EXPOSE 1199
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0","-jar", "spring-application-k8s.jar"]
USER nobody


# FROM openjdk:17-jdk-slim
# WORKDIR /app
# COPY target/spring-application-k8s.jar spring-application-k8s.jar
# EXPOSE  1199
# ENTRYPOINT ["java", "-jar", "spring-application-k8s.jar"]

