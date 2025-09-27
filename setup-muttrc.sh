#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="wallakindle"
OUT_FILE="$OUT_DIR/Muttrc"

mkdir -p "$OUT_DIR"

prompt() {
  local varname="$1"
  local prompt_text="$2"
  local hide="$3"   # "yes" to hide input
  local default="${4-}"
  if [ "$hide" = "yes" ]; then
    while true; do
      read -r -s -p "$prompt_text" val
      echo
      if [ -z "$val" ] && [ -n "$default" ]; then
        val="$default"
      fi
      if [ -n "$val" ]; then
        printf -v "$varname" '%s' "$val"
        break
      fi
      echo "Value required."
    done
  else
    while true; do
      if [ -n "$default" ]; then
        read -r -p "$prompt_text [$default]: " val
        val="${val:-$default}"
      else
        read -r -p "$prompt_text: " val
      fi
      if [ -n "$val" ]; then
        printf -v "$varname" '%s' "$val"
        break
      fi
      echo "Value required."
    done
  fi
}

# Prompt for values (reasonable defaults provided)
prompt FROM "From address" "no" "dev@bertamini.net"
prompt REALNAME "Real name" "no" "Matteo Bertamini"
prompt IMAP_USER "IMAP user" "no" "matteo.bertamini@icloud.com"
prompt IMAP_PASS "IMAP password (will be hidden)" "yes"
prompt SMTP_URL "SMTP URL (full URL, e.g. smtp://user@smtp.example:587/)" "no" "smtp://matteo.bertamini@icloud.com@smtp.mail.me.com:587/"
prompt SMTP_PASS "SMTP password (will be hidden)" "yes"
prompt SSL_STARTTLS "ssl_starttls (yes/no)" "no" "yes"
prompt SSL_FORCETLS "ssl_force_tls (yes/no)" "no" "yes"

cat > "$OUT_FILE" <<EOF
set from = "$FROM"
set realname = "$REALNAME"

# IMAP settings
set imap_user = "$IMAP_USER"
set imap_pass = "$IMAP_PASS"

# SMTP settings
set smtp_url = "$SMTP_URL"
set smtp_pass = "$SMTP_PASS"
set ssl_starttls = $SSL_STARTTLS
set ssl_force_tls = $SSL_FORCETLS
EOF

chmod 600 "$OUT_FILE"
echo "Wrote $OUT_FILE (permissions 600)."

