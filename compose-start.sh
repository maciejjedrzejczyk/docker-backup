#!/bin/sh

echo
echo "Set environment variables"

sh $PWD/variables.sh

echo "This script will start $COMPOSE_PROJ_NAME container project"

docker-compose -f $PWD/compose/$COMPOSE_FILE_NAME.yaml up -d
