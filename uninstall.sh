#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo ./uninstall.sh" >&2
  exit 1
fi

if [[ -x "/usr/local/lib/focusblock/focusblock-disable" ]]; then
  /usr/local/lib/focusblock/focusblock-disable || true
fi

systemctl disable --now focusblock-enable.timer focusblock-disable.timer >/dev/null 2>&1 || true

rm -f "/etc/systemd/system/focusblock-enable.timer"
rm -f "/etc/systemd/system/focusblock-disable.timer"
rm -f "/etc/systemd/system/focusblock-enable.service"
rm -f "/etc/systemd/system/focusblock-disable.service"

rm -f "/usr/local/lib/focusblock/focusblock-enable"
rm -f "/usr/local/lib/focusblock/focusblock-disable"
rm -f "/usr/local/lib/focusblock/focusblock-sync"
rm -f "/usr/local/lib/focusblock/focusblock-common.sh"
rm -f "/usr/local/bin/focusblock"
rm -f "/usr/share/applications/focusblock-toggle.desktop"

rmdir "/usr/local/lib/focusblock" >/dev/null 2>&1 || true

systemctl daemon-reload

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
fi

echo "focusblock uninstalled."
