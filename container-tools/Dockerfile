FROM fedora:29

RUN dnf install -y buildah make podman

# change cgroup manager from systemd to cgroupfs
COPY libpod.conf /etc/containers/libpod.conf

