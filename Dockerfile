FROM 765732641087.dkr.ecr.ap-south-1.amazonaws.com/openjdk:17-jdk-slim
COPY . .
LABEL maintainer="sreenivasa raju | dnsrinu143@gmail.com"
LABEL version="v:1.0.0"
LABEL description="A Docker image for a Spring Boot application."
EXPOSE 1199
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0","-jar", "spring-application-k8s.jar"]
USER nobody

