# Exercise 4: Analyze Docker sock Communication

## 🎯 Challenge
Your goal in this exercise is to intercept and analyze the communication between the Docker CLI and the Docker daemon through the Docker socket (`/var/run/docker.sock`). Understanding this communication is vital for comprehending how Docker commands translate into API calls to the Docker daemon. You'll capture and document the HTTP requests for key Docker operations, thereby deepening your knowledge of Docker's internal workings and enhancing your debugging and API interaction skills.

## ✅ Success Criteria
- [ ] Capture the HTTP request made when listing all Docker images.
- [ ] Document the HTTP request for starting a new Docker container, including specifying the container image, name, and optional entry point.
- [ ] Intercept and describe the request for accessing the logs of a specified container.
- [ ] Capture and explain the request for listing all running containers.
- [ ] Successfully capture the HTTP request for executing a command inside a running container.

## 📚 References
- Docker API documentation: [https://docs.docker.com/engine/api/latest/](https://docs.docker.com/engine/api/latest/)
- Understanding Unix sockets: [https://en.wikipedia.org/wiki/Unix_domain_socket](https://en.wikipedia.org/wiki/Unix_domain_socket)
- `curl` command usage for Docker API: [https://curl.se/docs/](https://curl.se/docs/)
- Introduction to Docker: [https://www.docker.com/101-tutorial](https://www.docker.com/101-tutorial)

## 🛠 Solution
For detailed steps on how to complete this challenge, including methods for capturing HTTP requests and detailed explanations, refer to the [solutions.md](./solutions/README.md) file in the same folder. This challenge will require you to use tools and techniques for monitoring Unix socket communication, offering practical insights into Docker's operation at a low level. Good luck, and remember, mastering these skills is crucial for advanced Docker troubleshooting and development! 🚀
