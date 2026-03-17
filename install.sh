#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo ./install.sh" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -d "/usr/local/lib/focusblock"
install -m 0755 "$SCRIPT_DIR/focusblock-enable" "/usr/local/lib/focusblock/focusblock-enable"
install -m 0755 "$SCRIPT_DIR/focusblock-disable" "/usr/local/lib/focusblock/focusblock-disable"
install -m 0755 "$SCRIPT_DIR/focusblock-sync" "/usr/local/lib/focusblock/focusblock-sync"
install -m 0644 "$SCRIPT_DIR/focusblock-common.sh" "/usr/local/lib/focusblock/focusblock-common.sh"
install -m 0755 "$SCRIPT_DIR/focusblock" "/usr/local/bin/focusblock"

install -m 0644 "$SCRIPT_DIR/focusblock-enable.service" "/etc/systemd/system/focusblock-enable.service"
install -m 0644 "$SCRIPT_DIR/focusblock-disable.service" "/etc/systemd/system/focusblock-disable.service"
install -m 0644 "$SCRIPT_DIR/focusblock-enable.timer" "/etc/systemd/system/focusblock-enable.timer"
install -m 0644 "$SCRIPT_DIR/focusblock-disable.timer" "/etc/systemd/system/focusblock-disable.timer"

install -d "/usr/share/applications"
install -m 0644 "$SCRIPT_DIR/focusblock-toggle.desktop" "/usr/share/applications/focusblock-toggle.desktop"

systemctl daemon-reload
systemctl enable --now focusblock-enable.timer focusblock-disable.timer
/usr/local/lib/focusblock/focusblock-sync

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
fi

echo "focusblock installed. Use: focusblock status"
