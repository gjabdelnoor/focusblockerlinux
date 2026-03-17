# focusblockerlinux

DNS productivity blocker for Linux using `/etc/hosts` + `systemd` timers.

Blocks Reddit, YouTube, Instagram, and Meta/Facebook domains from **07:00 to 17:00** every day.

## Features

- One-command toggle: `focusblock on|off|toggle|status`
- Automatic daily schedule via systemd timers
- Safe managed block markers in `/etc/hosts`
- Easy enable/disable for schedule itself

## Install

Copy scripts and unit files into system paths:

```bash
sudo mkdir -p /usr/local/lib/focusblock
sudo install -m 0755 focusblock-enable /usr/local/lib/focusblock/focusblock-enable
sudo install -m 0755 focusblock-disable /usr/local/lib/focusblock/focusblock-disable
sudo install -m 0755 focusblock-sync /usr/local/lib/focusblock/focusblock-sync
sudo install -m 0644 focusblock-common.sh /usr/local/lib/focusblock/focusblock-common.sh
sudo install -m 0755 focusblock /usr/local/bin/focusblock
sudo install -m 0644 focusblock-enable.service /etc/systemd/system/focusblock-enable.service
sudo install -m 0644 focusblock-disable.service /etc/systemd/system/focusblock-disable.service
sudo install -m 0644 focusblock-enable.timer /etc/systemd/system/focusblock-enable.timer
sudo install -m 0644 focusblock-disable.timer /etc/systemd/system/focusblock-disable.timer
sudo systemctl daemon-reload
sudo systemctl enable --now focusblock-enable.timer focusblock-disable.timer
sudo /usr/local/lib/focusblock/focusblock-sync
```

## Usage

```bash
focusblock on
focusblock off
focusblock toggle
focusblock status
focusblock auto-on
focusblock auto-off
focusblock sync-now
```

## Notes

- This is a local DNS-level block. VPN/DoH/custom DNS apps can bypass it.
- Managed host entries are wrapped between:
  - `# >>> focusblock managed block >>>`
  - `# <<< focusblock managed block <<<`
