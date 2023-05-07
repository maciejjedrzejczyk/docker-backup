#!/bin/sh

echo
echo "Set environment variables"

export DOCKER_BACKUP_DIR=$PWD/backup
export DOCKER_COMPOSE_DIR=$PWD/compose
export COMPOSE_FILE_NAME=docker-compose
export COMPOSE_PROJ_NAME=$(grep container_name ./compose/docker-compose.yaml | sed -e 's/container_name: //g' | sed "s/ //g")
export DOCKER_VOLUME_NAME=$COMPOSE_PROJ_NAME
export DOCKER_IMAGE=$(grep image ./compose/docker-compose.yaml | sed -e 's/image: //g')

echo "This script will start $COMPOSE_PROJ_NAME container project"

docker-compose -p $COMPOSE_PROJ_NAME -f $PWD/compose/$COMPOSE_FILE_NAME.yaml up -d
