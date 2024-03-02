#!/bin/bash

# Endpoint URL, container name, image, and entrypoint are passed as arguments
API_ENDPOINT="$1"
CONTAINER_NAME="$2"
IMAGE="$3"
ENTRYPOINT="$4"

# Create a new Docker container
curl -s -X POST "$API_ENDPOINT/containers/create?name=$CONTAINER_NAME" \
     -H "Content-Type: application/json" \
     -d "{\"Image\": \"$IMAGE\", \"Entrypoint\": $ENTRYPOINT}" | jq .