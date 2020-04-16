#!/bin/sh

CONF_FILE="$(readlink -f $1)"
NAME=vpn-proxy
PORT=1080
ENV_FILE="$(readlink -f .env)"

if [[ ! -f $ENV_FILE ]]; then
    echo "ERROR: .env file does not exists in the path: $ENV_FILE"
    exit 1
fi

if [[ ! $CONF_FILE =~ ^.*\.ovpn$ ]]; then
    echo "ERROR: You must provide the location of *.ovpn file"
    echo "Example: ./start.sh /path/to/confFile.ovpn"
    exit 1
fi

if [[ ! -f $CONF_FILE ]]; then
    echo "ERROR: File does not exists in the path: $CONF_FILE"
    exit 1
fi

if [[ "$(docker images -q $NAME 2>/dev/null)" == "" || $2 == "--build" ]]; then
    docker build -t $NAME .
fi

exec docker run \
    --name=$NAME \
    --rm \
    --tty \
    --interactive \
    --device=/dev/net/tun \
    --cap-add=NET_ADMIN \
    --publish 127.0.0.1:$PORT:1080 \
    --volume "$CONF_FILE:/etc/openvpn/ovpn.conf:ro" \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --env-file=$ENV_FILE \
    $NAME
