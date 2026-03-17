#!/usr/bin/env bash
set -euo pipefail

HOSTS_FILE="/etc/hosts"
BLOCK_BEGIN="# >>> focusblock managed block >>>"
BLOCK_END="# <<< focusblock managed block <<<"

DOMAINS=(
  "reddit.com"
  "www.reddit.com"
  "old.reddit.com"
  "redd.it"
  "redditmedia.com"
  "redditstatic.com"
  "youtube.com"
  "www.youtube.com"
  "m.youtube.com"
  "youtu.be"
  "youtube-nocookie.com"
  "googlevideo.com"
  "ytimg.com"
  "instagram.com"
  "www.instagram.com"
  "cdninstagram.com"
  "meta.com"
  "facebook.com"
  "www.facebook.com"
  "m.facebook.com"
  "messenger.com"
  "fbcdn.net"
)

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "This command must run as root." >&2
    exit 1
  fi
}

flush_dns_cache() {
  if command -v resolvectl >/dev/null 2>&1; then
    resolvectl flush-caches >/dev/null 2>&1 || true
  fi
}

remove_focusblock_from_hosts() {
  local tmp
  tmp="$(mktemp)"

  awk -v begin="$BLOCK_BEGIN" -v end="$BLOCK_END" '
    $0 == begin { in_block=1; next }
    $0 == end { in_block=0; next }
    !in_block { print }
  ' "$HOSTS_FILE" > "$tmp"

  install -m 0644 "$tmp" "$HOSTS_FILE"
  rm -f "$tmp"
}

apply_focusblock_to_hosts() {
  local tmp
  tmp="$(mktemp)"

  remove_focusblock_from_hosts
  cp "$HOSTS_FILE" "$tmp"

  {
    printf "\n%s\n" "$BLOCK_BEGIN"
    for domain in "${DOMAINS[@]}"; do
      printf "127.0.0.1 %s\n" "$domain"
      printf "::1 %s\n" "$domain"
    done
    printf "%s\n" "$BLOCK_END"
  } >> "$tmp"

  install -m 0644 "$tmp" "$HOSTS_FILE"
  rm -f "$tmp"
}

is_focusblock_enabled() {
  grep -Fq "$BLOCK_BEGIN" "$HOSTS_FILE"
}
