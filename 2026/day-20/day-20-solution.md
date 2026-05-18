# Day 20 – Bash Scripting Challenge: Log Analyzer & Report Generator

> **#90DaysOfDevOps | #DevOpsKaJosh | #TrainWithShubham**

---

## What Are We Building?

A script that reads a log file and answers three questions:
- How many errors are there?
- Which errors happen the most?
- Are there any critical events?

Then it saves all the answers into a report file.

---

## Step 1 — Generate a Sample Log File

We need a log file to test with. Run this script to create one.

### 📄 `sample_logs_generator.sh`

```bash
#!/bin/bash

# This script creates a fake log file for testing
# Usage: ./sample_logs_generator.sh sample_log.log 200

LOG_FILE="$1"   # filename to create
NUM_LINES="$2"  # how many lines to generate

# List of log levels and error messages
LEVELS=("INFO" "DEBUG" "ERROR" "WARNING" "CRITICAL")
ERRORS=("Failed to connect" "Disk full" "Out of memory" "Invalid input" "Segmentation fault")

# Write random log lines to the file
for ((i=0; i<NUM_LINES; i++)); do
    LEVEL=${LEVELS[$((RANDOM % 5))]}
    MSG=""
    if [ "$LEVEL" == "ERROR" ]; then
        MSG=${ERRORS[$((RANDOM % 5))]}
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$LEVEL] $MSG" >> "$LOG_FILE"
done

echo "Done! Log file created: $LOG_FILE"
```

### ▶️ Run it

```bash
chmod +x sample_logs_generator.sh
./sample_logs_generator.sh sample_log.log 200
```

### ▶️ What the log looks like inside

```
2026-05-13 10:01:22 [INFO]
2026-05-13 10:01:22 [ERROR] Failed to connect
2026-05-13 10:01:22 [CRITICAL]
2026-05-13 10:01:22 [ERROR] Out of memory
2026-05-13 10:01:22 [WARNING]
```

---

## Step 2 — The Log Analyzer Script

### 📄 `log_analyzer.sh`

```bash
#!/bin/bash

# ── Step 1: Check the user gave us a file ──────────────────────────────────
if [ -z "$1" ]; then
    echo "ERROR: Please provide a log file."
    echo "Usage: ./log_analyzer.sh sample_log.log"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "ERROR: File '$LOG_FILE' not found."
    exit 1
fi

# ── Step 2: Count total errors ─────────────────────────────────────────────
echo "Analyzing: $LOG_FILE"
echo ""

ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE" || echo 0)
echo "Total Errors: $ERROR_COUNT"

# ── Step 3: Show critical events with line numbers ─────────────────────────
echo ""
echo "--- Critical Events ---"
grep -n "CRITICAL" "$LOG_FILE" || echo "No critical events found."

# ── Step 4: Top 5 most common error messages ───────────────────────────────
echo ""
echo "--- Top 5 Error Messages ---"
grep "ERROR" "$LOG_FILE" | sort | uniq -c | sort -rn | head -5

# ── Step 5: Save report to a file ──────────────────────────────────────────
REPORT="log_report_$(date +%Y-%m-%d).txt"
TOTAL_LINES=$(wc -l < "$LOG_FILE")

echo ""                                          >  "$REPORT"
echo "===== LOG ANALYSIS REPORT ====="           >> "$REPORT"
echo "Date       : $(date +%Y-%m-%d)"            >> "$REPORT"
echo "Log File   : $LOG_FILE"                    >> "$REPORT"
echo "Total Lines: $TOTAL_LINES"                 >> "$REPORT"
echo "Total Errors: $ERROR_COUNT"                >> "$REPORT"
echo ""                                          >> "$REPORT"
echo "--- Top 5 Error Messages ---"              >> "$REPORT"
grep "ERROR" "$LOG_FILE" | sort | uniq -c | sort -rn | head -5 >> "$REPORT"
echo ""                                          >> "$REPORT"
echo "--- Critical Events ---"                   >> "$REPORT"
grep -n "CRITICAL" "$LOG_FILE"                   >> "$REPORT"
echo ""                                          >> "$REPORT"
echo "Report created at: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT"

echo "Report saved: $REPORT"

# ── Step 6: Archive the log file ───────────────────────────────────────────
mkdir -p archive
mv "$LOG_FILE" archive/
echo "Log moved to: archive/$LOG_FILE"
```
<img width="1366" height="725" alt="image" src="https://github.com/user-attachments/assets/3d7ae3b9-b739-49e9-8f11-e5ca3eee51a1" />

---

## What Each Part Does

### Checking the file exists

```bash
if [ -z "$1" ]; then      # -z means "is this empty?"
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then   # -f means "is this a file?"
    exit 1
fi
```

### Counting errors

```bash
grep -c "ERROR" "$LOG_FILE"
# grep   = search the file
# -c     = count how many lines match (not the lines themselves)
```

### Finding critical events with line numbers

```bash
grep -n "CRITICAL" "$LOG_FILE"
# -n = show the line number next to each match
```

Output looks like:
```
34: 2026-05-13 10:01:25 [CRITICAL]
89: 2026-05-13 10:01:26 [CRITICAL]
```

### Top 5 most common errors

```bash
grep "ERROR" "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
```
<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/1c6e9585-6962-4e78-94b9-3fac367798dd" />

Read this left to right:
1. `grep "ERROR"` → get only error lines
2. `sort` → put identical lines next to each other
3. `uniq -c` → count how many times each line appears
4. `sort -rn` → put highest count first
5. `head -5` → keep only top 5

### Saving the report

```bash
echo "some text" > "$REPORT"    # > creates a new file (overwrites)
echo "more text" >> "$REPORT"   # >> adds to the file (appends)
```

---

## How to Run

```bash
# 1. Make scripts executable
chmod +x sample_logs_generator.sh log_analyzer.sh

# 2. Create a test log
./sample_logs_generator.sh sample_log.log 200

# 3. Run the analyzer
./log_analyzer.sh sample_log.log

# 4. View the report
cat log_report_2026-05-13.txt
```
<img width="1364" height="723" alt="image" src="https://github.com/user-attachments/assets/e9c881b7-b327-4446-ad84-0c70138e8c03" />

---

## Console Output

```
Analyzing: sample_log.log

Total Errors: 42

--- Critical Events ---
34: 2026-05-13 10:01:25 [CRITICAL]
89: 2026-05-13 10:01:26 [CRITICAL]
156: 2026-05-13 10:01:27 [CRITICAL]

--- Top 5 Error Messages ---
     11 2026-05-13 10:01:22 [ERROR] Failed to connect
      9 2026-05-13 10:01:23 [ERROR] Out of memory
      8 2026-05-13 10:01:24 [ERROR] Disk full
      7 2026-05-13 10:01:25 [ERROR] Invalid input
      7 2026-05-13 10:01:26 [ERROR] Segmentation fault

Report saved: log_report_2026-05-13.txt
Log moved to: archive/sample_log.log
```

---

## Report File Output (`log_report_2026-05-13.txt`)

```
===== LOG ANALYSIS REPORT =====
Date       : 2026-05-13
Log File   : sample_log.log
Total Lines: 200
Total Errors: 42

--- Top 5 Error Messages ---
     11 2026-05-13 10:01:22 [ERROR] Failed to connect
      9 2026-05-13 10:01:23 [ERROR] Out of memory
      8 2026-05-13 10:01:24 [ERROR] Disk full
      7 2026-05-13 10:01:25 [ERROR] Invalid input
      7 2026-05-13 10:01:26 [ERROR] Segmentation fault

--- Critical Events ---
34: 2026-05-13 10:01:25 [CRITICAL]
89: 2026-05-13 10:01:26 [CRITICAL]

Report created at: 2026-05-13 10:02:15
```

---

## Commands Used

| Command | What it does |
|---------|-------------|
| `grep "word" file` | Find lines containing "word" |
| `grep -c` | Count matching lines |
| `grep -n` | Show line number with each match |
| `sort` | Sort lines so duplicates are grouped |
| `uniq -c` | Count how many times each line appears |
| `sort -rn` | Sort numbers highest to lowest |
| `head -5` | Show only first 5 lines |
| `wc -l` | Count total lines in a file |
| `mkdir -p` | Create folder (no error if exists) |
| `mv` | Move a file to another location |

---

## 3 Key Learnings

**1. `grep` is your best friend for log analysis**
Every log task starts with `grep`. Count lines with `-c`, show line numbers with `-n`, search multiple words with `-E "ERROR\|Failed"`. Master grep and log analysis becomes easy.

**2. Pipes `|` chain simple commands into powerful ones**
`grep | sort | uniq -c | sort -rn | head -5` looks scary but each command does just one thing. Output of one becomes input of the next. Break it apart and read it one step at a time.

**3. `>` creates, `>>` appends**
When writing a report file, `>` starts fresh (wipes the file), `>>` adds to it. Mix them up and your report either gets wiped or never starts clean. Always use `>` for the first line, `>>` for everything after.

---

## 📁 File Structure

```
2026/day-20/
├── sample_logs_generator.sh     # Creates a test log file
├── log_analyzer.sh              # Main script
├── log_report_2026-05-13.txt    # Generated report
├── archive/
│   └── sample_log.log           # Log moved here after analysis
└── day-20-solution.md           # This file
```

---

> **Happy Learning! 🚀**
> **TrainWithShubham** — `#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
