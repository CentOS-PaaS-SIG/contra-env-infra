#!groovy

@Library('contra-lib') _

def testContainer(Map optional = [:], String imageName) {
    def buildRoot = optional.buildRoot ?: imageName

    def versions = null
    if (env.CHANGE_BRANCH == 'master') {
        if (optional.version) {
            versions = ['latest', optional.version]
        } else {
            versions = ['latest']
        }
    }

    /*
    def credentials = [usernamePassword(credentialsId: 'continuous-infra-contrainfr-dockercreds',
                        usernameVariable: 'CONTAINER_USERNAME',
                        passwordVariable: 'CONTAINER_PASSWORD')]

    def containers = ['container-tools': ['tag': 'latest']]

    def podTemplate = [containersWithProps: containers,
                       docker_repo_url: '172.30.254.79:5000',
                       openshift_namespace: 'continuous-infra',
                       podName: 'container-builds',
                       jenkins_slave_image: 'jenkins-contra-slave']

*/

    def credentials = [usernamePassword(credentialsId: 'contra-sample-project-dockercreds',
            usernameVariable: 'CONTAINER_USERNAME',
            passwordVariable: 'CONTAINER_PASSWORD')]

    def containers = ['container-tools': ['tag': 'latest']]

    def podTemplate = [containersWithProps: containers,
                       docker_repo_url: '172.30.1.1:5000',
                       openshift_namespace: 'contra-sample-project',
                       podName: 'container-builds',
                       jenkins_slave_image: 'jenkins-contra-sample-project-slave']

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


pipeline {
    agent any
    stages {
        stage('jenkins-master') {
            when {
                changeset "jenkins/master/**"
            }
            steps {
                script {
                    testContainer(buildRoot: 'jenkins/master', 'jenkins-master')
                }
            }
        }
        stage('jenkins-slave') {
            when {
                changeset "jenkins/slave/**"
            }
            steps {
                script {
                    testContainer(buildRoot: 'jenkins/slave', 'jenkins-slave')
                }
            }
        }
        stage('linchpin') {
            when {
                changeset "linchpin/**"
            }
            steps {
                script {
                    testContainer('linchpin')
                }
            }

        }
        stage('ansible-executor') {
            when {
                changeset "ansible/**"
            }
            steps {
                script {
                    testContainer(buildRoot: 'ansible','ansible-executor')
                }
            }

        }
        stage('grafana') {
            when {
                changeset "grafana/**"
            }
            steps {
                script {
                    if (changeset("grafana/VERSION")) {
                        version = readFile file: "grafana/VERSION"
                    }
                    testContainer(version: version, 'grafana')
                }
            }

        }
        stage('influxdb') {
            when {
                changeset "influxdb/**"
            }
            steps {
                script {
                    testContainer('influxdb')
                }
            }
        }
        stage('container-tools') {
            when {
                changeset "container-tools/**"
            }
            steps {
                script {
                    testContainer('container-tools')
                }
            }
        }
    }
}
