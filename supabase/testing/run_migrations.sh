#!/bin/bash
# Local backend verification harness — replays every migration against a
# scratch database. (run.sh adds the RPC smoke suite on top.)
#
# Requirements: any local PostgreSQL 15+ (psql on PATH). If you don't have
# a server installed, portable binaries work without root:
#   curl -L -o /tmp/pg.tar.gz https://github.com/theseus-rs/postgresql-binaries/releases/download/17.6.0/postgresql-17.6.0-x86_64-unknown-linux-gnu.tar.gz
#   tar xzf /tmp/pg.tar.gz -C /tmp && mv /tmp/postgresql-17.6.0-* /tmp/pgsql
#   /tmp/pgsql/bin/initdb -D /tmp/pgdata -U postgres -A trust --no-locale -E UTF8
#   /tmp/pgsql/bin/pg_ctl -D /tmp/pgdata -l /tmp/pg.log -o "-p 55432 -k /tmp" start
#
# AppImage users (e.g. running the IDE as an AppImage): the AppImage mount
# shadows `postgres` on PATH — launch with a clean environment:
#   env -u APPIMAGE -u APPDIR -u OWD PATH=/tmp/pgsql/bin:$PATH ...
#
# Usage:  bash supabase/testing/run_migrations.sh

set -euo pipefail
cd "$(dirname "$0")/.."   # supabase/

SOCK="/tmp"
PORT="55432"
PSQL="psql -h $SOCK -p $PORT -U postgres"

if ! $PSQL -tAc "select 1" >/dev/null 2>&1; then
  echo "No server listening on $SOCK:$PORT — start one first (see header)."
  exit 1
fi

echo "== recreating scratch database =="
$PSQL -q -c "drop database if exists encueypay_test;" -c "create database encueypay_test;"

echo "== applying Supabase schema stubs (auth/storage) =="
$PSQL -q -d encueypay_test -v ON_ERROR_STOP=1 -f testing/supabase_stub.sql

echo "== applying migrations (one transaction per file, like db push) =="
ok=0
for f in migrations/*.sql; do
  if ! $PSQL -q -d encueypay_test -1 -v ON_ERROR_STOP=1 -f "$f" > /tmp/mig_err.log 2>&1; then
    echo ">>> FAILED: $(basename "$f")"
    head -8 /tmp/mig_err.log
    exit 1
  fi
  echo "OK  $(basename "$f")"
  ok=$((ok+1))
done
echo "== $ok migrations applied cleanly =="
