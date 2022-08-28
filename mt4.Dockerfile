FROM alpine:3.16

RUN echo "x86" > /etc/apk/arch

ARG WINE_VERSION=7.8
ARG WINE_VERSION_SUFFIX=r0
RUN apk add --no-cache \
        wine=${WINE_VERSION}-${WINE_VERSION_SUFFIX} \
        xvfb=21.1.4-r0 \
        xvfb-run=1.20.7.3-r0 \
        wget=1.21.3-r0 \
        bash=5.1.16-r2

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