#!/bin/bash 

instanceId=`aws ec2 describe-instances --filter "Name=tag:restartOnPush,Values=true" --query "Reservations[*].Instances[*].{Instance:InstanceId}" --output text`
echo $instanceId


aws ec2 stop-instances --instance-ids $instanceId
sleep 40
aws ec2 start-instances --instance-ids $instanceId

        