FROM openshift/jenkins-2-centos7:v3.11

COPY --chown=1001:0 ./openshift /opt/openshift

RUN /usr/local/bin/install-plugins.sh /opt/openshift/contra-plugins.txt

