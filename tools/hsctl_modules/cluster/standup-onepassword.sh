#!/bin/bash
# Script to provision credentials for 1Password Operator
set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <clusterName>"
    exit 1
fi

CLUSTER_NAME=$1

if ! /usr/bin/op vault get "$CLUSTER_NAME" >/dev/null 2>&1; then
    echo "Vault $CLUSTER_NAME does not exist. Creating..."
    /usr/bin/op vault create "$CLUSTER_NAME"
fi

RESPONSE=$(/usr/bin/op connect server create "$CLUSTER_NAME" --vaults "$CLUSTER_NAME,common")
CONNECT_CREDENTIALS_FILE=$(echo "$RESPONSE" | grep "Credentials file" | awk '{print $NF}')

OPERATOR_TOKEN=$(/usr/bin/op connect token create "$CLUSTER_NAME" --server "$CLUSTER_NAME" --vault "$CLUSTER_NAME" --vault "common")

CONNECT_CREDENTIALS=$(base64 -w 0 "$CONNECT_CREDENTIALS_FILE")

/usr/bin/op item create --vault "$CLUSTER_NAME" --category "API Credential" --title "onepassword" \
    operator-token="$OPERATOR_TOKEN" connect-credentials="$CONNECT_CREDENTIALS"

rm $CONNECT_CREDENTIALS_FILE

kubectl create ns onepassword
kubectl create secret generic "op-onepassword" \
  --from-literal=operator-token="$OPERATOR_TOKEN" \
  --from-literal=connect-credentials="$CONNECT_CREDENTIALS" \
  -n onepassword
kubectl delete pods --all -n onepassword
