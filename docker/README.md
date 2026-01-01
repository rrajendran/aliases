# Docker aliases (zsh)

A compact reference for the docker aliases and helper functions defined in `docker-aliases.sh`.

Quick install

- Source the file from your `~/.zshrc` (adjust the path if needed):

```sh
source ~/Developement/scripts/aliases/docker-aliases.sh
```

Safety note

- Several helpers perform destructive actions (remove containers/images/volumes). Double-check before running aliases like `drmall`, `drmi_all`, or `dprune`.

---

## Short commands 🔧
- `d` — docker
  - Example: `d ps`
- `dc` — `docker compose` (modern Compose)
  - Example: `dc up -d`
- `dco` — `docker-compose` (legacy binary)

## Listing 📋
- `dps` — `docker ps`
- `dpsa` — `docker ps -a`
- `dpsf` — formatted `docker ps` showing ID, name, status and ports
  - Example: `dpsf`
- `dimg` — `docker images`
- `dvol` — `docker volume ls`
- `dnet` — `docker network ls`

## Basic operations ⚙️
- `dstart CONTAINER` — start a container
- `dstop CONTAINER` — stop a container
- `drestart CONTAINER` — restart a container
- `drm CONTAINER` — remove a container
- `drmf CONTAINER` — force remove a container
- `drmi IMAGE` — remove an image
- `drmis IMAGE` — force remove an image
- `dkill CONTAINER` — kill a container
- `dcp SRC DEST` — `docker cp` to copy files to/from containers
- `dinspect TARGET` — `docker inspect` for containers/images
- `dlogs CONTAINER` — follow logs: `docker logs -f --tail 100 CONTAINER`
- `dstats` — `docker stats --no-stream`
- `devents` — recent events (`docker events --since 1m`)

## Compose helpers 📦
- `dcu` — `docker compose up -d`
- `dcd` — `docker compose down`
- `dcb` — `docker compose build --no-cache`
- `dcl` — `docker compose logs -f --tail 100`
- `dcr` — `docker compose run --rm`

## Pull / Push / Search 📥📤
- `dpull IMAGE` — `docker pull IMAGE`
- `dpush IMAGE` — `docker push IMAGE`
- `dsearch TERM` — `docker search TERM`

## Cleanup helpers (convenience, with safety checks) 🧹
- `dstopall()` — stop all running containers
  - Behavior: stops only if there are running containers
- `drmall()` — remove all containers (force)
  - WARNING: removes all containers returned by `docker ps -aq`
- `drmi_all()` — remove all images (force)
  - WARNING: removes all images returned by `docker images -q`
- `drmi_dangling()` — remove dangling images only (safe)

## Prune helpers ♻️
- `dprune()` — `docker system prune -af` (cleans images, containers, volumes, networks)
- `dprune_images()` — `docker image prune -af`
- `dprune_volumes()` — `docker volume prune -f`
- `dprune_networks()` — `docker network prune -f`

> ⚠️ Use `prune` and `*_all` commands with caution — they remove resources irreversibly.

## Exec / shell helpers 🐚
- `dexec CONTAINER CMD...` — `docker exec -it CONTAINER CMD...`
  - Example: `dexec web /bin/bash`
- `dshell [CONTAINER]` — open a shell in a container
  - If `CONTAINER` provided, tries `/bin/sh` then `/bin/bash`.
  - If no argument, it picks the first running container and opens a shell, or prints `No running containers`.
  - Example: `dshell my-container`
- `dattach CONTAINER` — `docker attach CONTAINER`

## Logs and commit / save / load 📝
- `dl CONTAINER` — `docker logs -f --tail 100 CONTAINER`
- `dcommit CONTAINER REPO[:TAG]` — `docker commit`
- `dsave out.tar image:tag` — save images to tar (`docker save -o out.tar image:tag`)
- `dload in.tar` — `docker load -i in.tar`

## Shell completion
- The script runs `compinit` when `ZSH_VERSION` is set. Ensure your interactive shell has completion enabled if you want autocompletion for these aliases.

---

## Contributing / Edits
If you want additional aliases or clearer examples, open a PR or edit the file in `aliases/docker-aliases.sh` and update this README accordingly.

---

_Last updated: 2026-01-01_
