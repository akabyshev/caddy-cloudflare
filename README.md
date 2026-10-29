# caddy-cloudflare

Caddy built with the [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare) module, for ACME DNS-01 challenges through Cloudflare.

Image: [akabyshev/caddy-cloudflare](https://hub.docker.com/r/akabyshev/caddy-cloudflare)

## Usage

The API token is supplied at runtime and is not part of the image. It needs `Zone:Read` and `DNS:Edit` permissions.

```yaml
services:
  caddy:
    image: akabyshev/caddy-cloudflare:2.11.3-alpine
    environment:
      CF_API_TOKEN: ${CF_API_TOKEN}
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data

volumes:
  caddy_data:
```

```caddyfile
example.com {
	tls {
		dns cloudflare {env.CF_API_TOKEN}
	}
	reverse_proxy app:8080
}
```

## Build and push

```bat
publish.bat
```

This builds with `--pull --no-cache`, prompts for `docker login`, and pushes the image to Docker Hub.

## Updating the Caddy version

The version is set in three places, and they must all match:

| File | Value |
|---|---|
| `publish.bat` | `set TAG=<version>-alpine` |
| `Dockerfile` | `FROM caddy:<version>-builder AS builder` |
| `Dockerfile` | `FROM caddy:<version>-alpine` |

Before bumping, confirm that the upstream tags exist:

```powershell
docker manifest inspect caddy:<version>-builder
docker manifest inspect caddy:<version>-alpine
```
