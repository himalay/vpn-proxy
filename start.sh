#!/bin/sh

ovpn=$1
name=vpn-proxy
port=1080
user=himalay
pass=hsockspass
timezone=Asia/Kathmandu

if [[ ! $ovpn =~ ^.*\.ovpn$ ]]; then
    echo "ERROR: You must provide the location of *.ovpn file path"
    echo "Example: ./start.sh path/to/MyOpenvpn.ovpn"
    exit 1
fi

ovpn="$(readlink -f $1)"

if [[ ! -f $ovpn ]]; then
    echo "ERROR: File does not exists in the path: $ovpn"
    exit 1
fi

if [[ "$(docker images -q $name 2>/dev/null)" == "" || $2 == "--build" ]]; then
    docker build -t $name . \
        --build-arg user=$user \
        --build-arg pass=$pass \
        --build-arg timezone=$timezone
fi

exec docker run \
    --name=$name \
    --rm \
    --tty \
    --interactive \
    --device=/dev/net/tun \
    --cap-add=NET_ADMIN \
    --publish 127.0.0.1:$port:1080 \
    --volume "$ovpn:/etc/openvpn/ovpn.conf:ro" \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    $name
