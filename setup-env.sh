#!/usr/bin/env bash
set -euo pipefail

OUTFILE=".env"
TMPFILE="$(mktemp)"

prompt() {
  local var="$1"
  local current="$2"
  local hidden="${3:-false}"
  if [ "$hidden" = "true" ]; then
    # read without echo
    printf "%s" "$var [$current]: "
    stty -echo
    read -r val || true
    stty echo
    printf "\n"
  else
    printf "%s" "$var [$current]: "
    read -r val || true
  fi
  if [ -z "${val:-}" ]; then
    val="$current"
  fi
  # Escape single quotes by closing, inserting '\'' and reopening
  val_escaped="${val//\'/\'\\\'\'}"
  printf "%s='%s'\n" "$var" "$val_escaped" >> "$TMPFILE"
}


# Load defaults from .env if present
if [ -f ".env" ]; then
	  # Export variables defined in .env (ignores blank lines and comments)
	    set -o allexport
	      # shellcheck disable=SC1090
	        . ./.env
		  set +o allexport
fi

# Fallback defaults (only used if variable still unset)
: "${EMAIL:=dev@bertamini.net}"
: "${DOMAINNAME:=}"
: "${HTTP_BASIC_USER:=}"
: "${HTTP_BASIC_PWD:=}"
: "${TRAEFIK_DIR:=/mnt/media/srvs/traefik}"
: "${WALLABAG_DIR:=/mnt/media/srvs/wallabag}"
: "${WALLAKINDLE_CLIENT_ID:=}"
: "${WALLAKINDLE_CLIENT_SECRET:=}"
: "${WALLAKINDLE_DIR:=/mnt/media/srvs/wallakindle}"
: "${WALLAKINDLE_SMTP_FROM:=}"
: "${WALLAKINDLE_SMTP_HOST:=}"
: "${WALLAKINDLE_SMTP_PORT:=587}"
: "${WALLAKINDLE_SMTP_USER:=}"
: "${WALLAKINDLE_SMTP_PASSWORD:=}"
: "${WALLAKINDLE_EMAIL_ADDRESS:=@kindle.com}"
: "${WALLAKINDLE_TAGS_FILTER:=kindle}"

echo "This will create/overwrite $OUTFILE. Press Enter to accept the shown default value."

# Prompt each variable. Mark sensitive ones as hidden.
prompt "EMAIL" "$EMAIL"
prompt "DOMAINNAME" "$DOMAINNAME"
prompt "HTTP_BASIC_USER" "$HTTP_BASIC_USER"
prompt "HTTP_BASIC_PWD" "$HTTP_BASIC_PWD" "true"
prompt "TRAEFIK_DIR" "$TRAEFIK_DIR"
prompt "WALLABAG_DIR" "$WALLABAG_DIR"
prompt "WALLAKINDLE_CLIENT_ID" "$WALLAKINDLE_CLIENT_ID"
prompt "WALLAKINDLE_CLIENT_SECRET" "$WALLAKINDLE_CLIENT_SECRET" "true"
prompt "WALLAKINDLE_DIR" "$WALLAKINDLE_DIR"
prompt "WALLAKINDLE_SMTP_FROM" "$WALLAKINDLE_SMTP_FROM"
prompt "WALLAKINDLE_SMTP_HOST" "$WALLAKINDLE_SMTP_HOST"
prompt "WALLAKINDLE_SMTP_PORT" "$WALLAKINDLE_SMTP_PORT"
prompt "WALLAKINDLE_SMTP_USER" "$WALLAKINDLE_SMTP_USER"
prompt "WALLAKINDLE_SMTP_PASSWORD" "$WALLAKINDLE_SMTP_PASSWORD" "true"
prompt "WALLAKINDLE_EMAIL_ADDRESS" "$WALLAKINDLE_EMAIL_ADDRESS"
prompt "WALLAKINDLE_TAGS_FILTER" "$WALLAKINDLE_TAGS_FILTER"

# Atomically move tmp to outfile
mv "$TMPFILE" "$OUTFILE"
chmod 600 "$OUTFILE"
echo "Wrote $OUTFILE (permissions set to 600)."

