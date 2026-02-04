FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMAPPDIR=/palworld
ENV STEAMUSER=steam
ENV STEAMCMDDIR=/steamcmd

RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    lib32gcc-s1 \
    lib32stdc++6 \
    libstdc++6 \
    libgcc-s1 \
    libicu-dev \
    supervisor \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m ${STEAMUSER}

RUN mkdir -p ${STEAMCMDDIR} ${STEAMAPPDIR} /var/log/supervisor && \
    chown -R ${STEAMUSER}:${STEAMUSER} ${STEAMCMDDIR} ${STEAMAPPDIR}

# SteamCMD
RUN cd ${STEAMCMDDIR} && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz && \
    chown -R ${STEAMUSER}:${STEAMUSER} ${STEAMCMDDIR}

COPY entrypoint.sh /entrypoint.sh
COPY supervisor/palworld.conf /etc/supervisor/conf.d/palworld.conf
COPY scripts /scripts

RUN chmod +x /entrypoint.sh /scripts/*.sh && \
    chown -R ${STEAMUSER}:${STEAMUSER} /scripts

WORKDIR ${STEAMCMDDIR}

EXPOSE 8211/udp
EXPOSE 27015/udp

ENTRYPOINT ["/entrypoint.sh"]
