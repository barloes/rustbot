#!/bin/bash

register_task(){
    SERVICE=$1
    NEW_IMAGE_URL="${ECR_REGISTRY}/${SERVICE}:${IMAGE_TAG}"

    aws ecs describe-task-definition --task-definition $SERVICE \
        --query '{  containerDefinitions: taskDefinition.containerDefinitions,
                    family: taskDefinition.family,
                    executionRoleArn: taskDefinition.executionRoleArn,
                    networkMode: taskDefinition.networkMode,
                    volumes: taskDefinition.volumes,
                    placementConstraints: taskDefinition.placementConstraints,
                    requiresCompatibilities: taskDefinition.requiresCompatibilities,
                    cpu: taskDefinition.cpu,
                    memory: taskDefinition.memory}' > task-definitions.json 
    
    jq '.containerDefinitions[0].image="'"$NEW_IMAGE_URL"'"' task-definitions.json > tmp.$$.json && mv tmp.$$.json task-definitions.json

    aws ecs register-task-definition  --family $SERVICE --cli-input-json file://task-definitions.json

    aws ecs update-service --cluster $SERVICE --service $SERVICE --task-definition $SERVICE --force-new-deployment
}

register_task $1
