#! /bin/bash
set -e

# Remove server.pid for rails so it can be started in the container
rm -f /app/tmp/pids/server.pid

# Run the container main process (rails server ...)
exec "$@"
