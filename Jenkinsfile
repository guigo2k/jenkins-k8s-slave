/**
 * Symphony.com Jenkins pipeline job
 */

import groovy.json.JsonSlurperClassic

node {

  def payload = new JsonSlurperClassic().parseText(env.payload)
  def org = payload?.repository?.full_name.tokenize('/')[0]
  def branch = payload?.repository?.default_branch
  def repo = payload?.repository?.name
  def pr = payload?.number

  env.AUTH_PATH=/opt/symphony/auth
  // env.COMPOSE_PROJECT_NAME=lorem
  // env.PODBUILDER_BRANCH=master
  // env.PODBUILDER_HOME=/data/boto
  // env.SALT_BRANCH=${branch}
  // env.SALT_HOME=/srv

  stage("Credentials") {
    sh """
    # Get Symphony credentials
    if [[ ! -d '/tmp/auth' ]]; then
      gsutil cp gs://sym-esa-kube/auth.tgz .
      tar -xzvf auth.tgz && mv ./auth /tmp
    fi

    # Create credentials links
    ln -sf /opt/auth/.ssh /root/.ssh
    ln -sf /opt/auth/.aws /root/.aws

    # Login to AWS ECR registry
    \$(aws ecr get-login --no-include-email --region us-east-1 --profile symphony-aws-es-sandbox)
    """
  }

  stage("Checkout") {
    sh """
    cd /srv
    git init
    git config core.sshCommand 'ssh -i /root/.ssh/devops-salt-deploy-key -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'
    git remote add origin git@github.com:SymphonyOSF/DevOps-Salt.git
    git fetch origin
    git checkout ${branch}
    """
  }

  stage("Containers") {
    sh """
    cd /srv/images
    docker-compose up -d --scale saltminion=4 saltmaster saltminion && sleep 30
    docker-compose exec saltmaster salt '*' grains.items
    """
  }
}
