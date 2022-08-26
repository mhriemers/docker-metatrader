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

ARG WINEPREFIX="/root/.wine"
ARG WINEDLLOVERRIDES="mscoree,mshtml=,winebrowser.exe="
ARG WINEARCH="win32"
ARG WINE="/usr/bin/wine"

ARG MT4_URL=https://download.mql5.com/cdn/web/tf.global.markets/mt4/thinkmarkets4setup.exe
ENV MT4_DIR_NAME="ThinkMarkets MetaTrader 4"
RUN wget -O /tmp/mt4setup.exe ${MT4_URL} &&  \
    (xvfb-run -a ${WINE} /tmp/mt4setup.exe /auto || true) && \
    [ -d "${WINEPREFIX}/drive_c/Program Files/${MT4_DIR_NAME}/" ] && \
    rm /tmp/mt4setup.exe

COPY entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint", "-4", "-i", "${WINEPREFIX}/drive_c/Program Files/${MT4_DIR_NAME}/"]
CMD ["verify"]