#!/bin/bash

set -euo pipefail

system_info() {

    echo "===== Hostname & OS ====="

    hostname

    cat /etc/os-release
}

uptime_info() {

    echo "===== Uptime ====="

    uptime
}

disk_usage() {

    echo "===== Disk Usage ====="

    du -ah / | sort -rh | head -5
}

memory_usage() {

    echo "===== Memory Usage ====="

    free -h
}

cpu_process() {

    echo "===== Top CPU Processes ====="

    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
}


system_info

uptime_info

disk_usage

memory_usage

cpu_process
