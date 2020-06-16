#!/bin/bash

CLUSTER_NAME=$1

kops delete cluster $CLUSTER_NAME --yes
