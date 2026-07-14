# Clean Ubuntu (Kubuntu) Setup

Automated post-install script for a fresh **Kubuntu** system. Installs and configures all software needed for my daily development workflow in a single run — no manual steps required.

## What gets installed

| Step | Software | Notes |
|------|----------|-------|
| 1 | `rclone`, `curl`, `wget`, `gpg`, `uidmap`, `stow`, `tmux`, `gh`, `tesseract-ocr-ukr`, `python-is-python3` | Base CLI utilities |
| 2 | **FNM** + Node.js LTS | Fast Node Manager, LTS version |
| 3 | **MegaSync** | Cloud sync client from MEGA.nz |
| 4–5 | **Podman**, **Google Cloud CLI** | Container runtime + GCloud SDK |
| 6 | **VS Code** | Microsoft's official apt repo |
| 7 | `tokscale` (npm global) | Installed via FNM-provided npm |
| 8 | **OpenCode AI** | `opencode.ai` CLI tool |
| 9 | **ngrok** | Tunnel agent |
| 10 | **Hermes Agent** | AI agent, skips interactive setup wizard |

## Usage

```bash
chmod +x clean_run.sh
./clean_run.sh
```

After the script finishes, restart your terminal (or `source ~/.bashrc`) and run:

```bash
hermes setup
```

## Prerequisites

- Fresh Kubuntu installation
- Active internet connection
- User with `sudo` privileges
