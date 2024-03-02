# Exercise 2: Docker Management with Python

## 🎯 Challenge

Your task is to create a Python script utilizing the Docker SDK for Python that enables users to interact with Docker in various ways. Specifically, the script should allow listing all Docker images and containers, as well as running a new container with specific configurations. This exercise will help you understand programmatic interaction with Docker, emphasizing the application of best practices in Docker management and Python scripting.

## ✅ Success Criteria

- [ ] The Python script uses the Docker SDK to interact with Docker.
- [ ] Users can list all Docker images and containers.
- [ ] Users can run a new Docker container with the script, specifying:
  - Environment variables as a comma-separated list (e.g., `env1=value1,env2=value2`).
  - Volume mappings.
  - Container name (required).
  - Container image (required).
  - Entry point (optional).
  - Command (CMD) (optional).
- [ ] Port mappings are allowed when running a new container.
- [ ] The script includes argument parsing to handle user inputs.

## 📚 References

- Docker SDK for Python documentation: [https://docker-py.readthedocs.io/en/stable/](https://docker-py.readthedocs.io/en/stable/)
- Argparse for argument parsing: [https://docs.python.org/3/library/argparse.html](https://docs.python.org/3/library/argparse.html)
- Docker Run reference: [https://docs.docker.com/engine/reference/run/](https://docs.docker.com/engine/reference/run/)

## 🛠 Solution

For detailed steps on how to complete this challenge, including example code and explanations, refer to the [solutions.md](./solutions/README.md) file in the same folder.

Dive into the challenge and explore the capabilities of the Docker SDK for Python. Good luck, and remember, the goal is to enhance your skills in Docker management and Python programming! 🚀
