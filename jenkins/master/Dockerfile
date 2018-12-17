FROM openshift/jenkins-2-centos7:v3.11

USER 0

COPY ./openshift /opt/openshift

RUN /usr/local/bin/install-plugins.sh /opt/openshift/contra-plugins.txt && \
    chown -R 1001:0 /opt/openshift && \
    /usr/local/bin/fix-permissions /opt/openshift && \
    /usr/local/bin/fix-permissions /opt/openshift/configuration/init.groovy.d

USER 1001

