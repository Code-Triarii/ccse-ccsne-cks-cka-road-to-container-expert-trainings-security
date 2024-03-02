# Solution Guide: Docker API Interaction with curl

This guide outlines the solution to the challenge of interacting directly with the Docker API using `curl` commands. The objective is to create shell scripts for listing Docker images and containers, creating a new container, and retrieving container logs. This exercise enhances your understanding of the Docker API and hones your skills in shell scripting and API interaction.

## Requirements for this exercise

- Docker installed and running on your system.
- The Docker API must be accessible, potentially requiring configuration to expose it securely.
- `curl` and `jq` installed for making HTTP requests and formatting JSON responses, respectively.

## Step by step - Manual

### Step 1: Script Creation

You're tasked with creating four scripts that use `curl` to perform operations via the Docker API.
You can find all this script mentioned in this same folder 😉

#### 1. List Docker Images (`list_images.sh`)

This script fetches a list of all Docker images available on the host.

```bash
#!/bin/bash
API_ENDPOINT="$1"
curl -s -X GET "$API_ENDPOINT/images/json" | jq .
```

#### 2. List Docker Containers (`list_containers.sh`)

Lists all Docker containers, including those not running.

```bash
#!/bin/bash
API_ENDPOINT="$1"
curl -s -X GET "$API_ENDPOINT/containers/json?all=true" | jq .
```

#### 3. Create a Docker Container (`create_container.sh`)

Creates a new container with specified parameters.

```bash
#!/bin/bash
API_ENDPOINT="$1"
CONTAINER_NAME="$2"
IMAGE="$3"
ENTRYPOINT="$4"
curl -s -X POST "$API_ENDPOINT/containers/create?name=$CONTAINER_NAME" \
     -H "Content-Type: application/json" \
     -d "{\"Image\": \"$IMAGE\", \"Entrypoint\": $ENTRYPOINT}" | jq .
```

#### 4. Retrieve Container Logs (`get_container_logs.sh`)

Fetches logs from a specified container.

```bash
#!/bin/bash
API_ENDPOINT="$1"
CONTAINER_NAME="$2"
curl -s -X GET "$API_ENDPOINT/containers/$CONTAINER_NAME/logs?stdout=true&stderr=true" | jq .
```

### Step 2: Script Execution

To execute these scripts, follow these steps:

1. Make the script executable:
  
   ```bash
   chmod +x *.sh
   ```

2. Run the script by passing the Docker API endpoint and other required parameters as arguments:

   ```bash
   ./list_images.sh http://localhost:2375
   ```

### Step 3: Verify Operations

After executing each script, verify the output to ensure the operations were successful. The `jq` tool formats the JSON output for readability.

## Security Considerations

- Ensure the Docker API is securely exposed, especially if enabling remote access. Consider using SSH tunnels or VPNs.
- Be cautious with script inputs to avoid injection attacks.

## Conclusion

Congratulations on completing the Docker API interaction challenge! This exercise has equipped you with valuable knowledge on directly managing Docker resources using API calls, a critical skill for advanced Docker management and automation. 🚀