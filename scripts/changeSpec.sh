#!/bin/bash 

instanceId=`aws ec2 describe-instances --filter "Name=tag:restartOnPush,Values=true" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{Instance:InstanceId}" --output text`
echo $instanceId
aws ec2 modify-instance-credit-specification --instance-credit-specification "InstanceId=$instanceId,CpuCredits=standard"