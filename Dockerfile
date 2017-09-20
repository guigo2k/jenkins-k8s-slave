FROM jenkinsci/jnlp-slave
MAINTAINER Guigo2k <guigo2k@guigo2k.com>

ENV COMPOSE_VERSION 1.16.0
ENV HELM_VERSION v2.1.3

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:${PATH}
ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH ${PATH}:${GOROOT}/bin:${GOPATH}/bin

USER root

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version

# Install aws-cli and Python
ENV PYTHONIOENCODING=UTF-8
RUN apt-get update && \
    apt-get install -y \
    less \
    man \
    ssh \
    vim \
    python \
    python-pip && \
    pip install awscli

# Install google-cloud-sdk and Go
RUN apt-get update -y && \
    apt-get install -y jq golang git make && \
    curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt && \
    gcloud components install kubectl

# Install Helm
RUN wget http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -P /tmp && \
    tar -zxvf /tmp/helm-${HELM_VERSION}-linux-amd64.tar.gz -C /tmp && mv /tmp/linux-amd64/helm /bin/helm && rm -rf /tmp

# Install Glide
RUN mkdir -p ${GOBIN} && \
    mkdir /tmp && \
    curl https://glide.sh/get | sh

# Install Landscape
WORKDIR ${GOPATH}
RUN  mkdir -p src/github.com/eneco/
WORKDIR ${GOPATH}/src/github.com/eneco/
RUN git clone https://github.com/Eneco/landscaper.git
WORKDIR ${GOPATH}/src/github.com/eneco/landscaper
RUN make bootstrap build
