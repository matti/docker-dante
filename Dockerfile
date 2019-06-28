FROM ubuntu:18.04

ENV DANTE_VER 1.4.2
ENV DANTE_URL https://www.inet.no/dante/files/dante-$DANTE_VER.tar.gz
ENV DANTE_SHA 4c97cff23e5c9b00ca1ec8a95ab22972813921d7fbf60fc453e3e06382fc38a7
ENV DANTE_FILE dante.tar.gz
ENV DANTE_TEMP dante
ENV DANTE_DEPS build-essential curl

RUN set -xe \
  && useradd app \
  && apt-get update \
  && apt-get install -y $DANTE_DEPS \
  && mkdir $DANTE_TEMP \
  && cd $DANTE_TEMP \
  && curl -sSL $DANTE_URL -o $DANTE_FILE \
  && echo "$DANTE_SHA *$DANTE_FILE" | shasum -c \
  && tar xzf $DANTE_FILE --strip 1 \
  && ./configure \
  && make install \
  && cd .. \
  && rm -rf $DANTE_TEMP \
  && apt-get purge -y --auto-remove $DANTE_DEPS \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app ./

ENV CFGFILE /app/sockd.conf
ENV PIDFILE /tmp/sockd.pid
ENV WORKERS 10

EXPOSE 1080

USER app
ENTRYPOINT ["/app/entrypoint.sh"]
