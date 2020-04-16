FROM alpine

ENV VPN_USER ""
ENV VPN_PASS ""
ENV PROXY_USER "john"
ENV PROXY_PASS "JaneDoe"
ENV TZ "Asia/Kathmandu"
ENV OTP_SECRET ""

COPY sockd.conf /etc/
COPY sockd.sh sockd_down.sh /usr/local/bin/

RUN true \
    && echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --update-cache dante-server@community openvpn bash openresolv openrc tzdata oath-toolkit-oathtool expect \
    && rm -rf /var/cache/apk/* \
    && true

RUN chmod a+x /usr/local/bin/*.sh

ENTRYPOINT echo -e "${VPN_USER}\n${VPN_PASS}" > /etc/openvpn/pass.txt \
    && id -u $PROXY_USER &>/dev/null || (adduser -S -H ${PROXY_USER} && echo "${PROXY_USER}:${PROXY_PASS}" | chpasswd) \
    && printf "\
    set timeout 60\n\
    spawn openvpn --config /etc/openvpn/ovpn.conf --auth-user-pass /etc/openvpn/pass.txt --auth-retry interact --script-security 2 --up /usr/local/bin/sockd.sh --down /usr/local/bin/sockd_down.sh\n\
    while {1} {\n\
    expect {\n\
    eof {break}\n\
    \"CHALLENGE: Enter OTP Code\" {send \"$(oathtool -b --totp $OTP_SECRET)\r\"}\n\
    \"^C\" {send \003}\n\
    }\n\
    }\n\
    wait\n\
    close $spawn_id\n\
    " | expect
