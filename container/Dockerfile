FROM ubuntu:latest

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install systemd and curl
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    curl \
    nano \
    logrotate \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    # apt update
# Ensure the container knows it's running in Docker
ENV container docker

# Copy your scripts
WORKDIR /root
COPY ./metric_checkup.sh ./
COPY ./systemd/metric_monitor.service /etc/systemd/system
COPY ./systemd/metric_monitor.timer /etc/systemd/system
COPY ./logrotate/metric_log.conf /etc/logrotate.d
COPY ./systemd/logrotate/logrotate-custom.service /etc/systemd/system/
COPY ./systemd/logrotate/logrotate-custom.timer /etc/systemd/system/
COPY ./systemd/logrotate/upload_logs.sh /usr/local/bin/

# COPY ./a.sh ./
RUN sed -i 's/\r$//' /root/metric_checkup.sh && \
    chmod +x /root/metric_checkup.sh && \
    chmod 644 /etc/logrotate.d/metric_log.conf && \
    chmod +x /usr/local/bin/upload_logs.sh
RUN sed -i 's/\r$//' /etc/logrotate.d/metric_log.conf
RUN systemctl enable metric_monitor.timer
RUN systemctl enable logrotate-custom.timer

# systemd requires a different entrypoint than a standard shell
STOPSIGNAL SIGRTMIN+3
CMD [ "/lib/systemd/systemd" ]