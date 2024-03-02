#!/bin/bash

# Endpoint URL passed as the first argument
API_ENDPOINT="$1"

# List all Docker containers
curl -s -X GET "$API_ENDPOINT/containers/json" | jq .
