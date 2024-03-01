# Auxiliar Commands & Tips

This documentation aims to provide guidance, utilities and useful commands that could be leveraged in certification preparation and exam exercises for agility.

- [Auxiliar Commands & Tips](#auxiliar-commands--tips)
  - [Linux helpers](#linux-helpers)
    - [Create a file inline with cat](#create-a-file-inline-with-cat)
  - [Docker commands](#docker-commands)
    - [Remove all stopped containers in the system](#remove-all-stopped-containers-in-the-system)
    - [Retrieve running proccesses inside a container](#retrieve-running-proccesses-inside-a-container)
    - [Create a docker network](#create-a-docker-network)

## Linux helpers

### Create a file inline with cat

To create a file from the command line without using nano, vim or similar utilities we can leverage command `cat` and the usage of file delimiters `EOF/EOL`.

```bash
cat > <file_name> <<EOL
<file_content>
EOL

# Example
cat > Dockerfile <<EOL
FROM ubuntu:20.04

RUN apt install nginx
EOL
```

## Docker commands

### Remove all stopped containers in the system

```bash
docker rm -f $(docker ps -aq -f status=exited)
```

Explanation:

- with `$()` we are capturing the output (stdout) of the command inside the parentesis. This command is `docker ps -aq -f status=exited`. The options are:
  - `docker` is the Docker CLI communicating with the Daemon.
  - `ps` gets the containers (by default only those running). There are two options for used for this command:
    - `-aq`: `a` states for all containers and `q` indicates that only the container id must be retrieved.
    - `-f status=existed` with this option we are filtering to only obtain those containers that have exited.
- Main command `docker rm -f <list-of-containers-id>`. Options explanation:
  - `rm` command for removing the containers.
  - `-f` forces container removal.

### Retrieve running proccesses inside a container

```bash
docker top <container_name>
```

### Create a docker network

[Theory about networks](./concepts.md#docker-networking)

```bash
docker network create --driver <driver_name> <network_name>

#Example using default driver bridge
docker network create mynetwork
```
