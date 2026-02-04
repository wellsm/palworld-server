FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMAPPDIR=/palworld

RUN apt-get update && apt-get install -y \
    wget ca-certificates \
    lib32gcc-s1 lib32stdc++6 \
    libstdc++6 libgcc-s1 \
    libicu-dev \
    supervisor \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m steam

RUN mkdir -p /steamcmd /palworld /var/log/supervisor && \
    chown -R steam:steam /steamcmd /palworld

# SteamCMD
RUN cd /steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz

COPY entrypoint.sh /entrypoint.sh
COPY supervisor/palworld.conf /etc/supervisor/conf.d/palworld.conf
COPY scripts /scripts

RUN chmod +x /entrypoint.sh /scripts/*.sh && \
    chown -R steam:steam /scripts

WORKDIR /palworld

ENTRYPOINT ["/entrypoint.sh"]
