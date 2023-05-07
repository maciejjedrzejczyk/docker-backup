
#!/bin/sh


result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

echo "This script will back up existing volume for for ${PWD##*/}, delete it and restore a selected docker volume from an existing backup."

echo
echo "Set environment variables"

export DOCKER_BACKUP_DIR=$PWD/backup
export DOCKER_COMPOSE_DIR=$PWD/compose
export COMPOSE_FILE_NAME=docker-compose
export COMPOSE_PROJ_NAME=$(grep container_name ./compose/docker-compose.yaml | sed -e 's/container_name: //g' | sed "s/ //g")
export DOCKER_VOLUME_NAME=$COMPOSE_PROJ_NAME
export DOCKER_IMAGE=$(grep image ./compose/docker-compose.yaml | sed -e 's/image: //g')

echo
echo "Turn off a ${PWD##*/} project before backing up data"

sh $PWD/compose-stop.sh

echo
echo "Back up existing container volume for ${PWD##*/} project"

docker run --rm -v $DOCKER_VOLUME_NAME:/volume -v $DOCKER_BACKUP_DIR:/backup alpine tar -cjf /backup/$DOCKER_VOLUME_NAME-"$(date +"%Y_%m_%d_%I_%M_%p").tar.bz2" -C /volume ./

echo
echo "Deleting ${PWD##*/} container volume if it exists already"

docker volume rm $DOCKER_VOLUME_NAME

echo "Select backup file to restore from."

ls -lht $DOCKER_BACKUP_DIR

echo -n "Backup file name: "
read -r filename

echo
echo "Restoring from backup file $filename"

docker run --rm -v $DOCKER_VOLUME_NAME:/volume -v $DOCKER_BACKUP_DIR:/backup alpine sh -c "rm -rf /volume/* /volume/..?* /volume/.[!.]* ; tar -C /volume/ -xjf /backup/$filename"

echo "Listing available volumes for $DOCKER_VOLUME_NAME"

docker volume list | grep $DOCKER_VOLUME_NAME
