# Solution Guide: Secure Docker Registry Setup

This guide provides step-by-step instructions to set up a Docker Registry V2 securely using self-signed certificates and configure the Docker daemon to trust this registry.

## Step 1: Create Self-Signed Certificates

1. Create a directory for the certificates.

    ```bash
    mkdir -p certs
    ```

2. Navigate to the `certs` directory.

    ```bash
    cd certs
    ```

3. Generate a new self-signed certificate and private key.

    ```bash
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 365 -out domain.crt
    ```

   - When prompted, enter your registry's domain name or IP address as the "Common Name".

## Step 2: Set Up the Docker Registry Container

1. Return to your project's root directory.

    ```bash
    cd ..
    ```

2. Run the Docker Registry container with the certificates.

    ```bash
    docker run -d \
      --restart=always \
      --name registry \
      -v $(pwd)/certs:/certs \
      -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
      -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
      -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
      -p 443:443 \
      registry:2
    ```

   - This command starts a Docker Registry listening on port 443 with TLS enabled.

## Step 3: Configure Docker Daemon

1. Copy your `domain.crt` file to the Docker certificates directory. Create the directory if it does not exist.

    ```bash
    sudo mkdir -p /etc/docker/certs.d/your-registry-domain-or-ip:443
    sudo cp certs/domain.crt /etc/docker/certs.d/your-registry-domain-or-ip:443/ca.crt
    ```

2. Restart the Docker daemon to apply the changes.

    - On Linux:

        ```bash
        sudo systemctl restart docker
        ```

    - On Windows or Mac, restart Docker from the Docker Desktop menu.

## Step 4: Test Your Setup

1. Tag a local image for your registry.

    ```bash
    docker tag myimage your-registry-domain-or-ip:443/myimage:latest
    ```

2. Push the image to your registry.

    ```bash
    docker push your-registry-domain-or-ip:443/myimage:latest
    ```

3. Pull the image back from the registry.

    ```bash
    docker pull your-registry-domain-or-ip:443/myimage:latest
    ```

If you can push and pull the image without errors, your secure Docker Registry is correctly set up and configured!

## Security Best Practices

- Rotate your certificates periodically.
- Restrict access to your registry using firewall rules or Docker's built-in authentication mechanism.
- Regularly update your Docker Registry to the latest version to ensure security fixes are applied.

Congratulations on setting up your secure Docker Registry! 🎉
