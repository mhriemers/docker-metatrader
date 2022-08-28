FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xvfb && \
    rm -rf /var/lib/apt/lists/*

ARG WINE_BRANCH="staging"
RUN wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    . /etc/os-release && \
    wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/${VERSION_CODENAME}/winehq-${VERSION_CODENAME}.sources && \
    dpkg --add-architecture i386 &&  \
    apt-get update &&  \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-${WINE_BRANCH} &&  \
    rm -rf /var/lib/apt/lists/*

ENV WINEPREFIX="/root/.wine"
ENV WINEDLLOVERRIDES="mscoree,mshtml=,winebrowser.exe="
ENV WINEARCH="win32"
ARG MT4_URL=https://download.mql5.com/cdn/web/tf.global.markets/mt4/thinkmarkets4setup.exe
ARG MT4_DIR_NAME="ThinkMarkets MetaTrader 4"
RUN wget -O /tmp/mt4setup.exe ${MT4_URL} &&  \
    (xvfb-run -a wine /tmp/mt4setup.exe /auto || true) && \
    [ -d "${WINEPREFIX}/drive_c/Program Files/${MT4_DIR_NAME}/" ] && \
    rm /tmp/mt4setup.exe

ENV MT_VERSION=4
ENV MT_INSTALLATION="${WINEPREFIX}/drive_c/Program Files/${MT4_DIR_NAME}/"

COPY metaeditor.sh /usr/bin/metaeditor
RUN chmod +x /usr/bin/metaeditor

COPY terminal.sh /usr/bin/terminal
RUN chmod +x /usr/bin/terminal

CMD ["/bin/bash"]