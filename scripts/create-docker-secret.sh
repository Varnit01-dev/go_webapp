#!/bin/bash

# Check if Docker Hub credentials are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <dockerhub-username> <dockerhub-password>"
    exit 1
fi

# Create Docker config.json
DOCKER_CONFIG_JSON=$(echo -n "{\"auths\":{\"https://index.docker.io/v1/\":{\"auth\":\"$(echo -n "$1:$2" | base64)\"}}}" | base64)

# Create the secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: dockerhub-secret
  namespace: default
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: ${DOCKER_CONFIG_JSON}
EOF

echo "Docker Hub secret created successfully!" 