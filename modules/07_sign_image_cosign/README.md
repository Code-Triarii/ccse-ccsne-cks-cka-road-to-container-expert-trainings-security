# Exercise 7: Implement Code-Signing for Docker Images with Harbor

## 🎯 Challenge

Your objective in this exercise is to ensure the integrity and trustworthiness of container images through code-signing. You will work with Harbor, an open-source container image registry, to sign Docker images, upload both signed and unsigned images, and configure Harbor to enforce that only signed images are deployed. This challenge will enhance your understanding of container image security, specifically around the assurance that images have not been tampered with and are from a trusted source.

## ✅ Success Criteria

- [ ] Generate a signing key pair and use it to sign at least one Docker image.
- [ ] Deploy Harbor using Docker or Docker Compose, ensuring HTTPS is enabled for secure communication.
- [ ] Upload both the signed and an unsigned container image to Harbor, noting the difference in their status.
- [ ] Configure Harbor to require images to be signed with a trusted key before they can be deployed.
- [ ] Attempt to deploy both the signed and unsigned images, demonstrating that only the signed image can be deployed successfully.
- [ ] Document the process of generating signing keys, signing images, configuring Harbor for image verification, and the deployment process. Include troubleshooting steps for common issues.

## 📚 References

- Harbor official documentation: [https://goharbor.io/docs/](https://goharbor.io/docs/)
- Docker Content Trust (DCT) documentation: [https://docs.docker.com/engine/security/trust/](https://docs.docker.com/engine/security/trust/)
- Docker Compose reference: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- HTTPS configuration for Harbor: [https://goharbor.io/docs/2.2.0/install-config/configure-https/](https://goharbor.io/docs/2.2.0/install-config/configure-https/)

## 🛠 Solution

For detailed steps on how to complete this challenge, including key generation, image signing, Harbor deployment instructions, HTTPS configuration, and enforcement of signed images, refer to the [solutions.md](./solutions/README.md) file in the same folder. This challenge will equip you with crucial skills in ensuring the security and integrity of container images, a fundamental aspect of a secure container ecosystem. Embrace the journey into advanced container security practices and make your container deployments more secure and trusted with Harbor and Docker Content Trust. Good luck! 🚀
