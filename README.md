# jenkins-slave

Docker image used for Jenkins slave nodes.

Intended to be used as a replacement for gcr.io/cloud-solutions-images/jenkins-k8s-slave in [continuous-deployment-on-kubernetes](https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes).

Image hosted at [Dockerhub](https://hub.docker.com/r/lushdigital/jenkins-k8s-slave/).

Includes:

* google-cloud-sdk - Used to access Google Compute Engine, Google Cloud Storage, Google BigQuery, and other gcp products and services from the command-line.

* kubectl -  Command line interface for running commands against Kubernetes clusters.

* golang - Go

* glide - Package manager for Go.

* Helm - Package manager for Kubernetes.

* Landscaper - Takes a set of Helm Chart references with values (a desired state), and realizes this in a Kubernetes cluster.
