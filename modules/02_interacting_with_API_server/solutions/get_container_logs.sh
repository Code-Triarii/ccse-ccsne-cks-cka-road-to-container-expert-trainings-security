#!/bin/bash

# Endpoint URL and container name are passed as arguments
API_ENDPOINT="$1"
CONTAINER_NAME="$2"

# Retrieve logs from a specified container
curl -s -X GET "$API_ENDPOINT/containers/$CONTAINER_NAME/logs?stdout=true&stderr=true" | jq .
