#!/bin/bash

fetch_cpu_usage() {
    cpu_usage_metric=$(top -bn1)
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}' | cut -d'.' -f1)
    # echo "${cpu_idle}"
    cpu_usage=$((100 - cpu_idle))
    if [ "$cpu_usage" -le 80 ]; then
        send_alert "${cpu_usage_metric}%"
    fi
    echo "CPU Usage: ${cpu_usage}%"
}

fetch_mem_uage() {
    echo "======== MEM Stats =========== "
    read total used free <<< $(free -m | awk 'NR==2{print $2, $3, $4}')
    echo "total: ${total}MB, used: ${used}MB, free: ${free}MB"
}

fetch_storage_usage() {
    echo "======== Storage Stats =========== "
    read total used free percent <<< $(df -h / | awk 'NR==2{print $2, $3, $4, $5}')
    echo "total: ${total}, used: ${used}, free: ${free}, percent: ${percent}"
}

send_alert() {
    echo "from alert"
    echo "High Usage Detected: $1"
}

fetch_cpu_usage
fetch_mem_uage
fetch_storage_usage