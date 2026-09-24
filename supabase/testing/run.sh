#!/bin/bash
# Full backend verification: migrations + RPC smoke suite.
#   bash supabase/testing/run.sh
# See run_migrations.sh for server setup notes.
set -euo pipefail
DIR="$(dirname "$0")"
bash "$DIR/run_migrations.sh"
psql -h /tmp -p 55432 -U postgres -d encueypay_test -v ON_ERROR_STOP=1 \
  -f "$DIR/smoke_test.sql" 2>&1 | grep -E "ERROR|PASSED" 
