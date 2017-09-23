/**
 * Symphony.com Jenkins pipeline job
 */

import groovy.json.JsonSlurperClassic

node {

  // Parse GitHub payload
  def payload = new JsonSlurperClassic().parseText(env.payload)
  def org = payload?.repository?.full_name.tokenize('/')[0]
  def branch = payload?.repository?.default_branch
  def repo = payload?.repository?.name
  def pr = payload?.number

  // Define environment vars
  env.AUTH_PATH = '/tmp/auth'
  env.COMPOSE_PROJECT_NAME = env.HOSTNAME

  try {
    stage("Credentials Setup") {
      sh """
      # Get credentials
      if [[ ! -d '/tmp/auth' ]]; then
        gsutil cp gs://sym-esa-kube/auth.tgz .
        tar -xzvf auth.tgz && mv ./auth /tmp
      fi

      # Link credentials
      ln -sf /tmp/auth/.ssh /root/.ssh
      ln -sf /tmp/auth/.aws /root/.aws

      # Login to AWS ECR registry
      \$(aws ecr get-login --no-include-email --region us-east-1 --profile symphony-aws-es-sandbox)
      """
    }

    stage("Salt Checkout") {
      dir ('/srv') {
        sh """
        git init
        git config core.sshCommand 'ssh -i /root/.ssh/devops-salt-deploy-key -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'
        git remote add origin git@github.com:SymphonyOSF/DevOps-Salt.git
        git fetch origin
        git checkout ${branch}
        """
      }
    }

    stage("Start Containers") {
      dir ('/srv/images') {
        sh """
        docker-compose pull saltmaster saltminion
        docker-compose up -d --no-color --scale saltminion=4 saltmaster saltminion
        """

        waitUntil {
          def w = sh script: "docker-compose logs saltmaster | grep 'startup completed'", returnStatus: true
          return (w == 0);
        }

        sleep 10
        sh """
        docker-compose exec -T saltmaster salt-key
        docker-compose down
        """
      }
    }
  }

  catch(err) {
    echo "Ooops! We found an error:"
    throw(err)
  }

  finally {
    stage("Tear Down") {
      dir('/srv/images') {
        sh "docker-compose down"
      }
    }
  }

}
