FROM alpine:3.16

RUN apk add --no-cache \
        bash \
        su-exec \
        tini

RUN apk add --no-cache build-base ocaml \
    && wget https://github.com/bcpierce00/unison/archive/v2.52.0.tar.gz -q -O - | tar zxv -C /tmp \
    && cd /tmp/unison-2.52.0 \
    && make UISTYLE=text \
    && cp src/unison src/unison-fsmonitor /usr/local/bin \
    && apk del build-base ocaml \
    && rm -rf /tmp/unison-2.52.0

COPY entrypoint.sh /bin/entrypoint.sh
COPY unison-default-profile.tpl /etc/unison-default-profile.tpl

RUN chmod +x /bin/entrypoint.sh

ENV OWNER_UID 1000
ENV OWNER_GID 1000
ENV DATA_DIR /sync

EXPOSE 5000

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["unison", "-log", "-socket", "5000"]
HEALTHCHECK --interval=5s --timeout=1s --retries=1 CMD /bin/sh -c 'netstat -an | grep LISTEN | grep 5000'
