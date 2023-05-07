#!/bin/sh

echo
echo "Set environment variables"

sh $PWD/variables.sh

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
