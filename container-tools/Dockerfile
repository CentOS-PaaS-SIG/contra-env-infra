FROM fedora:30

LABEL name="container-tools" \
      maintainer="rnester@redhat.com, ari@redhat.com" \
      version="v1.2.1" \
      description="Container to help build containers" \
      k8s.io.display-name="container-tools" \
      k8s.io.description="Container to help build containers" \
      openshift.io.tags="cpaas, container-tools"

ENV BUILDAH_ISOLATION=chroot
ENV STORAGE_DRIVER=vfs
ENV APP_ROOT=/container-tools/
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/

RUN dnf install -y ansible buildah make podman dumb-init procps jq git && \
    dnf clean all && \
    mkdir -p ${APP_ROOT} && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

# Setup subuid and subgid
RUN echo 10001:10002:2048 | tee /etc/subuid | tee /etc/subgid

# Create storage config for building the containers
RUN mkdir -p ${APP_ROOT}/.config/containers
RUN touch ${APP_ROOT}/.config/containers/storage.conf
RUN chown -R 10001 ${APP_ROOT}

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

ENTRYPOINT ["/usr/bin/dumb-init", "--", "uid_entrypoint"]

CMD run