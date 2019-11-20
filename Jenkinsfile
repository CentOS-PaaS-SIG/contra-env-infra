#!groovy

@Library('contra-lib') _

def getVersions(String versionFile) {
    def versions = null
    if (changeset(versionFile)) {
        def version = readFile file: versionFile
        versions = ['latest', version.trim()]
    } else {
        versions = ['latest']
    }  

    return versions
}

def testContainer(Map optional = [:], String imageName) {
    def buildRoot = optional.buildRoot ?: imageName

    def versions = null
    if (env.BRANCH_NAME == 'master') {
        // buildah push to docker hub is breaking things. Disabling until a fix is in place
        //versions = getVersions("${buildRoot}/VERSION")
    }

    def credentials = [usernamePassword(credentialsId: 'continuous-infra-contrainfra-dockercreds',
                        usernameVariable: 'CONTAINER_USERNAME',
                        passwordVariable: 'CONTAINER_PASSWORD')]

    def containers = ['container-tools': ['tag': 'latest']]

    def podTemplate = [containersWithProps: containers,
                       privileged: false,
                       docker_repo_url: '172.30.254.79:5000',
                       openshift_namespace: 'continuous-infra',
                       podName: 'container-builds',
                       jenkins_slave_image: 'jenkins-contra-slave']

    deployOpenShiftTemplate(podTemplate) {
        ciPipeline(decorateBuild: decoratePRBuild(), sendMetrics: false) {

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
        stage('checkout master branch') {
            // used for running on local non-master branches
            when {
                allOf {
                    expression {
                        // it's not a PR
                        env.CHANGE_TARGET == null
                    }
                    expression {
                        // the branch isn't master
                        env.BRANCH_NAME != 'master'
                    }
                }
            }
            steps {
                script {
                    sh "git fetch --no-tags --progress ${env.GIT_URL} +refs/heads/master:refs/remotes/origin/master"
                }
            }
        }
        stage('test images') {
            parallel {
                stage('jenkins-master') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("jenkins/master/**")
                            }
                            changeset "jenkins/master/**"
                        }
                    }
                    steps {
                        script {
                            testContainer(buildRoot: 'jenkins/master', 'jenkins-master')
                        }
                    }
                }
                stage('jenkins-slave') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("jenkins/slave/**")
                            }
                            changeset "jenkins/slave/**"
                        }
                    }
                    steps {
                        script {
                            testContainer(buildRoot: 'jenkins/slave', 'jenkins-slave')
                        }
                    }
                }
  
                stage('linchpin') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("linchpin/**")
                            }
                            changeset "linchpin/**"
                        }
                    }
                    steps {
                        script {
                            testContainer('linchpin')
                        }
                    }

                }
                stage('ansible-executor') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("ansible/**")
                            }
                            changeset "ansible/**"
                        }
                    }
                    steps {
                        script {
                            testContainer(buildRoot: 'ansible','ansible-executor')
                        }
                    }

                }
                stage('grafana') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("grafana/**")
                            }
                            changeset "grafana/**"
                        }
                    }
                    steps {
                        script {
                            testContainer('grafana')
                        }
                    }

                }
                stage('influxdb') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("influxdb/**")
                            }
                            changeset "influxdb/**"
                        }
                    }
                    steps {
                        script {
                            testContainer('influxdb')
                        }
                    }
                }
                stage('container-tools') {
                    when {
                        anyOf {
                            expression {
                                gitChangeLog("container-tools/**")
                            }
                            changeset "container-tools/**"
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
    }
}
