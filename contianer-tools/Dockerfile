FROM fedora:30

LABEL name="container-tools" \
      maintainer="rnester@redhat.com, ari@redhat.com" \
      version="v1.1.0" \
      description="Container to help build containers" \
      k8s.io.display-name="container-tools" \
      k8s.io.description="Container to help build containers" \
      openshift.io.tags="cpaas, container-tools"

ENV APP_ROOT=/container-tools/
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/

RUN dnf install -y buildah make podman dumb-init procps && \
    dnf clean all && \
    mkdir -p ${APP_ROOT} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

# change cgroup manager from systemd to cgroupfs
COPY libpod.conf /etc/containers/libpod.conf

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

ENTRYPOINT ["/usr/bin/dumb-init", "--", "uid_entrypoint"]

CMD run