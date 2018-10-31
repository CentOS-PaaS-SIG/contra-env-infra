FROM centos:7

ENV HOME=/var/lib/influxdb
ENV INFLUX_BINARY=${INFLUXDB_BINARY:-influxdb-1.6.2.x86_64.rpm}

LABEL k8s.io.description="Influxdb time series db" \
      k8s.io.display-name="Influxdb" \
      openshift.io.expose-services="8086:http" \
      openshift.io.tags="influxdb,ci" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

RUN curl https://dl.influxdata.com/influxdb/releases/${INFLUX_BINARY} > /${INFLUX_BINARY} && \
    yum -y localinstall /${INFLUX_BINARY} && \
    yum -y clean all && \
    rm -rf /var/cache/yum && \
    rm -f /${INFLUX_BINARY} && \
    chmod 664 /etc/passwd


COPY ./s2i/bin /usr/libexec/s2i 
COPY influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8086

VOLUME /var/lib/influxdb

COPY entrypoint.sh init-influxdb.sh /

USER 1001

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/libexec/s2i/run"]
