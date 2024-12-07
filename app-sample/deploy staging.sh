#!/bin/sh

ENVIRONMENT=$1

PROJECT_NAME_PREFIX="app-sample-"

ENVFILE=./.env.$ENVIRONMENT

source $ENVFILE

if [ "$ENVIRONMENT" != "production" ] && [ "$ENVIRONMENT" != "staging" ];
then
    echo "Please specify which environment you would like (staging or production)"
    exit 1
fi

PROCESS_SUFFIX=""
if [ "$ENVIRONMENT" = "staging" ];
then
    PROCESS_SUFFIX="-staging"
fi

if [ "$ENVIRONMENT" = "production" ];
then
    PROCESS_SUFFIX="-production"
fi

if [[ -n $(docker ps -f name=${PROJECT_NAME_PREFIX}${ENVIRONMENT}-blue -q) ]]
then
    CURRENT_DEPLOYMENT="${PROJECT_NAME_PREFIX}${ENVIRONMENT}-green"
    PREVIOUS_DEPLOYMENT="${PROJECT_NAME_PREFIX}${ENVIRONMENT}-blue"
else
    CURRENT_DEPLOYMENT="${PROJECT_NAME_PREFIX}${ENVIRONMENT}-blue"
    PREVIOUS_DEPLOYMENT="${PROJECT_NAME_PREFIX}${ENVIRONMENT}-green"
fi



# check if db container is running
if [[ -n $(docker ps -f name=postgres-db-${ENVIRONMENT} -q) ]]
then
    echo "Database "$ENVIRONMENT" container is already running"
else
    echo "Starting "$ENVIRONMENT" Database container"
    docker compose -f docker-compose.${ENVIRONMENT}-db.yml up -d
fi

echo "Starting "$CURRENT_DEPLOYMENT" container"

docker compose -f docker-compose.${ENVIRONMENT}.yml --project-name=$CURRENT_DEPLOYMENT up -d --build

echo 'Waiting API to succeed in its healthcheck'
until docker compose -f docker-compose.${ENVIRONMENT}.yml --project-name=$CURRENT_DEPLOYMENT exec -T ${PROJECT_NAME_PREFIX}${ENVIRONMENT} curl --silent --head --fail http://0.0.0.0:3000/api/healthcheck ; do
    printf '.'
    sleep 3
done
echo 'API is Up'

echo "Stopping "$PREVIOUS_DEPLOYMENT" container"
docker compose -f docker-compose.${ENVIRONMENT}.yml --project-name=$PREVIOUS_DEPLOYMENT down

rm $ENVFILE
touch $ENVFILE
