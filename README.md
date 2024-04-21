<div align="center">
<!--
  REMEMBER THAT AT THE END OF THE MARKDOWN PAGES, THERE IS A SECTION WITH ALL THE LINKS TO BE MODIFIED OR ADDED NEW.
  This increases readability.
 -->

<!-- PROJECT LOGO -->

# 📝 Road To Container - Security - Expert - CCSE - CCSNE - CKS

<!-- TECNOLOGIES -->

![Docker Badge](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff&style=flat)
![Kubernetes Badge](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=fff&style=flat)
![Ansible Badge](https://img.shields.io/badge/Ansible-E00?logo=ansible&logoColor=fff&style=flat)
![Python Badge](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=fff&style=flat)

This project serves as a preparation for the CCSE (Certified Container Security Expert) and CCSNE from Practical DevSecOps, CKS (Certified Kubernetes Security) from Linux foundation
and overall to get a good understanding of container management principles, security risks and hardening techniques. For sure including sample exercises, explanations, tips and more 💪

[Report Bug](https://github.com/Code-Triarii/road-to-container-expert-trainings-security/issues) · [Request Feature](https://github.com/Code-Triarii/road-to-container-expert-trainings-security/issues)

</div>

<!-- TABLE OF CONTENTS -->

## 📚 Table of contents

- [📝 Road To Container - Security - Expert - CCSE - CCSNE - CKS](#-road-to-container---security---expert---ccse---ccsne---cks)
  - [📚 Table of contents](#-table-of-contents)
  - [💡 Purpose](#-purpose)
  - [🏗️ Project structure](#️-project-structure)
  - [📍 Roadmap](#-roadmap)
  - [📎 Contributing](#-contributing)
  - [📃 License](#-license)
  - [👥 Contact](#-contact)
  - [🔍 Acknowledgments](#-acknowledgments)

<!-- PROJECT DETAILS -->

## 💡 Purpose

The main purpose of this repository is to be guiding for anyone interested in obtaining the CCSE certification. Explaining in detail exercises, including automations for quickly setting up a testing environment and more.

If you are learning about container security and willing to obtain the CCSE certification, this is your place.

## 🏗️ Project structure

A quick tour on how the project is organized here:

- `docs`: contains the main .md files for documenting the project as well as the images used in the markdown for renderization.

- [`environment`](./environment): this folder includes the different automatic resources for setting up the environment required for the different exercises.

  - `Docker: gitlab CE` - Ansible playbook for setting up gitlab (including automatic registration of the runner) for docker (using docker-compose). Useful for pipeline exercises.
  - `Kubernetes:Kind` - For quick testing and exercises in local machine only requiring docker.
  - `Kubernetes: Single Node Kubeadm` - If you have a VM, just create a single node cluster for testing. **Prepared for ubuntu 22.04. Other systems require minor tweaking** (e.g. changing sources references.)

> \[!IMPORTANT\]
> For kubernetes exercises, if own an aws account, you can leverage my own repository [Creation of aws cluster with Docker-Ansible](https://github.com/paf-triarii/aws-kubeadm-simple-cluster-training). This will spin for you the required infrastructure for having a kubeadm cluster from scratch in aws environment, creating all the associated infrastructure and configuring the nodes. You will need only `Docker` and **valid aws credentials** to execute it! It is prepared for several regions covering including all eu-west, eu-south-2, eu-central-1. **The playbook has a simple entrypoint in Docker linked to two ansible playbooks. After deployment, you can comment the first one and use the second one to "reset" to default state the cluster as many times as you want - Feel free to 'break' without consequences**.

- [`modules`](./modules/): this folder contains the different exercises created for preparation of certs as well as specific topis developed in depth.
  
  - `00_set_docker_v2_registry`: This module provides instructions to set up a Docker Registry V2 securely using self-signed certificates and configure the Docker daemon to trust this registry.
  - `01_docker_python_sdk`: This module provides a Python script for Docker management, allowing listing all Docker images and containers, and running a new container with specific configurations using the Docker SDK for Python.
  - `02_interacting_with_API_server`: This module provides exercises to interact with the API server, enhancing your understanding of API operations in a containerized environment.
  - `03_analyze_docker_sock`: This module provides a deep dive into Docker socket analysis, helping you understand potential security risks and how to mitigate them.
  - `04_expose_docker_api_https`: This module guides you through the process of exposing the Docker API over HTTPS, ensuring secure communication with the Docker daemon.
  - `06_deploy_and_configure_harbor`: This module provides detailed instructions for deploying and configuring Harbor, a secure container image registry.
  - `07_sign_image_cosign`: This module provides detailed instructions for implementing code-signing for Docker images using Cosign, enhancing the security of your container images.
  - `08_docker_image_encryption`: This module provides a guide to encrypt Docker images, adding an extra layer of security to your containerized applications.
  - `09_static_analysis_of_images`: This module provides instructions for conducting static analysis of Docker images using tools like Grype, Trivy, and Clair, helping you identify and mitigate vulnerabilities.
  - `10_checking_compliance_cis`: This module provides a guide to audit Docker configurations to ensure compliance with the Center for Internet Security (CIS) Docker Benchmark using Docker-Bench.
  - `11_discovery_techniques`: This module provides techniques to discover the attack surface of a container environment to identify possible breaches and act upon to secure it.
  - `12_container_hacking_techniques`: This module provides techniques to attack and exploit security missconfigurations in containerized environments.

- `theorical concepts`: including important theory that supports the foundations understanding and good comprehension of the practical exercises:

  - [**Concepts**](concepts.md) - Explaining architecture, main objects, alternatives, issues, etc.
  - [**Container Security In Depth**](container-security-in-depth.md) - Targeting missconfigurations, security issues and how to address those.
  - [**Auxiliary Commands and Tips**](Auxiliary-commands-and-tips.md) - Helpers for agility executing tasks in containers environment for `Docker` and `Kubernetes`.

## 📍 Roadmap

- [x] Create automatic deployment of scenarios.
- [x] Include theory and useful tips.
- [x] Create comprehensive guide with security measures for holistic container protection.
- [x] Complete the full CCSE path with scenarios and exercises including documentation for each of them.
  - [x] Set docker registry V2 securely.
  - [x] Interact with docker API server using python Docker SDK
  - [x] Samples of interaction with Docker daemon through API rest.
  - [x] How to configure Docker Daemon over HTTPS.
  - [x] How to create a container from scratch.
  - [x] Holistic container analysis.
- [x] Include Kubernetes theory.

See the [open issues](https://github.com/Code-Triarii/road-to-container-expert-trainings-security/issues) for a full list of proposed features (and known issues).

[🔝 Back to top](#-road-to-container---security---expert---ccse---ccsne---cks)

<!-- CONTRIBUTING -->

## 📎 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated** :chart:.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project

2. Create your Feature Branch

   ```sh
   git checkout -b feature/AmazingFeature
   ```

3. Commit your Changes

   ```sh
   git commit -m 'Add some AmazingFeature
   ```

4. Push to the Branch

   ```sh
   git push origin feature/AmazingFeature
   ```

5. Open a Pull Request

[🔝 Back to top](#-road-to-container---security---expert---ccse---ccsne---cks)

<!-- LICENSE -->

## 📃 License

Distributed under the `Apache 2.0` License. See `LICENSE` for more information.

[🔝 Back to top](#-road-to-container---security---expert---ccse---ccsne---cks)

<!-- CONTACT -->

## 👥 Contact

<div align="center">

[![X](https://img.shields.io/badge/X-%23000000.svg?style=for-the-badge&logo=X&logoColor=white)](https://twitter.com/codetriariism)
[![TikTok](https://img.shields.io/badge/TikTok-%23000000.svg?style=for-the-badge&logo=TikTok&logoColor=white)](https://www.tiktok.com/@codetriariism)
[![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@codetriariism)
[![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?style=for-the-badge&logo=YouTube&logoColor=white)](https://www.youtube.com/@CodeTriariiSM)
[![Instagram](https://img.shields.io/badge/Instagram-%23E4405F.svg?style=for-the-badge&logo=Instagram&logoColor=white)](https://www.instagram.com/codetriariismig/)

</div>

As we always state, our main purpose is keep learning, contributing to the community and finding ways to collaborate in interesting initiatives.
Do not hesitate to contact us at `codetriariism@gmail.com`

If you are interested in our content creation, also check our social media accounts. We have all sorts of training resources, blogs, hackathons, write-ups and more!
Do not skip it, you will like it :smirk: :smirk: :smirk: :+1:

Don't forget to give the project a star if you liked it! Thanks again! :star2: :yellow_heart:

[🔝 Back to top](#-road-to-container---security---expert---ccse---ccsne---cks)

<!-- ACKNOWLEDGMENTS -->

## 🔍 Acknowledgments

:100: :100: :100: For those that are curious about some of the resources or utilities and for sure thanking and giving credit to authors, we provide you a list of the most interesting ones (in our understanding) :100: :100: :100:

- [Practical DevSecOps](https://www.practical-devsecops.com/) - to Practical DevSecOps for the amazing learning journey.
- [Linux Foundation](https://trainingportal.linuxfoundation.org/courses/certified-kubernetes-security-specialist-cks) - for their lovely explanations and content.
- [ChatGPT 4](https://chat.openai.com/) - for acceleratining the creation of scenarios and solutions.
- [MITRE container attack matrix](https://attack.mitre.org/matrices/enterprise/containers/) - for proving good insights about how to exploit and leverage applications vulnerabilities hosted in containers.
- [Excalidraw](https://excalidraw.com/) - for creating amazing diagrams in minutes.
- [Kubernetes Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/quick-reference/) - For quickly launching commands.
- [AquaSec Blog](https://www.aquasec.com/blog/mitre-attack-framework-for-containers/)
- [OWASP Kubernetes Top 10](https://owasp.org/www-project-kubernetes-top-ten/) - for insightful instructions about Kubernetes security missconfigurations.

[🔝 Back to top](#-road-to-container---security---expert---ccse---ccsne---cks)
