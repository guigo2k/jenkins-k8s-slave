FROM jenkinsci/jnlp-slave
MAINTAINER Simon Ince <simon.ince@lush.co.uk>

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH
ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

USER root

# Install google-cloud-sdk and Go
RUN apt-get update -y
RUN apt-get install -y jq golang git make
RUN curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt
RUN gcloud components install kubectl

# Install Helm
RUN wget http://storage.googleapis.com/kubernetes-helm/helm-v2.1.3-linux-amd64.tar.gz -P /tmp
RUN tar -zxvf /tmp/helm-v2.1.3-linux-amd64.tar.gz -C /tmp && mv /tmp/linux-amd64/helm /bin/helm && rm -rf /tmp

# Install Glide
RUN mkdir -p $GOBIN
RUN mkdir /tmp
RUN curl https://glide.sh/get | sh

# Install Landscape
WORKDIR $GOPATH
RUN  mkdir -p src/github.com/eneco/
WORKDIR $GOPATH/src/github.com/eneco/
RUN git clone https://github.com/Eneco/landscaper.git
WORKDIR $GOPATH/src/github.com/eneco/landscaper
RUN make bootstrap build
