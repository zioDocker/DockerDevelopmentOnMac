#!/usr/bin/env bash
echo "create network reverse-proxy"
docker network create -d bridge reverse-proxy

echo "== start traefik v2.2"
docker run -d \
    -p 80:80 \
    -p 8080:8080 \
    -p 3306:3306 \
    -v $(pwd)/configuration/traefik/traefik2.2.toml:/etc/traefik/traefik.toml \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -l traefik.frontend.rule=Host:monitor.docker.local \
    -l traefik.port=8080 \
    --name traefik \
    --network reverse-proxy \
    traefik:v2.2