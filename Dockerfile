FROM caddy:2.11.3-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM caddy:2.11.3-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

LABEL org.opencontainers.image.authors="akabyshev"
LABEL org.opencontainers.image.vendor="akabyshev"
LABEL org.opencontainers.image.description="Custom Caddy binary compiled with cloudflare DNS provider"
