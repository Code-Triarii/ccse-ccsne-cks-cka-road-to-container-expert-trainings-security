# Solution Guide: Encrypt Container Images with imgcrypt for containerd

This solution guide provides a comprehensive walkthrough for encrypting container images using the `imgcrypt` plugin for containerd. By encrypting images, you ensure that sensitive data contained within is protected against unauthorized access.

## Requirements

- Docker and containerd installed on your system.
- Basic understanding of container technologies and command-line operations.

## Steps to Complete the Challenge

### Step 1: Install Go Programming Language

Download and install Go to compile the `imgcrypt` tool from source.

```bash
curl -s https://dl.google.com/go/go1.20.13.linux-amd64.tar.gz | tar xvz -C /usr/local
```

Configure the Go environment variables.

```bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

### Step 2: Clone and Build imgcrypt

Clone the `imgcrypt` repository and compile the tool.

```bash
git clone https://github.com/containerd/imgcrypt.git
cd imgcrypt
```

Ensure your system has the necessary tools for the build process.

```bash
sudo apt-get update && sudo apt-get install -y gcc
```

Build and install the `imgcrypt` command-line tool.

```bash
make && sudo make install
```

### Step 3: Configure containerd to Use imgcrypt

Add the `imgcrypt` stream processors to the `containerd` configuration to enable image encryption and decryption support.

```toml
cat > /etc/containerd/config.toml<<EOF
disabled_plugins = ["cri"]
root = "/var/lib/containerd"
state = "/run/containerd"
[grpc]
  address = "/run/containerd/containerd.sock"
  uid = 0
  gid = 0
[stream_processors]
    [stream_processors."io.containerd.ocicrypt.decoder.v1.tar.gzip"]
        accepts = ["application/vnd.oci.image.layer.v1.tar+gzip+encrypted"]
        returns = "application/vnd.oci.image.layer.v1.tar+gzip"
        path = "/usr/local/bin/ctd-decoder"
    [stream_processors."io.containerd.ocicrypt.decoder.v1.tar.zstd"]
        accepts = ["application/vnd.oci.image.layer.v1.tar+zstd+encrypted"]
        returns = "application/vnd.oci.image.layer.v1.tar+zstd"
        path = "/usr/local/bin/ctd-decoder"
    [stream_processors."io.containerd.ocicrypt.decoder.v1.tar"]
        accepts = ["application/vnd.oci.image.layer.v1.tar+encrypted"]
        returns = "application/vnd.oci.image.layer.v1.tar"
        path = "/usr/local/bin/ctd-decoder"
EOF
```

Restart the Docker or containerd service to apply the changes.

```bash
sudo service docker restart
# or
sudo systemctl restart containerd
```

### Step 4: Generate an RSA Key Pair

Generate a private and public RSA key pair for encrypting and decrypting the container images.

```bash
openssl genrsa -out mykey.pem
openssl rsa -in mykey.pem -pubout -out mypubkey.pem
```

### Step 5: Pull and Encrypt a Container Image

Pull an image using the `ctr-enc` tool.

```bash
ctr-enc images pull --platform linux/amd64 docker.io/library/bash:latest
```

Encrypt the pulled image with your public key.

```bash
ctr-enc images encrypt --recipient jwe:mypubkey.pem --platform linux/amd64 docker.io/library/bash:latest bash.enc:latest
```

## Conclusion

By following these steps, you've successfully encrypted a container image, adding an essential layer of security to protect sensitive information. This guide has walked you through installing necessary tools, configuring `containerd` for encryption, and performing image encryption operations. Congratulations on completing the challenge and advancing your skills in container security!
