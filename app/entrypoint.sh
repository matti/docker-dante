#!/usr/bin/env bash
set -euo pipefail

exec /usr/local/sbin/sockd -f "$CFGFILE" -p "$PIDFILE" -N "$WORKERS"
