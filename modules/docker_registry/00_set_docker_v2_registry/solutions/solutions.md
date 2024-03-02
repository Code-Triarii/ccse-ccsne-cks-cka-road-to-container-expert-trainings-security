# Solution Guide: Secure Docker Registry Setup

This guide provides step-by-step instructions to set up a Docker Registry V2 securely using self-signed certificates and configure the Docker daemon to trust this registry.

[Documentation deployment reference](https://distribution.github.io/distribution/about/deploying/)

- [Solution Guide: Secure Docker Registry Setup](#solution-guide-secure-docker-registry-setup)
  - [Step by step - Ansible](#step-by-step---ansible)
    - [Requirements](#requirements)
    - [Step 1: Execute ansible playbook](#step-1-execute-ansible-playbook)
  - [Step by step - Manual](#step-by-step---manual)
    - [Step 1: Create Self-Signed Certificates](#step-1-create-self-signed-certificates)
    - [Step 2: Set up basic auth for the registry](#step-2-set-up-basic-auth-for-the-registry)
    - [Step 3: Set Up the Docker Registry Container](#step-3-set-up-the-docker-registry-container)
    - [Step 4: Configure Docker Daemon](#step-4-configure-docker-daemon)
    - [Step 5: Test Your Setup](#step-5-test-your-setup)
  - [Requirements for this exercise](#requirements-for-this-exercise)


## Step by step - Ansible

All challenges come with an ansible playbook that allows to set-up the solution straight forward. For being able to use it there are a list of requirements to be met.

### Requirements

- [X] Ansible installed in the system.
- [X] Docker pip installed in the system.

### Step 1: Execute ansible playbook

```bash
ansible-playbook setup_secure_docker_registry.yml --ask-become-pass
```

> [!NOTE]
> You can override the variables as neeeded. The following execution is a sample for the practical devsecops machine in labs.

```bash
ansible-playbook setup_secure_docker_registry.yml -e "registry_domain=devsecops-box-XoIySz8L ip_address=10.1.28.228 modify_hosts=false"
```

[!Ansible execution](../img/ansible-execution.png)

## Step by step - Manual

### Step 1: Create Self-Signed Certificates

1. Create a directory for the certificates.

```bash
mkdir -p certs
```

2. Navigate to the `certs` directory.

```bash
cd certs
```

3. If you are in a local system without domain, ensure to handle the name resolution for compliance with SANs. I am using an ubuntu evironment:

```bash
# Define the line to be added
LINE="172.20.140.18 codetriarii-org.com"

# Check if the line is already in the file
if ! grep -qF "$LINE" /etc/hosts; then
  # If not, add it
  echo "$LINE" | sudo tee -a /etc/hosts
fi
```

4. Create `san.cnf` for compliance with requirements.

```bash
cat > san.cnf <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
C = ES
ST = Madrid
L = Madrid
O = YourOrganization
OU = YourDepartment
CN = codetriarii-org.com

[req_ext]
subjectAltName = @alt_names

[alt_names]
IP.1 = 172.20.140.18
DNS.1 = codetriarii-org.com

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
EOF
```

5. Generate a new self-signed certificate and private key.

```bash
openssl req -new -x509 -nodes -days 365 -config san.cnf -keyout domain.key -out domain.crt -extensions v3_req
```

6. Ensure the proper certificate has been created.

```bash
openssl x509 -in domain.crt -text -noout
```

[!OpenSSL output](../img/openssl-output.png)

### Step 2: Set up basic auth for the registry

1. Go back to root directory and create a directory for auth credentials.

```bash
mkdir -p auth
```

2. Create the required htpasswd file.

```bash
docker run \
--entrypoint htpasswd \
httpd:2 -Bbn testuser testpassword > auth/htpasswd
```

### Step 3: Set Up the Docker Registry Container

1. Return to your project's root directory.

```bash
cd ..
```

2. Run the Docker Registry container with the certificates.

```bash
docker run -d \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v $(pwd)/certs:/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -p 443:443 \
  registry:2
```

This command starts a Docker Registry listening on port 443 with TLS enabled.

### Step 4: Configure Docker Daemon

1. Copy your `domain.crt` file to the Docker certificates directory. Create the directory if it does not exist.

```bash
sudo mkdir -p /etc/docker/certs.d/codetriarii-org.com
sudo cp certs/domain.crt /etc/docker/certs.d/codetriarii-org.com/ca.crt
```

> [!CAUTION]
> If you want to use a different port than 443, you must include it in the structure.
> Example: /etc/docker/certs.d/`ip-or-dns`:`port`


1. Restart the Docker daemon to apply the changes.

    - On Linux:

        ```bash
        sudo systemctl restart docker
        ```

    - On Windows or Mac, restart Docker from the Docker Desktop menu.

### Step 5: Test Your Setup

1. Tag a local image for your registry.

    ```bash
    docker tag myimage codetriarii-org.com:443/myimage:latest
    ```

2. Push the image to your registry.

    ```bash
    docker push codetriarii-org.com:443/myimage:latest
    ```

3. Pull the image back from the registry.

    ```bash
    docker pull codetriarii-org.com:443/myimage:latest
    ```

**Sample output**:

[!Docker login](../img/docker-login.png)

[!Docker push](../img/docker-push.png)

If you can push and pull the image without errors, your secure Docker Registry is correctly set up and configured!

> [!CAUTION]
> Do not forget to follow best security practices in production, although registry:2 is not recommended for production set-up.

- Rotate your certificates periodically.
- Restrict access to your registry using firewall rules or Docker's built-in authentication mechanism.
- Regularly update your Docker Registry to the latest version to ensure security fixes are applied.

Congratulations on setting up your secure Docker Registry! 🎉

## Requirements for this exercise

- You have sudo access and docker installed.
- Installation of dnsutils.
- Openssl available.
- For automatic installation of the solution, install also ansible must be installed as well in the system. Inlcuding `pip install docker`
