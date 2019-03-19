FROM alpine:3.9

RUN apk add --no-cache \
        bash \
        su-exec \
        tini

# The sed replacement is an ugly hack to work without GLIB
RUN apk add --no-cache build-base ocaml \
    && wget https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz -q -O - | tar zxv -C /tmp \
    && cd /tmp/unison-2.51.2 \
    && sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c \
    && make UISTYLE=text NATIVE=true STATIC=true \
    && cp src/unison src/unison-fsmonitor /usr/local/bin \
    && apk del build-base ocaml \
    && rm -rf /tmp/unison-2.51.2

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
