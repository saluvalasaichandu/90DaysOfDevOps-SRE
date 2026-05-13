# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

> **#90DaysOfDevOps | #DevOpsKaJosh | #TrainWithShubham**

---

## 📋 Table of Contents

- [Overview](#overview)
- [Task 1: Log Rotation Script](#task-1-log-rotation-script)
- [Task 2: Server Backup Script](#task-2-server-backup-script)
- [Task 3: Crontab Scheduling](#task-3-crontab-scheduling)
- [Task 4: Combined Maintenance Script](#task-4-combined-maintenance-script)
- [Key Learnings](#key-learnings)
- [File Structure](#file-structure)

---

## Overview

Day 19 is where scripting gets **real**. Everything learned across Days 16–18 — loops, functions, strict mode, local variables — comes together in three production-style mini projects:

- A **log rotation** script to keep disk usage in check
- A **server backup** script with timestamped archives and auto-cleanup
- A **crontab schedule** to run everything automatically
- A **combined maintenance** script that ties it all together

These are scripts you'd actually find (and write) on a real DevOps job.

---

## Task 1: Log Rotation Script

### 📄 Script: `log_rotate.sh`

```bash
#!/bin/bash
set -euo pipefail
# log_rotate.sh — Rotate logs: compress old .log files, delete aged .gz files
# Usage: ./log_rotate.sh <log_directory>

# ─── Validate Argument ───────────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    echo "❌ ERROR: No log directory provided."
    echo "   Usage: $0 <log_directory>"
    exit 1
fi

LOG_DIR="$1"

# ─── Validate Directory ──────────────────────────────────────────────────────
if [[ ! -d "$LOG_DIR" ]]; then
    echo "❌ ERROR: Directory '$LOG_DIR' does not exist."
    exit 1
fi

echo "════════════════════════════════════════"
echo "  🔄 Log Rotation Started"
echo "  Directory : $LOG_DIR"
echo "  Timestamp : $(date '+%Y-%m-%d %H:%M:%S')"
echo "════════════════════════════════════════"

# ─── Step 1: Compress .log files older than 7 days ──────────────────────────
echo ""
echo "📦 Compressing .log files older than 7 days..."

COMPRESSED=0
while IFS= read -r -d '' file; do
    gzip "$file" && echo "  Compressed: $file" && (( COMPRESSED++ )) || true
done < <(find "$LOG_DIR" -maxdepth 2 -name "*.log" -mtime +7 -print0)

echo "  ✅ Files compressed: $COMPRESSED"

# ─── Step 2: Delete .gz files older than 30 days ────────────────────────────
echo ""
echo "🗑️  Deleting .gz files older than 30 days..."

DELETED=0
while IFS= read -r -d '' file; do
    rm -f "$file" && echo "  Deleted: $file" && (( DELETED++ )) || true
done < <(find "$LOG_DIR" -maxdepth 2 -name "*.gz" -mtime +30 -print0)

echo "  ✅ Files deleted: $DELETED"

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "  📊 Log Rotation Summary"
echo "  Compressed : $COMPRESSED file(s)"
echo "  Deleted    : $DELETED file(s)"
echo "  Completed  : $(date '+%Y-%m-%d %H:%M:%S')"
echo "════════════════════════════════════════"
```

### ▶️ Sample Output

```
════════════════════════════════════════
  🔄 Log Rotation Started
  Directory : /var/log/myapp
  Timestamp : 2026-05-13 02:00:01
════════════════════════════════════════

📦 Compressing .log files older than 7 days...
  Compressed: /var/log/myapp/app-2026-05-01.log
  Compressed: /var/log/myapp/app-2026-05-03.log
  Compressed: /var/log/myapp/error-2026-05-02.log
  ✅ Files compressed: 3

🗑️  Deleting .gz files older than 30 days...
  Deleted: /var/log/myapp/app-2026-04-01.log.gz
  Deleted: /var/log/myapp/error-2026-03-28.log.gz
  ✅ Files deleted: 2

════════════════════════════════════════
  📊 Log Rotation Summary
  Compressed : 3 file(s)
  Deleted    : 2 file(s)
  Completed  : 2026-05-13 02:00:03
════════════════════════════════════════
```

### ▶️ Error Output (bad directory)

```
❌ ERROR: Directory '/var/log/nonexistent' does not exist.
```

### 💡 Key Concepts Used

| Concept | Detail |
|--------|--------|
| `find -mtime +7` | Finds files modified more than 7 days ago |
| `find -print0` + `read -d ''` | Safely handles filenames with spaces |
| `gzip` | Compresses in-place, appends `.gz` extension |
| `(( COUNTER++ ))` | Arithmetic increment inside subshell-safe context |
| `set -euo pipefail` | Strict mode — script exits on any unexpected failure |

---

## Task 2: Server Backup Script

### 📄 Script: `backup.sh`

```bash
#!/bin/bash
set -euo pipefail
# backup.sh — Create timestamped tar.gz backup and clean up old archives
# Usage: ./backup.sh <source_directory> <backup_destination>

# ─── Validate Arguments ──────────────────────────────────────────────────────
if [[ $# -lt 2 ]]; then
    echo "❌ ERROR: Missing arguments."
    echo "   Usage: $0 <source_directory> <backup_destination>"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DEST="$2"
TIMESTAMP=$(date +%Y-%m-%d)
BACKUP_NAME="backup-${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DEST}/${BACKUP_NAME}"

# ─── Validate Source ─────────────────────────────────────────────────────────
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "❌ ERROR: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# ─── Create Destination if Needed ────────────────────────────────────────────
mkdir -p "$BACKUP_DEST"

echo "════════════════════════════════════════"
echo "  💾 Server Backup Started"
echo "  Source      : $SOURCE_DIR"
echo "  Destination : $BACKUP_DEST"
echo "  Archive     : $BACKUP_NAME"
echo "  Timestamp   : $(date '+%Y-%m-%d %H:%M:%S')"
echo "════════════════════════════════════════"

# ─── Create Archive ──────────────────────────────────────────────────────────
echo ""
echo "📦 Creating archive..."

if tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
    echo "  ✅ Archive created successfully."
else
    echo "  ❌ ERROR: Failed to create archive."
    exit 1
fi

# ─── Verify Archive ──────────────────────────────────────────────────────────
if [[ ! -f "$BACKUP_PATH" ]]; then
    echo "  ❌ ERROR: Archive file not found after creation!"
    exit 1
fi

ARCHIVE_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
echo "  📁 Archive Name : $BACKUP_NAME"
echo "  📏 Archive Size : $ARCHIVE_SIZE"

# ─── Delete Backups Older Than 14 Days ───────────────────────────────────────
echo ""
echo "🗑️  Cleaning up backups older than 14 days..."

OLD_COUNT=0
while IFS= read -r -d '' old_file; do
    rm -f "$old_file" && echo "  Removed: $(basename "$old_file")" && (( OLD_COUNT++ )) || true
done < <(find "$BACKUP_DEST" -maxdepth 1 -name "backup-*.tar.gz" -mtime +14 -print0)

echo "  ✅ Old backups removed: $OLD_COUNT"

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "  📊 Backup Summary"
echo "  Archive     : $BACKUP_NAME"
echo "  Size        : $ARCHIVE_SIZE"
echo "  Old Removed : $OLD_COUNT file(s)"
echo "  Completed   : $(date '+%Y-%m-%d %H:%M:%S')"
echo "════════════════════════════════════════"
```

### ▶️ Sample Output

```
════════════════════════════════════════
  💾 Server Backup Started
  Source      : /var/www/myapp
  Destination : /backups
  Archive     : backup-2026-05-13.tar.gz
  Timestamp   : 2026-05-13 03:00:01
════════════════════════════════════════

📦 Creating archive...
  ✅ Archive created successfully.
  📁 Archive Name : backup-2026-05-13.tar.gz
  📏 Archive Size : 145M

🗑️  Cleaning up backups older than 14 days...
  Removed: backup-2026-04-25.tar.gz
  Removed: backup-2026-04-28.tar.gz
  ✅ Old backups removed: 2

════════════════════════════════════════
  📊 Backup Summary
  Archive     : backup-2026-05-13.tar.gz
  Size        : 145M
  Old Removed : 2 file(s)
  Completed   : 2026-05-13 03:00:09
════════════════════════════════════════
```

### ▶️ Error Output (source missing)

```
❌ ERROR: Source directory '/var/www/nonexistent' does not exist.
```

### 💡 Key Concepts Used

| Concept | Detail |
|--------|--------|
| `date +%Y-%m-%d` | Generates timestamp like `2026-05-13` |
| `tar -czf` | Create (`c`), gzip-compress (`z`), to file (`f`) |
| `du -sh` | Human-readable size of the archive |
| `find -mtime +14` | Finds backups older than 14 days for cleanup |
| `mkdir -p` | Creates destination dir without error if it exists |

---

## Task 3: Crontab Scheduling

### Understanding Cron Syntax

```
* * * * *  /path/to/command
│ │ │ │ │
│ │ │ │ └── Day of week  (0–7, 0 and 7 = Sunday)
│ │ │ └──── Month        (1–12)
│ │ └────── Day of month (1–31)
│ └──────── Hour         (0–23)
└────────── Minute       (0–59)
```

### Viewing Current Schedule

```bash
crontab -l
```

Sample output (empty system):
```
no crontab for ubuntu
```

### Editing Crontab

```bash
crontab -e
```

### ⏰ Cron Entries for Day 19 Scripts

```cron
# ─── Log Rotation — every day at 2:00 AM ───────────────────────────────────
0 2 * * * /home/ubuntu/scripts/log_rotate.sh /var/log/myapp >> /var/log/maintenance.log 2>&1

# ─── Server Backup — every Sunday at 3:00 AM ───────────────────────────────
0 3 * * 0 /home/ubuntu/scripts/backup.sh /var/www/myapp /backups >> /var/log/maintenance.log 2>&1

# ─── Health Check — every 5 minutes ────────────────────────────────────────
*/5 * * * * /home/ubuntu/scripts/health_check.sh >> /var/log/health.log 2>&1

# ─── Combined Maintenance — every day at 1:00 AM ───────────────────────────
0 1 * * * /home/ubuntu/scripts/maintenance.sh >> /var/log/maintenance.log 2>&1
```

### Cron Entry Reference Table

| Schedule | Cron Expression | Description |
|----------|----------------|-------------|
| Every day at 2 AM | `0 2 * * *` | Log rotation |
| Every Sunday at 3 AM | `0 3 * * 0` | Weekly backup |
| Every 5 minutes | `*/5 * * * *` | Health check |
| Every day at 1 AM | `0 1 * * *` | Maintenance script |
| Every hour | `0 * * * *` | `0` min, any hour |
| Every weekday at 9 AM | `0 9 * * 1-5` | Mon–Fri only |
| First of every month | `0 0 1 * *` | Monthly tasks |

### 📝 Useful Cron Commands

```bash
# View current crontab
crontab -l

# Edit crontab (opens in default editor)
crontab -e

# Remove all cron jobs (⚠️ careful!)
crontab -r

# Check cron daemon logs (Ubuntu/Debian)
grep CRON /var/log/syslog | tail -20

# Verify cron service is running
systemctl status cron
```

> **Tip:** Always use absolute paths in cron jobs. Cron runs with a minimal environment and won't find scripts using relative paths or `~/`.

---

## Task 4: Combined Maintenance Script

### 📄 Script: `maintenance.sh`

```bash
#!/bin/bash
set -euo pipefail
# maintenance.sh — Combined log rotation + backup with timestamped logging
# Usage: ./maintenance.sh
# Cron:  0 1 * * * /home/ubuntu/scripts/maintenance.sh >> /var/log/maintenance.log 2>&1

# ─── Configuration ───────────────────────────────────────────────────────────
LOG_DIR="/var/log/myapp"
SOURCE_DIR="/var/www/myapp"
BACKUP_DEST="/backups"
MAINTENANCE_LOG="/var/log/maintenance.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Logging Helper ──────────────────────────────────────────────────────────
log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${message}" | tee -a "$MAINTENANCE_LOG"
}

# ─── Section Header ──────────────────────────────────────────────────────────
log_header() {
    local title="$1"
    log "════════════════════════════════════════"
    log "  ${title}"
    log "════════════════════════════════════════"
}

# ─── Run Log Rotation ────────────────────────────────────────────────────────
run_log_rotation() {
    log_header "🔄 Starting Log Rotation"
    if bash "${SCRIPT_DIR}/log_rotate.sh" "$LOG_DIR" >> "$MAINTENANCE_LOG" 2>&1; then
        log "✅ Log rotation completed successfully."
    else
        log "❌ Log rotation FAILED with exit code $?"
    fi
}

# ─── Run Backup ──────────────────────────────────────────────────────────────
run_backup() {
    log_header "💾 Starting Server Backup"
    if bash "${SCRIPT_DIR}/backup.sh" "$SOURCE_DIR" "$BACKUP_DEST" >> "$MAINTENANCE_LOG" 2>&1; then
        log "✅ Backup completed successfully."
    else
        log "❌ Backup FAILED with exit code $?"
    fi
}

# ─── Main ────────────────────────────────────────────────────────────────────
main() {
    log_header "🚀 Maintenance Script Started"
    log "  Host    : $(hostname)"
    log "  User    : $(whoami)"
    log "  PID     : $$"

    run_log_rotation
    run_backup

    log_header "✅ Maintenance Script Completed"
}

main
```

### ▶️ Sample Output (in `/var/log/maintenance.log`)

```
[2026-05-13 01:00:00] ════════════════════════════════════════
[2026-05-13 01:00:00]   🚀 Maintenance Script Started
[2026-05-13 01:00:00] ════════════════════════════════════════
[2026-05-13 01:00:00]   Host    : devops-server-01
[2026-05-13 01:00:00]   User    : ubuntu
[2026-05-13 01:00:00]   PID     : 14821

[2026-05-13 01:00:00] ════════════════════════════════════════
[2026-05-13 01:00:00]   🔄 Starting Log Rotation
[2026-05-13 01:00:00] ════════════════════════════════════════
[2026-05-13 01:00:02]   Compressed: /var/log/myapp/app-2026-05-01.log
[2026-05-13 01:00:02]   Compressed: /var/log/myapp/error-2026-05-03.log
[2026-05-13 01:00:03]   Deleted: /var/log/myapp/app-2026-04-01.log.gz
[2026-05-13 01:00:03] ✅ Log rotation completed successfully.

[2026-05-13 01:00:03] ════════════════════════════════════════
[2026-05-13 01:00:03]   💾 Starting Server Backup
[2026-05-13 01:00:03] ════════════════════════════════════════
[2026-05-13 01:00:09]   ✅ Archive created: backup-2026-05-13.tar.gz (145M)
[2026-05-13 01:00:09]   Removed: backup-2026-04-25.tar.gz
[2026-05-13 01:00:10] ✅ Backup completed successfully.

[2026-05-13 01:00:10] ════════════════════════════════════════
[2026-05-13 01:00:10]   ✅ Maintenance Script Completed
[2026-05-13 01:00:10] ════════════════════════════════════════
```

### ⏰ Cron Entry for Maintenance Script

```cron
# Run maintenance daily at 1:00 AM
0 1 * * * /home/ubuntu/scripts/maintenance.sh >> /var/log/maintenance.log 2>&1
```

---

## 📖 Key Learnings

### 1. 🔄 Log rotation and backups are core SRE/DevOps responsibilities
Disk space doesn't manage itself. In production, unrotated logs have taken down servers. The pattern is always the same: **compress the old, delete the ancient, keep the recent.** Automating this with a well-tested script + cron is table stakes for any server you manage.

### 2. ⏰ Cron is powerful — but only with absolute paths and proper logging
Cron jobs run in a minimal shell environment. Two rules that save hours of debugging:

- **Always use absolute paths** — `$HOME` and `~/` are often undefined in cron's environment
- **Always redirect output** — `>> /var/log/myjob.log 2>&1` captures both stdout and stderr; without it, failures are invisible

```cron
# ❌ Wrong — relative paths, no logging
* * * * * ./my_script.sh

# ✅ Correct — absolute paths, logged output
0 2 * * * /home/ubuntu/scripts/my_script.sh >> /var/log/my_script.log 2>&1
```

### 3. 🧩 Combining scripts into a maintenance runner = operational maturity
Instead of scheduling 5 separate cron jobs and losing track of what ran when, a single `maintenance.sh` that calls others — and logs everything with timestamps — gives you a **single source of truth** for nightly operations. One log file. One cron entry. Full auditability.

---

## 📁 File Structure

```
2026/day-19/
├── log_rotate.sh        # Task 1: Log rotation with compress + delete
├── backup.sh            # Task 2: Timestamped backup with cleanup
├── maintenance.sh       # Task 4: Combined runner with timestamped logging
└── day-19-project.md   # This documentation file
```

---

## 🚀 How to Run

```bash
# Navigate to your day-19 directory
cd 2026/day-19/

# Make all scripts executable
chmod +x *.sh

# Test log rotation (use a test directory first!)
mkdir -p /tmp/test-logs
touch -d "10 days ago" /tmp/test-logs/old-app.log
touch -d "40 days ago" /tmp/test-logs/ancient-app.log.gz
./log_rotate.sh /tmp/test-logs

# Test backup
mkdir -p /tmp/test-source /tmp/test-backups
echo "hello" > /tmp/test-source/file.txt
./backup.sh /tmp/test-source /tmp/test-backups

# Run the combined maintenance script
sudo ./maintenance.sh

# View the maintenance log
tail -50 /var/log/maintenance.log
```

---

## 🛠️ Quick Reference

```bash
# Find files older than N days
find /path -name "*.log" -mtime +7

# Compress files in-place
gzip filename.log           # creates filename.log.gz

# Create timestamped tar archive
tar -czf backup-$(date +%Y-%m-%d).tar.gz /source/dir

# Append to log with timestamp
echo "$(date '+%Y-%m-%d %H:%M:%S'): message" >> /var/log/app.log

# Cron — view, edit, remove
crontab -l    # list
crontab -e    # edit
crontab -r    # remove all (careful!)

# Redirect both stdout and stderr in cron
0 2 * * * /path/script.sh >> /var/log/script.log 2>&1
```

---

> **Happy Learning! 🚀**
>
> **TrainWithShubham** — `#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
