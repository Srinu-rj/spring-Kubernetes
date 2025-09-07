#!/bin/bash

docker build -t spring-application-k8s .
docker tag spring-application-k8s srinu641/spring-application-k8s:v1.04
docker push srinu641/spring-application-k8s:v1.04
#docker images
#docker history spring-application-k8s
#docker inspect spring-application-k8s