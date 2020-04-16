# VPN Proxy

OpenVPN client tied to a SOCKS proxy server for easier app based  or even domain-name based routing.

## Variables

| Variable Name | Description                     | Default          | File     |
| ------------- | ------------------------------- | ---------------- | -------- |
| NAME          | Docker image and container name | vpn-proxy        | start.sh |
| PORT          | SOCKS server port               | 1080             | start.sh |
| VPN_USER      | OpenVPN username                | doe              | .env     |
| VPN_PASS      | OpenVPN password                | XXXXXXXX         | .env     |
| OTP_SECRET    | Google Authenticator secret key | XXXXXXXXXXXXXXXX | .env     |
| PROXY_USER    | Username for SOCKS server       | john             | .env     |
| PROXY_PASS    | Password for SOCKS server       | JaneDoe          | .env     |
| TZ            | Container timezone              | Asia/Kathmandu   | .env     |

## Build and run

`./start.sh path/to/MyOpenvpn.ovpn`

> Note: Pass `--build` as second argument to above command to rebuild the image.

Test the proxy by running: `curl --proxy socks5://john:JaneDoe@127.0.0.1:1080 wtfismyip.com/json`

> Note: Press `Ctrl` + `C` to stop.
