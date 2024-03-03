# Exercise 5: Securely Exposing Docker Daemon over HTTPS

## 🎯 Challenge

Your mission in this exercise is to securely expose the Docker daemon over HTTPS, ensuring that all communications between the Docker CLI and the Docker daemon are encrypted and authenticated. This task involves configuring the Docker daemon with TLS certificates to provide both encryption and authentication capabilities. By completing this challenge, you will gain a deeper understanding of securing Docker daemon communications, managing TLS certificates, and enforcing access controls.

## ✅ Success Criteria

- [ ] Generate TLS certificates for the Docker daemon and clients.
- [ ] Configure the Docker daemon to require TLS for all connections, using the generated certificates.
- [ ] Verify that the Docker CLI can securely connect to the Docker daemon over HTTPS, using the TLS certificates for authentication.
- [ ] Ensure that all API calls to the Docker daemon are encrypted and require certificate-based authentication.
- [ ] Document the process for generating certificates, configuring the Docker daemon, and connecting the Docker CLI securely.

## 📚 References

- Docker daemon TLS configuration: [https://docs.docker.com/engine/security/https/](https://docs.docker.com/engine/security/https/)
- OpenSSL for generating TLS certificates: [https://www.openssl.org/](https://www.openssl.org/)
- Docker CLI reference: [https://docs.docker.com/engine/reference/commandline/cli/](https://docs.docker.com/engine/reference/commandline/cli/)
- Understanding TLS/SSL: [https://www.ssl.com/faqs/faq-what-is-ssl/](https://www.ssl.com/faqs/faq-what-is-ssl/)

## 🛠 Solution

For detailed steps on how to complete this challenge, including instructions for generating TLS certificates, configuring the Docker daemon for HTTPS, and securely connecting with the Docker CLI, refer to the [solutions.md](./solutions/README.md) file in the same folder. This challenge will provide you with practical experience in securing Docker daemon communications, a critical skill for maintaining the security of Docker environments in production. Good luck, and remember, securing your Docker daemon is a fundamental step in protecting your containerized applications! 🚀

### Sample Task Overview

#### Generate TLS Certificates

1. Create CA, server, and client keys.
2. Generate and sign certificates.

#### Configure the Docker Daemon

1. Update the Docker daemon configuration to use TLS, specifying the paths to the certificates and keys.

#### Connect Docker CLI Securely

1. Use the `--tlsverify`, `--tlscacert`, `--tlscert`, and `--tlskey` flags with Docker CLI commands to securely connect to the daemon.

By following these steps, you will ensure that the Docker daemon is securely exposed over HTTPS, enhancing the security of your Docker environment by encrypting and authenticating all communications.