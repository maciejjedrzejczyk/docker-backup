#!/bin/sh

echo
echo "Set environment variables"

export DOCKER_BACKUP_DIR=$PWD/backup
export DOCKER_COMPOSE_DIR=$PWD/compose
export COMPOSE_FILE_NAME=docker-compose
export COMPOSE_PROJ_NAME=$(grep container_name ./compose/docker-compose.yaml | sed -e 's/container_name: //g' | sed "s/ //g")
export DOCKER_VOLUME_NAME=$COMPOSE_PROJ_NAME
export DOCKER_IMAGE=$(grep image ./compose/docker-compose.yaml | sed -e 's/image: //g')

echo "This script will pull a new image for $COMPOSE_PROJ_NAME container project"

echo
echo "Checking the current image"

docker image ls | grep $COMPOSE_PROJ_NAME

echo
echo "Stopping $COMPOSE_PROJ_NAME container project"

sh $PWD/compose-stop.sh

echo
echo "Removing $COMPOSE_PROJ_NAME image and pulling a new one"

docker rmi $DOCKER_IMAGE_REPO/$DOCKER_IMAGE_NAME
docker pull $DOCKER_IMAGE_REPO/$DOCKER_IMAGE_NAME
docker image ls | grep $COMPOSE_PROJ_NAME

echo
echo "Starting $COMPOSE_PROJ_NAME container project"

sh $PWD/compose-start.sh
