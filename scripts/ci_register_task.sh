#!/bin/bash

register_task(){
    SERVICE=$1
    IMAGE_TAG="notmaster"
    NEW_IMAGE_URL="${ECR_REGISTRY}/${SERVICE}:${IMAGE_TAG}"

    aws ecs describe-task-definition --task-definition $SERVICE \
        --query '{  containerDefinitions: taskDefinition.containerDefinitions,
                    family: taskDefinition.family,
                    taskRoleArn: taskDefinition.taskRoleArn,
                    executionRoleArn: taskDefinition.executionRoleArn,
                    networkMode: taskDefinition.networkMode,
                    volumes: taskDefinition.volumes,
                    placementConstraints: taskDefinition.placementConstraints,
                    requiresCompatibilities: taskDefinition.requiresCompatibilities,
                    cpu: taskDefinition.cpu,
                    memory: taskDefinition.memory}' > task-definitions.json 
    
    jq '.containerDefinitions[0].image="'"$NEW_IMAGE_URL"'"' task-definitions.json > tmp.$$.json && mv tmp.$$.json task-definitions.json

    aws ecs register-task-definition  --family $SERVICE --cli-input-json "$NEW_TASK_DEFINTION"
}

register_task $1
