# Dockerizing OpenVpn
FROM quay.io/inok/baseimage

RUN apt-get update && \
    apt-get install -y openvpn && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /dev/net && \
         mknod /dev/net/tun c 10 200

# Define mountable directories.
VOLUME ["/etc/openvpn"]
# Define working directory.
WORKDIR /etc/openvpn

CMD ["openvpn","--config", "openvpn.conf"]
