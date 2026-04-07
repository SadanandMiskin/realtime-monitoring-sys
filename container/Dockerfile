FROM ubuntu:latest

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install systemd and curl
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    curl \
    nano \
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

# COPY ./a.sh ./
RUN chmod +x /root/*.sh

# systemd requires a different entrypoint than a standard shell
STOPSIGNAL SIGRTMIN+3
CMD [ "/lib/systemd/systemd" ]