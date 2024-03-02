#!/bin/bash

# Endpoint URL passed as the first argument
API_ENDPOINT="$1"

# List all Docker images
curl -s -X GET "$API_ENDPOINT/images/json" | jq .
