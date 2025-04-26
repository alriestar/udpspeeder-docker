## Dockerfile for UDPspeeder
# Build image containing speederv2 binary
FROM cgr.dev/chainguard/wolfi-base:latest

ARG VER=20230206.0
ARG URL=https://github.com/wangyu-/UDPspeeder/releases/download/${VER}/speederv2_binaries.tar.gz
ARG TARGETARCH

RUN set -eux; \
    apk add --no-cache wget ca-certificates; \
    cd /usr/bin; \
    wget -qO- "${URL}" | tar xz; \
    case "${TARGETARCH}" in \
      amd64) mv speederv2_amd64 udp-speeder ;; \
      arm64) mv speederv2_arm udp-speeder ;; \
      arm) mv speederv2_arm udp-speeder ;; \
      386) mv speederv2_x86 udp-speeder ;; \
    esac; \
    chmod +x udp-speeder; \
    rm -f speederv2_*; \
    apk del wget ca-certificates; \
    rm -rf /var/cache/apk/*

USER nonroot

ENTRYPOINT ["/usr/bin/udp-speeder"]
CMD ["-h"]
