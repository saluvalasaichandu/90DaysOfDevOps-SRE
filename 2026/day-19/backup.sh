#!/bin/bash
set -euo pipefail
SOURCE="$1"
DEST="$2"

if [[ ! -d $SOURCE ]]; then
        echo "ERROR: Source folder '$SOURCE' not found."
        exit 1
fi

echo "Starting backup---------"

mkdir -p $DEST
file_name="backup-$(date +%Y-%m-%d).tar.gz"
tar -czf "$DEST/$file_name" "$SOURCE"

echo "converted to tar file"

find "$DEST" -name "backup-*.tar.gz" -mtime +14 -delete

