# Wikilayer on Docker

This repository contains the Dockerfile and Compose configuration for the
self-hosted Wikilayer server. The application is distributed as a Linux binary
built from the private Wikilayer source repository; its web interface and other
static assets are inside that binary. The image and its build recipe are public.

## Start

Install Docker with the Compose plugin. Clone this repository and create a
local environment file with a random database password:

```sh
git clone https://github.com/wikilayer/docker.git
cd docker
printf 'POSTGRES_PASSWORD=%s\n' "$(openssl rand -hex 24)" > .env
```

Start Wikilayer and PostgreSQL 16:

```sh
docker compose up -d
```

Open <http://localhost:38731>. A local AI client connects to
`http://localhost:38731/mcp`. The service is bound to the computer's loopback
interface and runs in single-user mode; do not publish this port to a network
without adding your own access control. The upload and database volumes survive
container replacement.

The Homebrew installation uses the same port. Stop one installation before
starting the other:

```sh
brew services stop wikilayer/tap/wikilayer
docker compose up -d
```

To return to Homebrew:

```sh
docker compose stop
brew services start wikilayer/tap/wikilayer
```

## Update

Set `WIKILAYER_VERSION` in `.env` to a published tag such as `v1.1.0`, or leave
it unset to use `latest`. Then pull and restart the application:

```sh
docker compose pull
docker compose up -d
```

Back up both named volumes before an upgrade. PostgreSQL data needs a proper
database backup before changing PostgreSQL major versions. `docker compose down`
keeps the volumes; `docker compose down -v` deletes them.

## Releases

The private source repository publishes Linux amd64 and arm64 release
archives with SHA-256 checksums to this repository's [Releases](https://github.com/wikilayer/docker/releases).
Publishing a release here starts the image build. The workflow verifies both
archives, builds both architectures from the public Dockerfile, and pushes
`ghcr.io/wikilayer/wikilayer:<tag>` and `:latest`. Development pushes do not
start image builds.
