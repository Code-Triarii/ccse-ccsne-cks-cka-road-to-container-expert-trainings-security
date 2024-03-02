# Auxiliary Commands & Tips

This documentation aims to provide guidance, utilities and useful commands that could be leveraged in certification preparation and exam exercises for agility.

- [Auxiliary Commands \& Tips](#auxiliary-commands--tips)
  - [Linux helpers](#linux-helpers)
    - [Create a file inline with cat](#create-a-file-inline-with-cat)
  - [Docker commands](#docker-commands)
    - [Remove all stopped containers in the system](#remove-all-stopped-containers-in-the-system)
    - [Retrieve running processes inside a container](#retrieve-running-processes-inside-a-container)
    - [Create a docker network](#create-a-docker-network)
    - [Save Docker Image and Container](#save-docker-image-and-container)
    - [Import Docker Image and Container](#import-docker-image-and-container)
    - [List containers ordered by creation time](#list-containers-ordered-by-creation-time)

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

- with `$()` we are capturing the output (stdout) of the command inside the parenthesis. This command is `docker ps -aq -f status=exited`. The options are:
  - `docker` is the Docker CLI communicating with the Daemon.
  - `ps` gets the containers (by default only those running). There are two options for used for this command:
    - `-aq`: `a` states for all containers and `q` indicates that only the container id must be retrieved.
    - `-f status=existed` with this option we are filtering to only obtain those containers that have exited.
- Main command `docker rm -f <list-of-containers-id>`. Options explanation:
  - `rm` command for removing the containers.
  - `-f` forces container removal.

### Retrieve running processes inside a container

```bash
docker top <container_name>
```

______________________________________________________________________

### Create a docker network

[Theory about networks](./concepts.md#docker-networking)

```bash
docker network create --driver <driver_name> <network_name>

#Example using default driver bridge
docker network create mynetwork
```

______________________________________________________________________

### Save Docker Image and Container

**Docker Save**: Use `docker save` to create a tar archive of an image.

```bash
docker save -o myimage.tar myimage:latest
```

**Docker Export**: Use `docker export` to create a tar archive of a container's filesystem.

```bash
docker export -o mycontainer.tar mycontainer_id
```

`docker save` is ideal for sharing images, preserving their history and layers, while `docker export` is for containers, flattening their filesystem into a single layer.

> \[!NOTE\]
> Exported images or containers can be imported back for its use.

### Import Docker Image and Container

**Docker Import for Images**: Use `docker import` to create an image from a tar archive previously exported with `docker export`.

```bash
docker import mycontainer.tar mynewimage:latest
```

**Docker Load for Images**: To load an image saved with `docker save`, use `docker load`.

```bash
docker load -i myimage.tar
```

`docker import` is used to create an image from a flat filesystem, while `docker load` restores an image with its history and layers.

---

### List containers ordered by creation time

```bash
echo '['$(docker container ls --format '{{json .}}' | paste -sd "," -)']' | jq 'sort_by(.CreatedAt) | .[] | {ID: .ID, Image: .Image, CreatedAt: .CreatedAt}'
```

For this command to run, `jq` must be installed in the system:

```bash
sudo apt-get update && sudo apt-get install -y jq
```