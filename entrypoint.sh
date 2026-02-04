#!/bin/bash
set -e

echo "Container ready. PalServer is managed by supervisor."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf