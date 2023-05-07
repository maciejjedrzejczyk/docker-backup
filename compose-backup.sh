#!/bin/sh

result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

echo "This script will create a new backup for a docker volume used by ${PWD##*/} and delete backups which are older than 14 days."

echo
echo "Set environment variables"

result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

export DOCKER_BACKUP_DIR=$PWD/backup
export DOCKER_COMPOSE_DIR=$PWD/compose
export COMPOSE_FILE_NAME=docker-compose
export COMPOSE_PROJ_NAME=$(grep container_name ./compose/docker-compose.yaml | sed -e 's/container_name: //g' | sed "s/ //g")
export DOCKER_VOLUME_NAME=$COMPOSE_PROJ_NAME
export DOCKER_IMAGE=$(grep image ./compose/docker-compose.yaml | sed -e 's/image: //g')

echo
echo "Delete all backups which are older than 14 days"

find ./backup/ -type f -mtime +14 -delete

echo
echo "Turn off a ${PWD##*/} container before backing up data"

sh $PWD/compose-stop.sh

echo
echo "Back up ${PWD##*/} container volume"

docker run --rm -v $DOCKER_VOLUME_NAME:/volume -v $DOCKER_BACKUP_DIR:/backup alpine tar -cjf /backup/$DOCKER_VOLUME_NAME-"$(date +"%Y_%m_%d_%I_%M_%p").tar.bz2" -C /volume ./

echo
echo "Show ${PWD##*/} volume backups"

ls -lht $PWD/backup

echo
echo "Send ${PWD##*/} volume backups to a remote location"

rsync -av $PWD rock@alpha:/home/rock/raid/shared/backup/docker-volume-sigma

echo
echo "Turn on ${PWD##*/} container after backup"

sh $PWD/compose-start.sh
