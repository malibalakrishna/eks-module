#!/bin/bash
set -o xtrace

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh ${cluster_name} ${bootstrap_arguments}

# Label node for cluster autoscaler
kubectl label node $HOSTNAME node.kubernetes.io/instance-type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type) --overwrite

# Add additional setup scripts here if needed