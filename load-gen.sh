#!/bin/sh

# ensure correct user and namespce
oc login -u developer
oc project robot-shop

# start load gen, pull directly from Docker Hub
oc new-app \
    -e "HOST=http://web:8080/" \
    -e "NUM_CLIENTS=1" \
    -e "SILENT=1" \
    -e "ERROR=1" \
    -e "RUN_TIME=0" \
    robotshop/rs-load:latest

