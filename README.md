# Docker Image for Terraform, Kubernetes, and ArgoCD Utilities

<p align="center">
  <img src="Terra_argo.png" alt="Terra Argo icon" height="100">
</p>

## Overview
This Docker image provides a comprehensive suite of tools for managing and deploying applications on Kubernetes. It includes Terraform for infrastructure as code, kubectl and k9s for Kubernetes cluster management, Helm for package management, Vault for secrets management, Azure CLI for managing Azure resources, and ArgoCD for continuous delivery.

## Included Tools
- **Terraform** `1.3.6`: For defining, provisioning, and managing infrastructure as code.
- **Kubectl** `v1.23.12`: Command line tool for controlling Kubernetes clusters.
- **k9s** `v0.26.7`: A terminal-based UI to interact with your Kubernetes clusters.
- **Helm** `v3.8.1`: A package manager for Kubernetes.
- **Vault** `1.10.0`: Secures, stores, and tightly controls access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data.
- **Azure CLI**: For managing Azure services.
- **ArgoCD** `v2.3.3`: A declarative, GitOps continuous delivery tool for Kubernetes.

## Usage
This image is intended for use in environments where Kubernetes cluster management is required, including tasks such as deploying applications, managing infrastructure, and handling secrets.

### Running the Container
You can run the container using the following command:
```sh
docker run -it -v "${PWD}:/home/terraargo"  qalita/terra-argo-runner:latest /bin/bash
