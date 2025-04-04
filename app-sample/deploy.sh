#!/bin/sh

DEPLOYMENT="blue"

if [[ -n $(docker ps -f name=app-sample-blue -q) ]]
then
    echo "Blue container is running"
		DEPLOYMENT="green"
    CURRENT_DEPLOYMENT="app-sample-green"
    PREVIOUS_DEPLOYMENT="app-sample-blue"
else
    echo "Green container is running"
		DEPLOYMENT="blue"
    CURRENT_DEPLOYMENT="app-sample-blue"
    PREVIOUS_DEPLOYMENT="app-sample-green"
fi


echo "Starting "$CURRENT_DEPLOYMENT" container"

DEPLOYMENT=$DEPLOYMENT docker compose --project-name=$CURRENT_DEPLOYMENT up -d --build

echo 'Waiting API to succeed in its healthcheck'
until docker compose --project-name=$CURRENT_DEPLOYMENT exec -T app-sample curl --silent --head --fail http://0.0.0.0:3000/healthcheck ; do
    echo '.'
    sleep 3
done
echo 'App API is Up'

echo "Stopping "$PREVIOUS_DEPLOYMENT" container"
docker compose --project-name=$PREVIOUS_DEPLOYMENT down
