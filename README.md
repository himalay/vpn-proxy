# VPN Proxy

OpenVPN client tied to a SOCKS proxy server for easier-app based  or even domain-name based routing.

- Update `--build-arg` values (user/pass) in `start.sh` file

## Build and run

`./start.sh path/to/MyOpenvpn.ovpn`

> Enter username, password, and OTP if required.

Test the proxy by running: `curl --proxy socks5://himalay:hsockspass@127.0.0.1:1080 ipinfo.io`
