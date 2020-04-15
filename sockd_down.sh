#!/bin/bash
set -e
killall sockd
[ -f /etc/openvpn/down.sh ] && /etc/openvpn/down.sh "$@"
