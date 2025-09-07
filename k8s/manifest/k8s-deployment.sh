#!/bin/bash

alias k=kubectl
k apply -f deployment.yml
k apply -f sevice.yaml
k get all
k get pods
k get svc
k describe pod/application-ecommerce-deployment-7864d8d9cd-jp2k4