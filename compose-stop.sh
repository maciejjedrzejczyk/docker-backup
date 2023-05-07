#!/bin/sh

echo
echo "Set environment variables"

source variables.sh

echo "This script will stop $COMPOSE_PROJ_NAME container project"

docker-compose -f $PWD/compose/$COMPOSE_FILE_NAME.yaml down
