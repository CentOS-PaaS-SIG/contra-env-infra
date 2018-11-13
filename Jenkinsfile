#!groovy

@Library('contra-lib') _

def testContainer(String imageName, String buildRoot=null) {
    buildRoot = buildRoot ?: imageName
    def credentials = [usernamePassword(credentialsId: 'continuous-infra-contrainfra-dockercreds',
                        usernameVariable: 'CONTAINER_USERNAME',
                        passwordVariable: 'CONTAINER_PASSWORD')]
    def containers = ['container-tools': ['tag': 'latest']]

    podTemplate = [containersWithProps: containers,
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
                    versions: ['latest'])

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
                    testContainer('jenkins-master', 'jenkins/master')
                }
            }
        }
        stage('jenkins-slave') {
            when {
                changeset "jenkins/slave/**"
            }
            steps {
                script {
                    testContainer('jenkins-slave', 'jenkins/slave')
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
                    testContainer('ansible-executor', 'ansible')
                }
            }

        }
        stage('grafana') {
            when {
                changeset "grafana/**"
            }
            steps {
                script {
                    testContainer('grafana')
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
