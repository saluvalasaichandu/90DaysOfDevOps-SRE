#!/bin/bash
set -euo pipefail

LOG_DIR="$1" 


if [[ ! -d "$LOG_DIR" ]]; then
    echo "ERROR: Folder '$LOG_DIR' not found."
    exit 1
fi

echo "Starting log rotation for: $LOG_DIR"


find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \;
echo "Old .log files compressed."


find "$LOG_DIR" -name "*.gz" -mtime +30 -delete
echo "Very old .gz files deleted."

echo "Log rotation done!"