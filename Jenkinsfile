import groovy.json.JsonSlurperClassic

node {
    def payload = new JsonSlurperClassic().parseText(env.payload)
    def org = payload?.repository?.full_name.tokenize('/')[0]
    def branch = payload?.repository?.default_branch
    def repo = payload?.repository?.name
    def pr = payload?.number

    stage("Credentials") {
        sh """
        # Get Symphony credentials
        gcloud components update
        gsutil cp gs://sym-esa-kube/auth.tgz .
        tar -xzvf auth.tgz
        mkdir /data && mv ./auth /data

        # Create credentials links
        ln -sf /data/auth/.ssh /root/.ssh
        ln -sf /data/auth/.aws /root/.aws

        # Login to AWS ECR registry
        $(aws ecr get-login --no-include-email --region us-east-1 --profile symphony-aws-es-sandbox)
        """
    }
    stage("Salt checkout") {
        sh """
        cd /srv
        git init
        git config core.sshCommand 'ssh -i /root/.ssh/devops-salt-deploy-key -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'
        git remote add origin git@github.com:SymphonyOSF/DevOps-Salt.git
        git fetch origin
        git checkout ${branch}
        """
    }
    stage("Salt checkout") {
        withEnv([
          "SALT_HOME=/srv",
          "SALT_BRANCH=${branch}",
          "PODBUILDER_HOME=/data/boto",
          "PODBUILDER_BRANCH=master",
          "PUBLISH_PORT=4505",
          "MASTER_PORT=4506",
          "API_PORT=4507"
        ]) {
          sh '''
          cd /srv/images
          docker-compose up -d saltmaster saltminion && sleep 15
          docker-compose scale saltminion=4
          docker-compose exec saltmaster salt '*' grains.items saltenv=dev
          '''
        }
    }
}
