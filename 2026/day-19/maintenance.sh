#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/maintenance.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "===== Maintenance Started ====="

log "Running log rotation..."
bash /home/ubuntu/scripts/log_rotate.sh /var/log/myapp >> "$LOG_FILE" 2>&1
log "Log rotation done."

log "Running backup..."
bash /home/ubuntu/scripts/backup.sh /var/www/myapp /backups >> "$LOG_FILE" 2>&1
log "Backup done."

log "===== Maintenance Finished ====="