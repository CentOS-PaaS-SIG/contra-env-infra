FROM openshift/jenkins-slave-base-centos7:v3.11
RUN yum install -y epel-release
# add ruby for ghi
RUN yum install -y ansible \
        jq \
        ruby