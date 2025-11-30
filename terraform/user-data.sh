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

# Wait for Docker to be ready
sleep 10

# Start the application container
docker pull ${docker_image}
docker stop algobench 2>/dev/null || true
docker rm algobench 2>/dev/null || true
docker run -d \
  --name algobench \
  --restart unless-stopped \
  -p ${app_port}:8080 \
  ${docker_image}

# Setup monitoring stack
echo "Setting up monitoring..."
mkdir -p /home/ec2-user/monitoring
cd /home/ec2-user/monitoring

cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana
    restart: unless-stopped

volumes:
  prometheus-data:
  grafana-data:
EOF

cat > prometheus.yml <<'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'algobench'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['172.17.0.1:8080']
EOF

# Start monitoring stack
docker compose up -d

echo "Monitoring setup complete!"