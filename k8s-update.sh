#!/bin/bash




appversion=1


sed -i "s|image: .*|image: adityatanwar03/boardgame:v$appversion|g" deployment-servicec.yaml


exit 0