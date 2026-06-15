#!/bin/bash
set -euo pipefail

ENV_FILE=".env"

generate_password() { openssl rand -base64 18 | tr -d '/+=' | head -c 24; }
generate_token() { openssl rand -hex 32; }

# Create .env with random passwords if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
  echo "Generating $ENV_FILE with random credentials..."
  cat > "$ENV_FILE" <<EOF
INFLUXDB_ADMIN_USER=admin
INFLUXDB_ADMIN_PASSWORD=$(generate_password)
INFLUXDB_ORG=home
INFLUXDB_BUCKET=speedtest
INFLUXDB_ADMIN_TOKEN=$(generate_token)
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=$(generate_password)
SPEEDTEST_INTERVAL=60m
EOF
  echo "Created $ENV_FILE — credentials:"
  grep -E "PASSWORD|TOKEN" "$ENV_FILE"
fi

case "${1:-up}" in
  up)
    docker compose up -d --build
    echo "Stack running. Grafana: http://localhost:3000"
    ;;
  down)
    docker compose down
    ;;
  reset)
    docker compose down -v
    rm -f "$ENV_FILE"
    echo "Volumes and credentials removed."
    ;;
  logs)
    docker compose logs "${@:2}"
    ;;
  *)
    echo "Usage: $0 {up|down|reset|logs [service]}"
    exit 1
    ;;
esac
