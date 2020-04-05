#!/usr/bin/env bash
echo "create network reverse-proxy"
docker network create -d bridge reverse-proxy

echo "== start traefik"
docker run -d \
    -p 80:80 \
    -p 8080:8080 \
    -v $(pwd)/configuration/traefik/traefik1.7.toml:/etc/traefik/traefik.toml \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -l traefik.frontend.rule=Host:monitor.docker.local \
    -l traefik.port=8080 \
    --name traefik \
    --network reverse-proxy \
    traefik:v1.7