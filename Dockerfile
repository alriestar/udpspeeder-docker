## Dockerfile for UDPspeeder
# Build image containing speederv2_arm binary
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VER=20230206.0
ARG URL=https://github.com/wangyu-/UDPspeeder/releases/download/${VER}/speederv2_binaries.tar.gz
ARG TARGETARCH


RUN cd /usr/bin \
    && apk add --no-cache wget ca-certificates \
    && wget -qO- ${URL} | tar xzv \
    && SUFFIX=$(case "$TARGETARCH" in \
    amd64) echo "amd64" ;; \
    arm) echo "arm" ;; \
    386) echo "x86" ;; \
    *) echo "unknown" ;; esac) \
    && mv speederv2_$SUFFIX udp-speeder \
    && udp-speeder -h \
    && rm -f speederv2_* \
    && apk del wget ca-certificates

USER nonroot

ENTRYPOINT ["/usr/bin/udp-speeder"]
CMD ["-h"]
