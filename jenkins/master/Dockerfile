FROM openshift/jenkins-2-centos7:v3.11

COPY --chown=1001:0 ./openshift /opt/openshift

RUN /usr/local/bin/install-plugins.sh /opt/openshift/plugins.txt && \
    mv /opt/openshift/plugins.txt /opt/openshift/contra-plugins.txt

USER 0

COPY opt/ /opt

RUN yum install epel-release -y && \
    yum install jq -y

USER 1001

