# Security

Ensuring the security of Docker environments involves a comprehensive approach, covering the security of images, containers, the Docker daemon, and Docker registry. This document expands on the key security measures, providing examples and details for implementing each control.

- [Security](#security)
  - [Image Security](#image-security)
    - [Use Trusted Base Images](#use-trusted-base-images)
      - [Docker content trust](#docker-content-trust)
      - [Image hash](#image-hash)
      - [Digital signature](#digital-signature)
      - [Allowed sources](#allowed-sources)
    - [Minimize Image Layers](#minimize-image-layers)
      - [Multi-Stage Builds](#multi-stage-builds)
      - [Distroless images](#distroless-images)
      - [Images from scratch](#images-from-scratch)
      - [Install only required packages](#install-only-required-packages)
    - [Protect sensitive content - Secrets](#protect-sensitive-content---secrets)
      - [Avoid hardcoding of secrets](#avoid-hardcoding-of-secrets)
      - [Use Key vault integrations](#use-key-vault-integrations)
      - [Utilize Docker secrets](#utilize-docker-secrets)
      - [Utilize environment variables](#utilize-environment-variables)
      - [Files and directory permissions](#files-and-directory-permissions)
    - [Verify security in images](#verify-security-in-images)
      - [Lint Dockerfile](#lint-dockerfile)
      - [Perform SCA (CVE search) for image dependencies](#perform-sca-cve-search-for-image-dependencies)
      - [Search for malware](#search-for-malware)
      - [Ensure no secrets in the file system](#ensure-no-secrets-in-the-file-system)
      - [Ensure application security (holistic AST)](#ensure-application-security-holistic-ast)
    - [Keep components updated](#keep-components-updated)
  - [Container Security](#container-security)
    - [Avoid root users](#avoid-root-users)
    - [Utilize only required kernel capabilities](#utilize-only-required-kernel-capabilities)
    - [Ensure network segmentation and enforce isolation practices](#ensure-network-segmentation-and-enforce-isolation-practices)
    - [Manage volumes securely](#manage-volumes-securely)
      - [Use read-only file systems](#use-read-only-file-systems)
      - [Manage mounts permissions](#manage-mounts-permissions)
    - [Limit container resources](#limit-container-resources)
    - [Use security profiles](#use-security-profiles)
    - [Monitor container activities](#monitor-container-activities)
      - [Detect abnormal behavior](#detect-abnormal-behavior)
      - [Register container transactions - history](#register-container-transactions---history)
      - [Monitor container resource consumption](#monitor-container-resource-consumption)
      - [Ensure healthy containers](#ensure-healthy-containers)
      - [Utilize logging systems](#utilize-logging-systems)
  - [Daemon/Host Security](#daemonhost-security)
    - [Verify Docker CIS benchmark for daemon](#verify-docker-cis-benchmark-for-daemon)
    - [Limit Docker daemon exposition](#limit-docker-daemon-exposition)
      - [Network visibility to the API](#network-visibility-to-the-api)
      - [Docker group protection](#docker-group-protection)
      - [Implement A\&A protection for Docker](#implement-aa-protection-for-docker)
    - [Monitor processes](#monitor-processes)
    - [Apply hardening techniques to host](#apply-hardening-techniques-to-host)
      - [AppArmor](#apparmor)
      - [SeLinux](#selinux)
      - [Ubnutu hardening](#ubnutu-hardening)
      - [Ansible DevSec Hardening framework](#ansible-devsec-hardening-framework)
    - [Regularly update and patch host and its technologies](#regularly-update-and-patch-host-and-its-technologies)
  - [Docker Registry security](#docker-registry-security)
    - [Harden the registry](#harden-the-registry)
      - [Set-up TLS](#set-up-tls)
      - [Implement RBAC](#implement-rbac)
      - [Limit network connectivity and sources](#limit-network-connectivity-and-sources)
    - [Differentiate environments - tenants](#differentiate-environments---tenants)
    - [Restrict access to registry - approval pipelines](#restrict-access-to-registry---approval-pipelines)
    - [Monitor registry - audit logs](#monitor-registry---audit-logs)
    - [Actively scan the registry](#actively-scan-the-registry)

## Image Security

Ensuring the security of Docker images is crucial to the overall security posture of containerized applications. Below, we detail the recommended controls for securing Docker images.

### Use Trusted Base Images

Trusting the sources of the images that you can use in your environment is highly important. There are infinity of container sources and millions of vulnerable or malicious images.
Limiting what is available in your environment and reducing it to only a valid source of trust is critical enabling security and reducing the overall risk of using containers and its features.

#### Docker content trust

#### Image hash

#### Digital signature

#### Allowed sources

---

### Minimize Image Layers

A valid generalization in security space is that the more utilities, resources, assets and libraries are available in a system, the more likely is the system to be able to be compromised.
In other words, if there are more elements, it is more likely to find an exploitable path due to increase in the attack surface.

Therefore, it is critical to be able to reduce it and limit only to the bare minimum required elements in the build image to avoild explotation, lateral movement and privilege escalation among other issues.

#### Multi-Stage Builds

#### Distroless images

#### Images from scratch

#### Install only required packages

Mention to Docker-Slim

---

### Protect sensitive content - Secrets

#### Avoid hardcoding of secrets

#### Use Key vault integrations

#### Utilize Docker secrets

#### Utilize environment variables

#### Files and directory permissions

---

### Verify security in images

#### Lint Dockerfile

Hadolint 

#### Perform SCA (CVE search) for image dependencies

Clair
Trivy
Grype
Syft


#### Search for malware

#### Ensure no secrets in the file system

#### Ensure application security (holistic AST)

By following these controls and implementing the examples provided, you can significantly enhance the security of your Docker images, creating a more secure foundation for your containerized applications.

---

### Keep components updated

Define a policy of maximum created time for an image and alert for a new build when threshold is reached.

---

## Container Security

This section focuses on the controls and proactive actions that can be performed in a Docker environment, to improve the security posture overall by targetting container security best practices.

### Avoid root users

---

### Utilize only required kernel capabilities

---

### Ensure network segmentation and enforce isolation practices

---

### Manage volumes securely

---

#### Use read-only file systems


#### Manage mounts permissions

---

### Limit container resources

---

### Use security profiles

Seccomp

---

### Monitor container activities

#### Detect abnormal behavior

Sysdig falco

#### Register container transactions - history

#### Monitor container resource consumption

#### Ensure healthy containers

DOS --> healthcheck

#### Utilize logging systems

---

## Daemon/Host Security

### Verify Docker CIS benchmark for daemon

---

### Limit Docker daemon exposition

#### Network visibility to the API

#### Docker group protection

#### Implement A&A protection for Docker

---

### Monitor processes

---

### Apply hardening techniques to host

#### AppArmor

#### SeLinux

#### Ubnutu hardening

#### Ansible DevSec Hardening framework

---

### Regularly update and patch host and its technologies

---

## Docker Registry security

### Harden the registry

#### Set-up TLS

#### Implement RBAC

#### Limit network connectivity and sources

---

### Differentiate environments - tenants

---

### Restrict access to registry - approval pipelines

---

### Monitor registry - audit logs

---

### Actively scan the registry