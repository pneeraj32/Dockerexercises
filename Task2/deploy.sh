#!/bin/bash
# remove running containers
docker rm -f $(docker ps -qa)
# create a network
docker network create trio-task-network
#create a volume
docker volume create new-volume
# build flask and mysql
docker build -t trio-task-mysql:5.7 db
docker build -t trio-task-flask-app:latest flask-app
# run mysql container
docker run -d \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    --name mysql \
    --network trio-task-network \
    trio-task-mysql:5.7
# run flask container
docker run -d \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    --name flask-app \
    --network trio-task-network \
    trio-task-flask-app:latest
# run the nginx container
docker run -d \
    --name nginx \
    -p 80:80 \
    --network trio-task-network \
    --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    nginx:latest
# show running containers
docker ps -a
