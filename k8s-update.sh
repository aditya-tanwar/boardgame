#!/bin/bash




appversion=1


sed -i "s|image: .*|image: adityatanwar03/boardgame:v$appversion|g" k8s/deployment-service.yaml


exit 0
