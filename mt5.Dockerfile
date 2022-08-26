FROM alpine:3.16

RUN echo "x86" > /etc/apk/arch

ARG WINE_VERSION=7.8
ARG WINE_VERSION_SUFFIX=r0
RUN apk add --no-cache \
        wine=${WINE_VERSION}-${WINE_VERSION_SUFFIX} \
        xvfb=21.1.4-r0 \
        xvfb-run=1.20.7.3-r0 \
        wget=1.21.3-r0

ARG WINEPREFIX="/root/.wine"
ARG WINEDLLOVERRIDES="mscoree,mshtml=,winebrowser.exe="
ARG WINEARCH="win32"
ARG WINE="/usr/bin/wine"

RUN rm -rf ${WINEPREFIX} &&  \
    wget -O /tmp/mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe &&  \
    (xvfb-run -a ${WINE} /tmp/mt5setup.exe /auto || true) && \
    [ -d "${WINEPREFIX}/drive_c/Program Files/MetaTrader 5/" ] && \
    rm /tmp/mt5setup.exe

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]