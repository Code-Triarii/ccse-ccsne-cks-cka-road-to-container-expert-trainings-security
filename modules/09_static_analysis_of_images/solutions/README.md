# Solution Guide: Static Analysis of Docker Images for Vulnerabilities and Misconfigurations

This guide provides detailed steps to perform static analysis on Docker images using Grype, Trivy, and Clair. By following this guide, you will identify vulnerabilities and misconfigurations in Docker images, enhancing the security posture of your containerized applications.

## Prerequisites

- Docker installed on your system.
- Basic understanding of Docker image handling and command-line operations.

## Step 1: Install Analysis Tools

### Grype

- Install Grype for vulnerability scanning.

```bash
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
```

### Trivy

- Install Trivy for comprehensive vulnerability scanning.

```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

### Clair

- Clone the Clair repository and deploy using Docker Compose.

```bash
git clone https://github.com/quay/clair.git -b release-4.7
cd clair
docker-compose up -d
```

## Step 2: Configure Tools and Environment

- Ensure Docker is running.
- Pull a test Docker image to scan, e.g., `docker.io/library/bash:latest`.

## Step 3: Perform Scans and Generate Reports

### Using Grype

- Scan the image with Grype and output the report in JSON format.

```bash
grype docker.io/library/bash:latest -o json > grype_report.json
```

### Using Trivy

- Scan the image with Trivy and output the report in JSON format.

```bash
trivy image --format json --output trivy_report.json docker.io/library/bash:latest
```

### Using Clair

- For Clair, you first need to push your Docker image to a registry accessible by Clair and then scan it using `clairctl`.

- Execute the scan (example command, adjust as necessary).

```bash
clairctl --config /etc/clair/config.yaml report --host ${CLAIR_HOST} docker.io/library/bash:latest
```

## Step 4: Analyze and Compare Results

- Review the JSON reports generated by Grype, Trivy, and Clair.
- Compare the vulnerabilities and misconfigurations identified by each tool to understand their coverage and unique capabilities.

## Conclusion

By completing this challenge, you've leveraged powerful tools to uncover vulnerabilities and misconfigurations in Docker images. This process is crucial for maintaining secure containerized applications. Continuous integration of these scanning tools into your development pipeline can significantly enhance the security and integrity of your container images. Congratulations on advancing your skills in container security analysis!

## Optional: Integration into CI/CD

- Refer to the provided CI configuration examples to integrate these scanning tools into your GitLab CI/CD pipeline.
- Adjust the `.gitlab-ci.yml` file according to your project's requirements and ensure all necessary environment variables are correctly set.

> [!IMPORTANT]
> For quickly deploying the gitlab with docker executor runner, use [Gitlab testing set-up](../../../environment/gitlab/README.md).

```yaml
stages:
  - build
  - test
  - release
  - preprod
  - integration
  - prod

build:
  stage: build
  image: python:3.11.0b1-buster
  before_script:
   - pip3 install --upgrade virtualenv
  script:
   - virtualenv env
   - source env/bin/activate
   - pip install -r requirements.txt
   - python manage.py check

build_and_push:
  stage: build
  before_script:
    - export DOCKER_HOST="unix:///var/run/docker.sock"
  script:
   - docker build . -f Dockerfile -t ${harbor_url}/pygoat/pygoat:${CI_JOB_ID}
   - docker login ${harbor_url} -u ${harbor_user} -p ${harbor_password}
   - docker push ${harbor_url}/pygoat/pygoat:${CI_JOB_ID}

image_testing_grype:
  stage: test
  before_script:
    - curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
    - mkdir /opt/${CI_JOB_ID}
  script:
    - grype ${harbor_url}/pygoat/pygoat:${CI_JOB_ID} -o json -f high > /opt/${CI_JOB_ID}/grype.json
  artifacts:
    paths:
      - /opt/${CI_JOB_ID}/grype.json
  allow_failure: true

image_testing_trivy:
  stage: test
  before_script:
    - mkdir /opt/${CI_JOB_ID}
  script:
    - docker save ${harbor_url}/pygoat/pygoat:${CI_JOB_ID} -o /opt/${CI_JOB_ID}/pygoat.tar
    - docker run --rm -v /opt/${CI_JOB_ID}/pygoat.tar:/opt/${CI_JOB_ID}/pygoat.tar aquasec/trivy:0.49.1 image --input /opt/${CI_JOB_ID}/pygoat.tar -f json 1> /opt/${CI_JOB_ID}/trivy.json
  artifacts:
    paths:
      - /opt/${CI_JOB_ID}/trivy.json
  allow_failure: true

image_testing_clair:
  stage: test
  image: quay.io/projectquay/golang:1.20
  before_script:
    - go install github.com/quay/clair/v4/cmd/clairctl@latest
    - |
      cat > config.yaml <<EOL
      ${clairctl_config}
      EOL
  script:
    - clairctl --config config.yaml report --host ${clair_host} ${harbor_url}/pygoat/pygoat:${CI_JOB_ID}
    - clairctl -h
  allow_failure: true 


integration:
  stage: integration
  script:
    - echo "This is an integration step"
    - exit 1
  allow_failure: true # Even if the job fails, continue to the next stages

prod:
  stage: prod
  script:
    - echo "This is a deploy step."
  # when: manual
```