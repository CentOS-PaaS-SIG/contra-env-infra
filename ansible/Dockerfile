FROM fedora:30

LABEL name="ansible-executor" \
      maintainer="rnester@redhat.com, ari@redhat.com" \
      version="v1.2.1" \
      description="A container to run test scripts, set resource configuration, etc." \
      k8s.io.display-name="ansible-executor" \
      k8s.io.description="Container to help build containers" \
      openshift.io.tags="cpaas, ansible-executor"


ENV APP_ROOT=/ansible/
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY bin/ ${APP_ROOT}/bin/

RUN dnf install -y ansible \
        fedpkg \
        libselinux-python \
        standard-test-roles \
        python2-boto \
        python3-boto \
        python3-boto3 \
        python3-crypto \
        python3-google-auth \
        python2-libcloud \
        python3-libcloud \
	python2-virtualenv \
	python3-virtualenv \
	    jq \
        dumb-init \
        rsync && \
    dnf clean all && \
    mkdir -p ${APP_ROOT} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
ENTRYPOINT [ "/usr/bin/dumb-init", "--", "uid_entrypoint" ]

CMD run
