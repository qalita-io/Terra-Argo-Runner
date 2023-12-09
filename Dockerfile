# COPYRIGHT QALITA SAS

FROM debian:buster-slim

ENV TERRAFORM_VERSION="1.3.6"
ENV KUBE_VERSION="v1.23.12"
ENV K9S_VERSION="v0.26.7"
ENV HELM_VERSION="v3.8.1"
ENV VAULT_VERSION="1.10.0"
ENV ARGOCD_VERSION="v2.3.3"

# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends git libcap2-bin python3-pip gnupg software-properties-common curl -y  \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Add Hashicorp APT Repository
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
&& apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Add Terraform
RUN apt-get update && apt-get install --no-install-recommends terraform=${TERRAFORM_VERSION} -y  \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add Kubectl
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
&& chmod +x /usr/bin/kubectl

# Add k9s
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz -o k9s_Linux_x86_64.tar.gz \
&& tar -xzf k9s_Linux_x86_64.tar.gz \
&& mv ./k9s /usr/bin/k9s  \
&& chmod +x /usr/bin/k9s \
&& rm -rf k9s_Linux_x86_64.tar.gz

# Add Azure CLI
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends ca-certificates curl apt-transport-https lsb-release gnupg -y  \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
&& AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list

# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends azure-cli -y  \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add helm
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm-${HELM_VERSION}-linux-amd64.tar.gz \
&& tar -xzf helm-${HELM_VERSION}-linux-amd64.tar.gz \
&& mv ./linux-amd64/helm /usr/bin/helm  \
&& chmod +x /usr/bin/helm \
&& rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64

# Add Vault
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
&&  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install -y --no-install-recommends vault=${VAULT_VERSION} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*\
 && setcap cap_ipc_lock= /usr/bin/vault

# Add argo-cli
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64 -o /usr/bin/argocd \
&& chmod +x /usr/bin/argocd

RUN adduser terraargo \
&& chown terraargo:terraargo /home/terraargo
WORKDIR /home/terraargo
ENV PATH=$PATH:/home/terraargo/.local/bin
ENV KUBECONFIG=/home/terraargo/.kube/config

COPY requirements.txt .

RUN python3 -m pip install --no-cache-dir --upgrade pip==22.0.4 setuptools==62.0.0 \
&& python3 -m pip install --no-cache-dir -r requirements.txt \
&& rm requirements.txt
