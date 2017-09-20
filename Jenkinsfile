import groovy.json.JsonSlurperClassic

node {
    stage("Get Symphony credentials") {
        sh """
        gsutil cp gs://sym-esa-kube/auth.tgz . && tar -xzvf auth.tgz
        mkdir /data && mv ./auth /data
        """
    }
    stage("Parse GitHub payload") {
        def payload = new JsonSlurperClassic().parseText(env.payload)
        def org = payload?.repository?.full_name.tokenize('/')[0]
        def branch = payload?.repository?.default_branch
        def repo = payload?.repository?.name
        def pr = payload?.number

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
          env
          #while true; do sleep 10; done
          #docker-compose up -d jenkins-slave && sleep 15
          #docker-compose exec jenkins-slave env
          '''
        }
    }
}
