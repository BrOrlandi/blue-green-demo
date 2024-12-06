#!/bin/sh

PROJECT_NAME_PREFIX="app-sample"

DEPLOYMENT="blue"
if [[ -n $(docker ps -f name=${PROJECT_NAME_PREFIX}-blue -q) ]]
then
    echo "Blue container is running"
		DEPLOYMENT="green"
    CURRENT_DEPLOYMENT="${PROJECT_NAME_PREFIX}-green"
    PREVIOUS_DEPLOYMENT="${PROJECT_NAME_PREFIX}-blue"
else
    echo "Green container is running"
		DEPLOYMENT="blue"
    CURRENT_DEPLOYMENT="${PROJECT_NAME_PREFIX}-blue"
    PREVIOUS_DEPLOYMENT="${PROJECT_NAME_PREFIX}-green"
fi


echo "Starting "$CURRENT_DEPLOYMENT" container"

DEPLOYMENT=$DEPLOYMENT docker compose --project-name=$CURRENT_DEPLOYMENT up -d --build

echo 'Waiting API to succeed in its healthcheck'
until docker compose --project-name=$CURRENT_DEPLOYMENT exec -T ${PROJECT_NAME_PREFIX} curl --silent --head --fail http://0.0.0.0:3000/healthcheck ; do
    echo '.'
    sleep 3
done
echo 'App API is Up'

echo "Stopping "$PREVIOUS_DEPLOYMENT" container"
docker compose --project-name=$PREVIOUS_DEPLOYMENT down
