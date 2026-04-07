#!/bin/bash

# --- Configuration ---
THRESHOLD=80
ALERT_LOG="/tmp/server_alert_report.log"
SELF_LOG="/tmp/metric_log.log"
ENDPOINT="http://10.233.9.84:5000/alert"
OUTPUT=""

# Ensure the log file is empty at the start
> "$ALERT_LOG"

fetch_cpu_usage() {
    # We grab the first 20 lines of top to see the heavy hitters
    local cpu_snapshot=$(top -bn1)
    local cpu_idle=$(echo "$cpu_snapshot" | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}' | cut -d'.' -f1)
    local cpu_usage=$((100 - cpu_idle))
    OUTPUT="${OUTPUT} Date: $(date) , CPU: ${cpu_usage}% "  
    
    if [ "$cpu_usage" -le $THRESHOLD ]; then
        now=$(date)
        echo -e "\n Reported On the Date: ${now} " >> "$ALERT_LOG"
        echo -e "\n[!] ALERT: HIGH CPU USAGE (${cpu_usage}%)\n" >> "$ALERT_LOG"
        echo "$cpu_snapshot" >> "$ALERT_LOG"
        echo "-------------------------------------------" >> "$ALERT_LOG"
    fi
}

fetch_mem_usage() {
    local mem_total=$(free -m | awk 'NR==2{print $2}')
    local mem_used=$(free -m | awk 'NR==2{print $3}')
    local used_per=$((mem_used * 100 / mem_total))
    OUTPUT="${OUTPUT}  , Memory Used: ${used_per}% "   
    
    if [ "$used_per" -le $THRESHOLD ]; then
        echo -e "\n[!] ALERT: HIGH MEMORY USAGE (${used_per}%)\n" >> "$ALERT_LOG"
        free -m >> "$ALERT_LOG"
        echo -e "\nTop Process Consumers:" >> "$ALERT_LOG"
        ps -eo pid,ppid,cmd,%mem --sort=-%mem >> "$ALERT_LOG"
        echo "-------------------------------------------" >> "$ALERT_LOG"
    fi
}

fetch_storage_usage() {
    # Check root partition usage
    local storage_snapshot=$(df -h /)
    local percent=$(echo "$storage_snapshot" | awk 'NR==2 {print $5}' | sed 's/%//')
    OUTPUT="${OUTPUT}  , Storage Used: ${percent}% "  
    
    if [ "$percent" -le $THRESHOLD ]; then
        echo -e "\n[!] ALERT: HIGH STORAGE USAGE (${percent}%)\n" >> "$ALERT_LOG"
        df -h >> "$ALERT_LOG"
        echo "-------------------------------------------" >> "$ALERT_LOG"
    fi
}

# --- Execution ---

fetch_cpu_usage
fetch_mem_usage
fetch_storage_usage

echo $OUTPUT >> $SELF_LOG

# The "Trigger": Only curl if the log file has content (size > 0)
if [ -s "$ALERT_LOG" ]; then
    echo "Threshold exceeded. Sending full report to $ENDPOINT"
    curl -X POST -F "file=@$ALERT_LOG" "$ENDPOINT"
else
    # Optional: remove the empty log file if you want to keep /tmp clean
    rm -f "$ALERT_LOG"
fi