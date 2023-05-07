#!/bin/sh

result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

echo "This script will create a new backup for a docker volume used by ${PWD##*/} and delete backups which are older than 14 days."

echo
echo "Set environment variables"

sh $PWD/variables.sh

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
