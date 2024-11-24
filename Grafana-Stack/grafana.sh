#!/bin/bash

set -e  # Detener el script si ocurre un error
set -u  # Salir si se intenta usar una variable no definida

# Variables
GRAFANA_GPG_KEY_URL="https://packages.grafana.com/gpg.key"
GRAFANA_REPO_FILE="/etc/apt/sources.list.d/grafana.list"
GRAFANA_KEYRING="/usr/share/keyrings/grafana-archive-keyring.gpg"
LOKI_REPO_API="https://api.github.com/repos/grafana/loki/releases/latest"
INSTALL_DIR="/usr/local/bin"
PROMTAIL_CONFIG="promtail.yaml"
LOKI_CONFIG="loki.yaml"

# Función para instalar dependencias necesarias
install_dependencies() {
  echo "Instalando dependencias necesarias..."
  sudo apt update
  sudo apt install -y curl wget unzip gpg
}

# Agregar el repositorio de Grafana y la clave GPG
add_grafana_repo() {
  echo "Agregando el repositorio de Grafana y la clave GPG..."
  curl -fsSL "$GRAFANA_GPG_KEY_URL" | sudo gpg --dearmor -o "$GRAFANA_KEYRING"
  echo "deb [signed-by=$GRAFANA_KEYRING] https://packages.grafana.com/oss/deb stable main" | sudo tee "$GRAFANA_REPO_FILE"
}

# Instalar Grafana
install_grafana() {
  echo "Instalando Grafana..."
  sudo apt update
  sudo apt install -y grafana
}

# Descargar e instalar Loki
install_loki() {
  echo "Descargando e instalando Loki..."
  LOKI_URL=$(curl -s "$LOKI_REPO_API" | grep browser_download_url | cut -d '"' -f 4 | grep loki-linux-amd64.zip)
  wget "$LOKI_URL" -O loki-linux-amd64.zip
  unzip loki-linux-amd64.zip
  sudo mv loki-linux-amd64 "$INSTALL_DIR/loki"
  rm loki-linux-amd64.zip
  echo "Loki instalado: $(loki --version)"
}

# Descargar e instalar Promtail
install_promtail() {
  echo "Descargando e instalando Promtail..."
  PROMTAIL_URL=$(curl -s "$LOKI_REPO_API" | grep browser_download_url | cut -d '"' -f 4 | grep promtail-linux-amd64.zip)
  wget "$PROMTAIL_URL" -O promtail-linux-amd64.zip
  unzip promtail-linux-amd64.zip
  sudo mv promtail-linux-amd64 "$INSTALL_DIR/promtail"
  rm promtail-linux-amd64.zip
  echo "Promtail instalado: $(promtail --version)"
}

# Crear el archivo promtail.yaml
create_promtail_config() {
  echo "Creando archivo $PROMTAIL_CONFIG..."
  cat <<EOL > $PROMTAIL_CONFIG
server:
  http_listen_port: 9081
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3101/loki/api/v1/push

scrape_configs:
  - job_name: suricata_eve.json
    static_configs:
      - targets:
          - localhost
        labels:
          job: suricata_eve
          __path__: /var/log/suricata/eve.json
  - job_name: suricata_fast.log
    static_configs:
      - targets:
          - localhost
        labels:
          job: suricata_fast
          __path__: /var/log/suricata/fast.log
EOL
  echo "Archivo $PROMTAIL_CONFIG creado correctamente."
}

# Crear el archivo loki.yaml
create_loki_config() {
  echo "Creando archivo $LOKI_CONFIG..."
  cat <<EOL > $LOKI_CONFIG
auth_enabled: false

server:
  http_listen_port: 3101
  grpc_listen_port: 9097

common:
  instance_addr: 127.0.0.1
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
      rules_directory: /tmp/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

schema_config:
  configs:
    - from: 2020-10-24
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h
EOL
  echo "Archivo $LOKI_CONFIG creado correctamente."
}

# Iniciar Loki
start_loki() {
  echo "Iniciando Loki..."
  loki -config.file=./loki.yaml &
  echo "Loki iniciado."
}

# Iniciar Promtail
start_promtail() {
  echo "Iniciando Promtail..."
  promtail -config.file=./promtail.yaml &
  echo "Promtail iniciado."
}

# Iniciar Grafana
start_grafana() {
  echo "Iniciando Grafana..."
  grafana-server --homepath=/usr/share/grafana --config=/etc/grafana/grafana.ini &
  echo "Grafana iniciado."
}

# Ejecutar todas las funciones
install_dependencies
add_grafana_repo
install_grafana
install_loki
install_promtail
create_promtail_config
create_loki_config
start_loki
start_promtail
start_grafana

echo "Configuración e inicio completados correctamente."