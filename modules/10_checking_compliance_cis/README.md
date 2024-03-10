# Exercise 10: Ensuring CIS Compliance with Docker-Bench

## 🎯 Challenge

Your objective in this exercise is to audit Docker configurations to ensure compliance with the Center for Internet Security (CIS) Docker Benchmark using Docker-Bench. Docker-Bench is a tool developed by Aqua Security that checks for dozens of common best practices around deploying Docker containers in production. By conducting this audit, you'll gain valuable insights into your Docker configurations, identifying non-compliant settings and understanding the potential vulnerabilities in your Docker environment. Completing this challenge will enhance your knowledge of Docker security practices and the importance of adhering to CIS benchmarks for a secure containerized infrastructure.

## ✅ Success Criteria

- [ ] Install and configure Docker-Bench on your system.
- [ ] Execute Docker-Bench to perform a CIS compliance audit on your Docker configurations.
- [ ] Output the audit report in a machine-readable format (e.g., JSON).
- [ ] Extract and list all findings categorized as Critical and High severity from the audit report.
- [ ] Analyze the report to understand the compliance gaps and security risks in your Docker configurations.
- [ ] Document the process for running Docker-Bench, extracting critical findings, and steps for remediation or mitigation of identified issues. Include any troubleshooting steps for common issues encountered during the audit process.

> \[!IMPORTANT\]
> Consider integrating Docker-Bench scans into your CI/CD pipeline to continuously ensure CIS compliance in your Docker deployments.

## 📚 References

- Docker-Bench GitHub repository: [https://github.com/aquasecurity/docker-bench](https://github.com/aquasecurity/docker-bench)
- CIS Docker Benchmark documentation: [https://www.cisecurity.org/benchmark/docker/](https://www.cisecurity.org/benchmark/docker/)
- Docker documentation: [https://docs.docker.com/](https://docs.docker.com/)

## 🛠 Solution

For detailed steps on how to complete this challenge, including the installation and configuration of Docker-Bench, executing the CIS compliance audit, analyzing the results, and understanding how to address the findings, refer to the [solutions.md](./solutions/README.md) file in the same folder. This challenge is designed to provide you with hands-on experience in auditing Docker configurations against CIS benchmarks, a critical skill for maintaining security and compliance in containerized environments. Embark on this journey to enhance your Docker security posture. Good luck! 🚀
