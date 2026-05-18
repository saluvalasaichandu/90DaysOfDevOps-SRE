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