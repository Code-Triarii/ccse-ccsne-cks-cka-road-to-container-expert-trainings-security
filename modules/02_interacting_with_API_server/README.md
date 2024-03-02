# Exercise 3: Docker API Interaction with curl

## 🎯 Challenge

Your objective in this exercise is to interact with the Docker API directly using `curl` commands. This approach requires crafting specific HTTP requests to manage Docker resources, such as images and containers. You'll create four shell scripts that perform various Docker operations via the API, offering a deeper understanding of Docker's HTTP API and enhancing your skills in shell scripting and API interaction.

## ✅ Success Criteria

- [ ] Create a shell script that lists all Docker images by interacting with the Docker API.
- [ ] Develop a script to list all Docker containers, utilizing the Docker API.
- [ ] Implement a script that creates a new Docker container, allowing users to specify:
  - The container image.
  - Container name.
  - Entry point (optional).
- [ ] Craft a script to retrieve logs from a specified container using the Docker API.
- [ ] Each script should accept the Docker API endpoint (including scheme and port) as a parameter.

## 📚 References

- Docker API documentation: [https://docs.docker.com/engine/api/latest/](https://docs.docker.com/engine/api/latest/)
- `curl` command usage: [https://curl.se/docs/](https://curl.se/docs/)
- Shell scripting basics: [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

## 🛠 Solution

For detailed steps on how to complete this challenge, including example code and explanations, refer to the [solutions.md](./solutions/README.md) file in the same folder. This challenge invites you to explore the Docker API's capabilities using `curl`, a powerful tool for making HTTP requests from the command line. Good luck, and remember, mastering Docker's API will greatly enhance your ability to automate and manage Docker environments programmatically! 🚀

### Sample Script Overview

- **list_images.sh:** Lists all Docker images.

- ```bash
  ./list_images.sh http://localhost:2375
  ```

- **list_containers.sh:** Lists all Docker containers.

  ```bash
  ./list_containers.sh https://localhost:2376
  ```

- **create_container.sh:** Creates a new Docker container.

  ```bash
  ./create_container.sh http://localhost:2375 my-container nginx:latest "/bin/bash"
  ```

- **get_container_logs.sh:** Retrieves logs from a specified container.

  ```bash
  ./get_container_logs.sh https://localhost:2376 my-container
  ```

Each script should dynamically construct and send the appropriate `curl` request to the Docker API based on the user's input, demonstrating practical usage of API endpoints for Docker management tasks.
