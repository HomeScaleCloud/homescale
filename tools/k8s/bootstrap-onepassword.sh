#!/bin/bash
# Script to bootstrap 1Password Operator/Connect credentials
CLUSTER=$1

OPERATOR_TOKEN=$(op item get onepassword --vault $CLUSTER --field operator-token --reveal)
CONNECT_CREDENTIALS=$(op item get onepassword --vault $CLUSTER --field connect-credentials --reveal)

# Create Kubernetes secret
kubectl create secret generic "op-onepassword" \
  --from-literal=operator-token="$OPERATOR_TOKEN" \
  --from-literal=connect-credentials="$CONNECT_CREDENTIALS" \
  -n onepassword
kubectl delete pods --all -n onepassword
