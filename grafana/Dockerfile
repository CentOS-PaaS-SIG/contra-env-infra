FROM centos:7

ENV USERNAME=grafana
ENV GRAFANA_RPM=${GRAFANA_INSTALL:-grafana-5.2.3-1.x86_64.rpm}

LABEL k8s.io.description="Grafana dashboard" \
      k8s.io.display-name="Grafana" \
      openshift.io.expose-services="3000:http" \
      openshift.io.tags="grafana,ci" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i


RUN yum -y install git unzip nss_wrapper && \
    curl -L -o /tmp/grafana.rpm https://s3-us-west-2.amazonaws.com/grafana-releases/release/${GRAFANA_RPM} && \
    yum -y localinstall /tmp/grafana.rpm && \
    yum -y clean all && \
    rm -rf /var/cache/yum && \
    rm /tmp/grafana.rpm

COPY ./s2i/bin /usr/libexec/s2i
COPY ./usr/bin/ /usr/bin/
COPY ./usr/share/grafana/ /usr/share/grafana

RUN /usr/bin/fix-permissions /var/log/grafana && \
    /usr/bin/fix-permissions /etc/grafana && \
    /usr/bin/fix-permissions /usr/share/grafana && \
    /usr/bin/fix-permissions /usr/sbin/grafana-server \
    chown -R 1001:0 /var/log/grafana && \
    chown -R 1001:0 /etc/grafana && \
    chown -R 1001:0 /usr/share/grafana && \
    chown -R 1001:0 /usr/sbin/grafana-server

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

USER 1001

CMD ["/usr/libexec/s2i/run"]

