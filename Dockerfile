FROM alpine

COPY sockd.conf /etc/
COPY sockd.sh sockd_down.sh /usr/local/bin/

RUN true \
    && echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --update-cache dante-server@community openvpn bash openresolv openrc \
    && rm -rf /var/cache/apk/* \
    && true

RUN chmod a+x /usr/local/bin/*.sh

ENTRYPOINT openvpn --config /etc/openvpn/ovpn.conf \
    --auth-retry interact \
    --script-security 2 \
    --up /usr/local/bin/sockd.sh \
    --down /usr/local/bin/sockd_down.sh
