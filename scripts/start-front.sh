#!/usr/bin/env bash
# Start MES frontend dev server (macOS / Linux).
#   ./scripts/start-front.sh                 Web admin :80
#   ./scripts/start-front.sh -f mes          Web admin :80
#   ./scripts/start-front.sh -f mes -p 8002  Web admin on 8002
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MES_ROOT="$ROOT/startech-mes-basic"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/start-front.sh                 Start Web admin (port 80)
  ./scripts/start-front.sh -f mes          Start Web admin (port 80)
  ./scripts/start-front.sh -f mes -p 8002  Start Web admin on port 8002

Flags:
  -f <app>    App to start. Values: mes (aliases: front, frontend)
  -p <port>   Override listen port
  -h          Show this help

Apps:
  mes   startech-mes-basic/frontend   npm run dev     http://localhost:80
EOF
}

app_dir() {
  case "$1" in
    mes) echo "$MES_ROOT/frontend" ;;
    *)   return 1 ;;
  esac
}

default_port() {
  case "$1" in
    mes) echo 80 ;;
  esac
}

listen_port() {
  if [[ -n "${PORT_OVERRIDE:-}" ]]; then
    echo "$PORT_OVERRIDE"
  else
    default_port "$1"
  fi
}

package_manager() {
  local dir="$1"
  if [[ -f "$dir/pnpm-lock.yaml" ]] && command -v pnpm >/dev/null 2>&1; then
    echo pnpm
  else
    echo npm
  fi
}

start_one() {
  local name="$1"
  local port="$2"
  local dir pm
  dir="$(app_dir "$name")"
  pm="$(package_manager "$dir")"
  cd "$dir"
  port="$port" PORT="$port" "$pm" run dev -- --port "$port"
}

resolve_app() {
  case "$1" in
    mes|front|frontend) echo mes ;;
    *)                  return 1 ;;
  esac
}

add_app() {
  local name="$1"
  if [[ ${#apps[@]} -gt 0 ]]; then
    local existing
    for existing in "${apps[@]}"; do
      if [[ "$existing" == "$name" ]]; then
        return
      fi
    done
  fi
  apps+=("$name")
}

valid_port() {
  [[ "$1" =~ ^[0-9]+$ ]] && [[ "$1" -ge 1 ]] && [[ "$1" -le 65535 ]]
}

if [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

PORT_OVERRIDE=""
explicit=1
apps=()
while getopts ':hf:p:' opt; do
  case "$opt" in
    h)
      usage
      exit 0
      ;;
    f)
      name="$(resolve_app "$OPTARG" || true)"
      if [[ -z "$name" ]]; then
        echo "Unknown app: $OPTARG (use mes)" >&2
        usage >&2
        exit 1
      fi
      add_app "$name"
      ;;
    p)
      if ! valid_port "$OPTARG"; then
        echo "Invalid port: $OPTARG" >&2
        exit 1
      fi
      PORT_OVERRIDE="$OPTARG"
      ;;
    :)
      echo "Missing value for -$OPTARG" >&2
      usage >&2
      exit 1
      ;;
    \?)
      echo "Unknown flag: -$OPTARG" >&2
      usage >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))
if [[ $# -gt 0 ]]; then
  echo "Unexpected argument: $1" >&2
  usage >&2
  exit 1
fi

if [[ ${#apps[@]} -eq 0 ]]; then
  apps=(mes)
  explicit=0
fi

if [[ ! -d "$MES_ROOT" ]]; then
  echo "MES project not found: $MES_ROOT" >&2
  exit 1
fi

app_ready() {
  local name="$1"
  local dir pm
  dir="$(app_dir "$name")"
  if [[ ! -d "$dir" ]]; then
    echo "[$name] app directory not found: $dir" >&2
    return 1
  fi
  if [[ ! -d "$dir/node_modules" ]]; then
    pm="$(package_manager "$dir")"
    echo "[$name] missing node_modules. Install first:" >&2
    echo "  cd \"$dir\" && $pm install" >&2
    return 1
  fi
  return 0
}

ready=()
for name in "${apps[@]}"; do
  if app_ready "$name"; then
    ready+=("$name")
  elif [[ "$explicit" -eq 1 ]]; then
    exit 1
  else
    echo "[$name] skipped" >&2
  fi
done
if [[ ${#ready[@]} -eq 0 ]]; then
  echo "No frontend app is ready to start." >&2
  exit 1
fi

name="${ready[0]}"
port="$(listen_port "$name")"
echo "[$name] $(app_dir "$name")"
echo "[$name] http://localhost:$port"
start_one "$name" "$port"
