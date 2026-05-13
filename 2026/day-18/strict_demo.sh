#!/bin/bash
set -euo pipefail
echo "Strict mode enabled"
echo $UNDEFINED_VAR
echo "This line will not execute"

# [ec2-user@ip-172-31-41-72 functions]$ chmod +x strict_demo.sh
# [ec2-user@ip-172-31-41-72 functions]$ sh strict_demo.sh
# Strict mode enabled
# strict_demo.sh: line 4: UNDEFINED_VAR: unbound variable
