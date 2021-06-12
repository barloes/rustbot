#!/bin/bash
source "$(dirname $0)/ci_commons.sh"
changed_functions=$(get_changed)

update_service(){
    ECS_CLUSTER="${get_cluster}-$1"
    SERVICE=$1

    aws ecs update-service --cluster $ECS_CLUSTER --service $SERVICE --force-new-deployment
}


for name in $changed_functions; do
    echo "Updating Service for ${name}..."  
    update_service $name
done