def testContainer(String imageName, String buildRoot=null) {
    buildRoot = buildRoot ?: imageName
    def credentials = []
    def containers = ['ansible-executor': ['tag': 'latest']]

    podTemplate = [containersWithProps: containers,
                   docker_repo_url: '172.30.1.1:5000',
                   openshift_namespace: 'contra-sample-project',
                   podName: 'generic',
                   jenkins_slave_image: 'jenkins-contra-sample-project-slave']


    deployOpenShiftTemplate(podTemplate) {
        ciPipeline(decorateBuild: decoratePRBuild()) {

            buildTestContainer(
                    image_name: imageName,
                    build_root: buildRoot,
                    docker_namespace: 'contrainfra',
                    credentials: credentials,
                    buildContainer: 'ansible-executor',
                    release: 'latest')


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
            steps {
                script {
                    testContainer('ansible')
                }
            }

        }
    }
}
