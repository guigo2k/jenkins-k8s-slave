# jenkins-k8s-slave

Docker image used for Jenkins slave nodes.

Intended to be used as a replacement for gcr.io/cloud-solutions-images/jenkins-k8s-slave in [continuous-deployment-on-kubernetes](https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes).

Image hosted at [Dockerhub](https://hub.docker.com/r/lushdigital/jenkins-k8s-slave/).

Includes:

* [google-cloud-sdk](https://cloud.google.com/sdk/)
* [kubectl](https://kubernetes.io/docs/user-guide/kubectl/)
* [golang](https://golang.org/)
* [glide](https://glide.sh/)
* [Helm](https://helm.sh/)
* [Landscaper](https://github.com/Eneco/landscaper)
* [docker-compose](https://docs.docker.com/compose/)
