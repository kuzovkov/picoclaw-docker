# PicoClaw Docker Environment

A Docker-based development environment for [PicoClaw](https://github.com/sipeed/picoclaw) — an AI-powered development agent platform by Sipeed. This project provides a pre-configured container with all necessary dependencies to run PicoClaw with full language support (Python, PHP, Node.js) and persistent workspace storage.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Installed Tools](#installed-tools)
- [Built-in Skills](#built-in-skills)
- [Port Configuration](#port-configuration)
- [Troubleshooting](#troubleshooting)

## Overview

This project containerizes the PicoClaw agent platform, providing:

- **Pre-built environment** with Ubuntu 22.04, Node.js 22, PHP 8.2, and Python 3.12
- **Persistent data storage** for sessions, workspace, and skills
- **Custom user support** matching host system UID/GID for seamless file permissions
- **Russian locale support** out of the box
- **Public gateway mode** for headless/server deployments

## Architecture

```
┌──────────────────────────────────────────────────┐
│                  Docker Container                  │
│                                                    │
│  ┌─────────────┐    ┌─────────────────────────┐   │
│  │  picoclaw    │───▶│   PicoClaw Gateway      │   │
│  │  launcher    │    │   (port 18800)          │   │
│  │  --public    │    └─────────────────────────┘   │
│  └─────────────┘                                  │
│                                                    │
│  Runtime:                                          │
│  • Node.js 22       • PHP 8.2 + Composer          │
│  • Python 3.12 (uv) • PicoClaw CLI Tools          │
│                                                    │
│  Volumes:                                          │
│  • ./shared → /shared                              │
│  • ./picoclaw_data → ~/.picoclaw                   │
└──────────────────────────────────────────────────┘
```

## Requirements

- **Docker** (20.10 or later)
- **Docker Compose** (v2.0 or later)
- At least **2GB RAM** available for the container
- Port **18800** available on the host

## Quick Start

### 1. Clone the repository

```bash
git clone <repository-url>
cd picoclaw
```

### 2. Build and start the container

```bash
docker compose up --build -d
```

### 3. Access the PicoClaw gateway

The gateway will be available at `http://localhost:18800`

### 4. View logs

```bash
docker compose logs -f
```

### 5. Stop the container

```bash
docker compose down
```

## Configuration

### Environment Variables

The project supports custom user configuration via environment variables or a `.env` file:

| Variable | Default | Description |
|----------|---------|-------------|
| `USER` | `ubuntu` | Username inside the container |
| `USER_ID` | `1000` | UID for the container user (match host user for permission consistency) |
| `GROUP_ID` | `1001` | GID for the container user |

#### Example `.env` file

```env
USER=myuser
USER_ID=$(id -u)
GROUP_ID=$(id -g)
```

### PicoClaw Gateway

The gateway is configured via the `PICOCLAW_GATEWAY_HOST` environment variable in `docker-compose.yml`:

```yaml
environment:
  PICOCLAW_GATEWAY_HOST: 0.0.0.0  # Listen on all interfaces
```

### Custom Entry Point

If you need to override the default command (`picoclaw-launcher --public`), uncomment the `entrypoint` line in `docker-compose.yml`:

```yaml
# entrypoint: ""
```

## Project Structure

```
picoclaw/
├── Dockerfile              # Container build configuration
├── docker-compose.yml      # Service definition and volume mounts
├── .dockerignore           # Files excluded from Docker build context
├── .gitignore              # Git ignore rules
├── shared/                 # Shared volume (mounted at /shared)
│                           # Use for files accessible inside the container
├── picoclaw_data/          # Persistent PicoClaw data (mounted at ~/.picoclaw)
│   ├── logs/              # Runtime logs
│   │   └── launcher.log   # Launcher log file
│   └── workspace/         # Workspace data
│       ├── cron/          # Scheduled tasks
│       ├── memory/        # Agent memory storage
│       ├── sessions/      # Session data
│       ├── skills/        # Installed agent skills
│       │   ├── agent-browser/
│       │   ├── github/
│       │   ├── hardware/
│       │   ├── picoclaw-agent/
│       │   ├── skill-creator/
│       │   ├── summarize/
│       │   ├── tmux/
│       │   └── weather/
│       └── state/         # Agent state persistence
```

## Installed Tools

### Runtime Languages

| Tool | Version | Extensions |
|------|---------|------------|
| **Node.js** | 22.x | — |
| **PHP** | 8.2 | cli, curl, pdo, pgsql, dom, imagick, mbstring, zip, gd, intl |
| **Python** | 3.12.2 | Managed via `uv` |

### Package Managers

- **Composer** — PHP dependency manager
- **uv** — Fast Python package and virtual environment manager

### System Tools

- `curl`, `wget` — HTTP clients
- `mc` (Midnight Commander) — File manager
- `build-essential` — Compilation tools
- `openssl`, `libssl-dev` — SSL/TLS libraries
- `libpq-dev` — PostgreSQL development libraries
- `unzip` — Archive extraction
- `sudo` — Privilege escalation

### PicoClaw

The latest PicoClaw binary is downloaded automatically from [GitHub Releases](https://github.com/sipeed/picoclaw/releases/latest) during the Docker build process.

## Built-in Skills

PicoClaw includes the following agent skills by default:

| Skill | Description |
|-------|-------------|
| **agent-browser** | Browser automation capabilities |
| **github** | GitHub integration and operations |
| **hardware** | Hardware control and monitoring (with references) |
| **picoclaw-agent** | Core agent functionality |
| **skill-creator** | Create new custom skills |
| **summarize** | Content summarization |
| **tmux** | Terminal multiplexer integration (with scripts) |
| **weather** | Weather information retrieval |

## Port Configuration

| Port | Protocol | Purpose |
|------|----------|---------|
| `18800` | HTTP | PicoClaw Gateway API |

The gateway is bound to `0.0.0.0` by default, making it accessible from outside the container.

## Troubleshooting

### Browser Warning in Logs

You may see the following warning in the logs:

```
Warning: Failed to auto-open browser: exec: "xdg-open": executable file not found in $PATH
```

This is expected in headless Docker environments. The gateway still runs correctly — this only means the container cannot automatically open a browser window.

### Permission Issues

If you experience file permission problems, ensure the `USER_ID` and `GROUP_ID` match your host user:

```bash
echo "USER_ID=$(id -u)" >> .env
echo "GROUP_ID=$(id -g)" >> .env
```

### Rebuild After Changes

If you modify the `Dockerfile`, rebuild the image:

```bash
docker compose build --no-cache
```

### Check Container Status

```bash
docker compose ps
```

### Access Container Shell

```bash
docker compose exec app bash
```

## License

This Docker configuration wraps the [PicoClaw](https://github.com/sipeed/picoclaw) project by Sipeed. Refer to the original project for licensing details.
