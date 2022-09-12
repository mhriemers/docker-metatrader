FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xvfb && \
    rm -rf /var/lib/apt/lists/*

ARG WINE_BRANCH=staging
RUN wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    . /etc/os-release && \
    wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$VERSION_CODENAME/winehq-$VERSION_CODENAME.sources && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-$WINE_BRANCH && \
    rm -rf /var/lib/apt/lists/*

ARG WINEARCH
ARG MT_URL
ARG MT_DIR_NAME
ARG MT_EDITOR_EXE_NAME
ARG MT_TERMINAL_EXE_NAME

ENV WINEPREFIX /root/.wine
ENV WINEDLLOVERRIDES mscoree,mshtml=,winebrowser.exe=
ENV WINEDEBUG warn-all,fixme-all,err-alsa,-ole,-toolbar
ENV WINEARCH $WINEARCH
ENV MT_INSTALLATION $WINEPREFIX/drive_c/Program Files/$MT_DIR_NAME/
ENV MT_EDITOR_EXE_PATH $MT_INSTALLATION$MT_EDITOR_EXE_NAME
ENV MT_TERMINAL_EXE_PATH $MT_INSTALLATION$MT_TERMINAL_EXE_NAME

ADD $MT_URL /tmp/mtsetup.exe
RUN (xvfb-run -a wine /tmp/mtsetup.exe /auto || true) && \
    test -d "$MT_INSTALLATION" && \
    test -f "$MT_EDITOR_EXE_PATH" && \
    test -f "$MT_TERMINAL_EXE_PATH" && \
    rm /tmp/mtsetup.exe

CMD ["/bin/bash"]