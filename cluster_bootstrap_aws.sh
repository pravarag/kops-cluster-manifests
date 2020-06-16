#!/bin/bash

CLUSTER_NAME=$1
AWS_OBJECT_STORE=$2

# Set required variables
export NAME=$CLUSTER_NAME

export KOPS_STATE_STORE=s3://$2

export REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`

export ZONES=$(aws ec2 describe-availability-zones --region $REGION | grep ZoneName | awk '{print $2}' | tr -d '"')

# Create the cluster
kops create cluster $NAME \
  --zones "$ZONES" \
  --authorization RBAC \
  --master-size t2.micro \
  --master-volume-size 10 \
  --node-size t2.micro \
  --node-volume-size 10 \
  --yes

  # --topology private \
  # --networking weave

# Wait until kops cluster is ready
time until kops validate cluster; do sleep 15 ; done

# generate KUBECONFIG
kops export kubecfg

echo "Cluster is now ready"

