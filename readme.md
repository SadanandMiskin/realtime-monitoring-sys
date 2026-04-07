# Realtime Monitoring SYS
### A system in which a script checks CPU, mem, storage usage written in bash running as a `systemd` service in docker containers with real alert system to the Host via HTTP sent events on failure + handling logs with `logrotate`.


![realtime_monitoring_system_architecture (1)](https://github.com/user-attachments/assets/9634d080-8834-42b7-8d04-a7c66d3720cc)


- [ ] Bash Script for checking the metrics.
- [ ] Running the script as a `service` with `.service` and `.timer` running every 'x' time.
- [ ] Rotate logs with `logrotate` for every `y` amount of time.
- [ ] HTTP Alert request via curl to Host on `z%` usage and sending log file.
- [ ] Flask server handling HTTP POST Alert request at host.
- [ ] Script to run multiple `worker` nodes to check usage for testing.
- [ ] Containerizing the whole system.
