FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xvfb && \
    rm -rf /var/lib/apt/lists/*

ARG WINE_BRANCH="stable"
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
RUN wget -O /tmp/mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe &&  \
    (xvfb-run -a wine /tmp/mt5setup.exe /auto || true) && \
    [ -d "${WINEPREFIX}/drive_c/Program Files/MetaTrader 5/" ] && \
    rm -rf /tmp/*

ENV MT_VERSION=5
ENV MT_INSTALLATION="${WINEPREFIX}/drive_c/Program Files/MetaTrader 5/"

COPY metaeditor.sh /usr/bin/metaeditor
RUN chmod +x /usr/bin/metaeditor

COPY terminal.sh /usr/bin/terminal
RUN chmod +x /usr/bin/terminal

CMD ["/bin/bash"]