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
        def repo = payload?.repository?.name
        def pr = payload?.number

        withEnv([
          "REPO=${repo}",
          "ORG=${org}",
          "PR=${pr}"
        ]) {
          steps.sh "echo \$REPO",
          steps.sh "echo \$ORG",
          steps.sh "echo \$PR"
        }
    }
}
