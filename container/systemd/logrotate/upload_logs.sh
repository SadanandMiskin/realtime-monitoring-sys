#!/bin/bash

DESTINATION="http://192.168.1.42:5000/logrotate"

latest_metric=$(ls -t /tmp/metric_log.log.*.gz 2>/dev/null | head -n1)
[ -n "$latest_metric" ] && curl -X POST -F "file=@$latest_metric" "$DESTINATION"

latest_alert=$(ls -t /tmp/server_alert_report.log.*.gz 2>/dev/null | head -n1)
[ -n "$latest_alert" ] && curl -X POST -F "file=@$latest_alert" "$DESTINATION"