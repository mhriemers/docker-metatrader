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
ARG MT_VERSION
ARG MT_URL
ARG MT_DIR_NAME
ARG MT_EDITOR_EXE_NAME
ARG MT_TERMINAL_EXE_NAME

ENV WINEPREFIX /root/.wine
ENV WINEDLLOVERRIDES mscoree,mshtml=,winebrowser.exe=
ENV WINEARCH $WINEARCH
ENV MT_VERSION $MT_VERSION
ENV MT_INSTALLATION $WINEPREFIX/drive_c/Program Files/$MT_DIR_NAME/
ENV MT_EDITOR_EXE_PATH $MT_INSTALLATION$MT_EDITOR_EXE_NAME
ENV MT_TERMINAL_EXE_PATH $MT_INSTALLATION$MT_TERMINAL_EXE_NAME

RUN wget -O /tmp/mtsetup.exe $MT_URL &&  \
    (xvfb-run -a wine /tmp/mtsetup.exe /auto || true) && \
    test -d "$MT_INSTALLATION" && \
    test -f "$MT_EDITOR_EXE_PATH" && \
    test -f "$MT_TERMINAL_EXE_PATH" && \
    rm /tmp/mtsetup.exe

ENV MT_EDITOR_PATH /usr/bin/metaeditor
COPY metaeditor.sh $MT_EDITOR_PATH
RUN chmod +x $MT_EDITOR_PATH

ENV MT_TERMINAL_PATH /usr/bin/terminal
COPY terminal.sh $MT_TERMINAL_PATH
RUN chmod +x $MT_TERMINAL_PATH

CMD ["/bin/bash"]