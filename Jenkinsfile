#!groovy

@Library('contra-lib') _

def testContainer(Map optional = [:], String imageName) {
    def buildRoot = optional.buildRoot ?: imageName

    def versions = null
    if (env.BRANCH_NAME == 'master') {
        if (gitChangeLog("${buildRoot}/VERSION")) {
            def version = readFile file: "${buildRoot}/VERSION"
            versions = ['latest', version]
        } else {
            versions = ['latest']
        }
    }

    def credentials = [usernamePassword(credentialsId: 'continuous-infra-contrainfr-dockercreds',
                        usernameVariable: 'CONTAINER_USERNAME',
                        passwordVariable: 'CONTAINER_PASSWORD')]

    def containers = ['container-tools': ['tag': 'latest']]

    def podTemplate = [containersWithProps: containers,
                       docker_repo_url: '172.30.254.79:5000',
                       openshift_namespace: 'continuous-infra',
                       podName: 'container-builds',
                       jenkins_slave_image: 'jenkins-contra-slave']

    deployOpenShiftTemplate(podTemplate) {
        ciPipeline(decorateBuild: decoratePRBuild()) {

            buildTestContainer(
                    image_name: imageName,
                    build_root: buildRoot,
                    container_namespace: 'contrainfra',
                    credentials: credentials,
                    buildContainer: 'container-tools',
                    versions: versions)

        }
    }

}

def gitChangeLog(String searchItem) {
    def targetBranch = env.CHANGE_TARGET ?: 'master'
    sh(returnStatus: true, script: "git diff  origin/${targetBranch} --name-only | egrep -i \"${searchItem}\" > /dev/null") == 0
}

pipeline {
    agent any
    stages {
        stage('jenkins-master') {
            searchTerm = "jenkins/master/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer(buildRoot: 'jenkins/master', 'jenkins-master')
                }
            }
        }
        stage('jenkins-slave') {
            searchTerm = "jenkins/slave/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer(buildRoot: 'jenkins/slave', 'jenkins-slave')
                }
            }
        }
        stage('linchpin') {
            searchTerm = "linchpin/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer('linchpin')
                }
            }

        }
        stage('ansible-executor') {
            searchTerm = "ansible/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer(buildRoot: 'ansible','ansible-executor')
                }
            }

        }
        stage('grafana') {
            searchTerm = "grafana/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer('grafana')
                }
            }

        }
        stage('influxdb') {
            searchTerm = "influxdb/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer('influxdb')
                }
            }
        }
        stage('container-tools') {
            searchTerm = "container-tools/**"
            when {
                anyOf {
                    expression {
                        gitChangeLog(searchTerm)
                    }
                    changeset searchTerm
                }
            }
            steps {
                script {
                    testContainer('container-tools')
                }
            }
        }
    }
}
