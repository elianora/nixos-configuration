#!/bin/sh
set -eu
sudo -i -u podman \
    podman run -it \
    --name=caddy-reverse-proxy \
    --user=1002:100 \
    --userns=keep-id \
    --replace \
    -p 80:80 \
    -p 443:443 \
    -p 443:443/udp \
    -p 2019:2019 \
    -v /srv/configuration/caddy/config:/config:Z \
    -v /srv/configuration/caddy/data:/data:Z \
    -v /srv/configuration/caddy/etc:/etc/caddy:Z \
    -v /srv/configuration/caddy/logs:/logs:Z \
    -v /srv/www:/srv:z \
    localhost/homemanager/caddy:latest \
    /usr/bin/caddy validate --config /etc/caddy/Caddyfile
