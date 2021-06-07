#!/bin/bash 

aws ecr batch-delete-image --repository-name $ECR_REPOSITORY --image-ids imageTag=$IMAGE_TAG
docker buildx build --platform linux/arm64/v8 -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
echo "::set-output name=image::$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"