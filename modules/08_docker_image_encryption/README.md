# Exercise 8: Encrypt Container Images with imgcrypt for containerd

## 🎯 Challenge

Your objective in this exercise is to secure container images by encrypting them using the `imgcrypt` plugin for containerd. Container images can contain sensitive information such as code, data, and API keys that should be protected. By encrypting the images, you ensure that the sensitive content is safeguarded against unauthorized access, even if a malicious user gains access to the container. You will use the `ctr-enc` command-line tool, part of the `imgcrypt` project, to perform image encryption and decryption operations. Completing this challenge will deepen your understanding of container security, specifically in the context of protecting container images.

## ✅ Success Criteria

- [ ] Install necessary tools and dependencies, including Go and `imgcrypt`.
- [ ] Build and install the `imgcrypt` command-line tool.
- [ ] Configure `containerd` to use the `imgcrypt` stream processors for image decryption.
- [ ] Generate an RSA key pair to be used for image encryption.
- [ ] Pull a container image using `ctr-enc`.
- [ ] Encrypt the pulled container image with the public key.
- [ ] Verify that the image has been encrypted and can only be accessed with the corresponding private key.
- [ ] Document the encryption process, configuration changes, and key management practices. Include troubleshooting steps for common issues.

## 📚 References

- Official `imgcrypt` GitHub repository: [https://github.com/containerd/imgcrypt](https://github.com/containerd/imgcrypt)
- Containerd documentation: [https://containerd.io/docs/](https://containerd.io/docs/)
- OpenSSL documentation for key management: [https://www.openssl.org/docs/](https://www.openssl.org/docs/)

## 🛠 Solution

For detailed steps on how to complete this challenge, including tool installation, `containerd` configuration, image encryption, and key management, refer to the [solutions.md](./solutions/README.md) file in the same folder. This challenge will equip you with valuable skills in securing container images, a crucial aspect of a secure container ecosystem. Dive into the world of container image encryption and enhance the security posture of your containerized applications. Good luck! 🚀
