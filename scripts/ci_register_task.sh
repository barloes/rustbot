#!/bin/bash

register_task(){
    SERVICE=$1
    NEW_IMAGE_URL="${ECR_REGISTRY}/${SERVICE}:${IMAGE_TAG}"
    aws ecs describe-task-definition --task-definition $SERVICE --query 'taskDefinition.{containerDefinitions:containerDefinitions}' > task-definitions.json 
    jq '.containerDefinitions[0].image="'"$NEW_IMAGE_URL"'"' task-definitions.json

    aws ecs register-task-definition \
        --family $SERVICE \
        --cli-input-json file://task-definitions.json \
        --requires-compatibilities FARGATE \
        --network-mode awsvpc \
        --cpu 256 --memory 512 
}

register_task $1
