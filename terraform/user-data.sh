#!/bin/bash
set -e
DOCKER_IMAGE="${docker_image}"
APP_PORT="${app_port}"
dnf update -y
dnf install -y docker
systemctl start docker
systemctl enable docker
docker pull "$DOCKER_IMAGE"
docker run -d --name algobench --restart unless-stopped -p "$APP_PORT:$APP_PORT" "$DOCKER_IMAGE"