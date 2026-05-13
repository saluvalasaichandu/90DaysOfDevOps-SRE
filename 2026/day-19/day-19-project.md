# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

> **#90DaysOfDevOps | #DevOpsKaJosh | #TrainWithShubham**

---

## What We Are Building Today

| Script | What it does |
|--------|-------------|
| `log_rotate.sh` | Compresses old logs, deletes very old ones |
| `backup.sh` | Creates a backup archive of any folder |
| `maintenance.sh` | Runs both scripts together, saves a log |

---

## Task 1: Log Rotation Script

> **Goal:** Find old `.log` files → compress them → delete very old `.gz` files

### 📄 `log_rotate.sh`

```bash
#!/bin/bash
set -euo pipefail

LOG_DIR="$1"   # Pass the log folder as argument

# Stop if folder doesn't exist
if [[ ! -d "$LOG_DIR" ]]; then
    echo "ERROR: Folder '$LOG_DIR' not found."
    exit 1
fi

echo "Starting log rotation for: $LOG_DIR"

# Compress .log files older than 7 days
find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \;
echo "Old .log files compressed."

# Delete .gz files older than 30 days
find "$LOG_DIR" -name "*.gz" -mtime +30 -delete
echo "Very old .gz files deleted."

echo "Log rotation done!"
```

### ▶️ How to Run

```bash
chmod +x log_rotate.sh
./log_rotate.sh /var/log/myapp
```

### ▶️ Output

```
Starting log rotation for: /var/log/myapp
Old .log files compressed.
Very old .gz files deleted.
Log rotation done!
```

### ▶️ If Folder Doesn't Exist

```
ERROR: Folder '/var/log/myapp' not found.
```

### 💡 What Each Line Does

```bash
find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \;
#    ^ where      ^ file type  ^ older than 7 days  ^ compress each one

find "$LOG_DIR" -name "*.gz" -mtime +30 -delete
#    ^ where     ^ file type  ^ older than 30 days  ^ delete each one
```

---

## Task 2: Server Backup Script

> **Goal:** Zip a folder into a backup file with today's date → clean up old backups

### 📄 `backup.sh`

```bash
#!/bin/bash
set -euo pipefail

SOURCE="$1"    # Folder to back up
DEST="$2"      # Where to save the backup

# Stop if source folder doesn't exist
if [[ ! -d "$SOURCE" ]]; then
    echo "ERROR: Source folder '$SOURCE' not found."
    exit 1
fi

# Create destination folder if it doesn't exist
mkdir -p "$DEST"

# Create a backup filename with today's date
FILENAME="backup-$(date +%Y-%m-%d).tar.gz"

# Create the backup
tar -czf "$DEST/$FILENAME" "$SOURCE"
echo "Backup created: $FILENAME"
echo "Size: $(du -sh "$DEST/$FILENAME" | cut -f1)"

# Delete backups older than 14 days
find "$DEST" -name "backup-*.tar.gz" -mtime +14 -delete
echo "Old backups cleaned up."
```

### ▶️ How to Run

```bash
chmod +x backup.sh
./backup.sh /var/www/myapp /backups
```

### ▶️ Output

```
Backup created: backup-2026-05-13.tar.gz
Size: 145M
Old backups cleaned up.
```

### 💡 What Each Line Does

```bash
FILENAME="backup-$(date +%Y-%m-%d).tar.gz"
# date +%Y-%m-%d → gives today's date like: 2026-05-13

tar -czf "$DEST/$FILENAME" "$SOURCE"
# -c = create  -z = compress  -f = filename

du -sh "$DEST/$FILENAME"
# shows human-readable file size like: 145M
```

---

## Task 3: Crontab Scheduling

> **Goal:** Run scripts automatically at set times — no manual triggering

### Understanding Cron Syntax

```
  *    *    *    *    *     command
  │    │    │    │    │
  │    │    │    │    └───  Day of week (0=Sunday … 6=Saturday)
  │    │    │    └────────  Month       (1–12)
  │    │    └─────────────  Day         (1–31)
  │    └──────────────────  Hour        (0–23)
  └───────────────────────  Minute      (0–59)
```

### Cron Entries for Our Scripts

```cron
# Run log_rotate.sh every day at 2:00 AM
0 2 * * * /home/ubuntu/scripts/log_rotate.sh /var/log/myapp

# Run backup.sh every Sunday at 3:00 AM
0 3 * * 0 /home/ubuntu/scripts/backup.sh /var/www/myapp /backups

# Run a health check every 5 minutes
*/5 * * * * /home/ubuntu/scripts/health_check.sh

# Run maintenance.sh every day at 1:00 AM
0 1 * * * /home/ubuntu/scripts/maintenance.sh
```

### Cron Commands Cheat Sheet

```bash
crontab -l    # View current cron jobs
crontab -e    # Edit cron jobs (opens editor)
crontab -r    # Delete all cron jobs ⚠️
```

### Quick Reference Table

| Cron Expression | Meaning |
|----------------|---------|
| `0 2 * * *` | Every day at 2:00 AM |
| `0 3 * * 0` | Every Sunday at 3:00 AM |
| `*/5 * * * *` | Every 5 minutes |
| `0 1 * * *` | Every day at 1:00 AM |
| `0 0 1 * *` | First day of every month |

> ⚠️ **Always use full paths in cron.** Cron doesn't know where your scripts are unless you tell it the full path.

---

## Task 4: Combined Maintenance Script

> **Goal:** Run both scripts from one place and save all output to a log file

### 📄 `maintenance.sh`

```bash
#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/maintenance.log"

# Helper to print messages with timestamp
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
```

### ▶️ How to Run

```bash
chmod +x maintenance.sh
./maintenance.sh
```

### ▶️ What Gets Written to `/var/log/maintenance.log`

```
[2026-05-13 01:00:00] ===== Maintenance Started =====
[2026-05-13 01:00:00] Running log rotation...
[2026-05-13 01:00:02] Log rotation done.
[2026-05-13 01:00:02] Running backup...
[2026-05-13 01:00:08] Backup done.
[2026-05-13 01:00:08] ===== Maintenance Finished =====
```

### ⏰ Cron Entry

```cron
0 1 * * * /home/ubuntu/scripts/maintenance.sh
```

---

## 3 Key Learnings

**1. `find` is the backbone of automation**
Almost every disk-management task uses `find`. Learn `-mtime`, `-name`, `-exec`, and `-delete` — that covers 90% of real use cases.

**2. Always use full paths in cron jobs**
Cron runs with a minimal environment. `./my_script.sh` won't work. `/home/ubuntu/scripts/my_script.sh` will.

**3. Log everything with timestamps**
When something breaks at 2 AM, the log file is all you have. One `log()` function with `$(date)` gives you a full audit trail for free.

---

## 📁 File Structure

```
2026/day-19/
├── log_rotate.sh       # Task 1
├── backup.sh           # Task 2
├── maintenance.sh      # Task 4
└── day-19-project.md  # This file
```

---

## 🚀 Test Without Breaking Anything

```bash
# Create a safe test environment
mkdir -p /tmp/test-logs /tmp/test-source /tmp/test-backups

# Create a fake old log file
touch -d "10 days ago" /tmp/test-logs/app.log

# Test log rotation
./log_rotate.sh /tmp/test-logs

# Test backup
echo "hello" > /tmp/test-source/data.txt
./backup.sh /tmp/test-source /tmp/test-backups
```

---

> **Happy Learning! 🚀**
> **TrainWithShubham** — `#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
