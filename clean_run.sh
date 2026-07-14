#!/bin/bash

# Terminate script execution if any command fails
set -e

echo "=== 1. System update and installation of basic utilities ==="
sudo apt update
# gh: GitHub CLI
# tesseract-ocr-ukr: for KDE Spectacle app, adding Ukrainian language for "Extract text" function
# python-is-python3: to simplify running Python code at the system level
sudo apt install -y rclone curl wget gpg uidmap stow tmux gh tesseract-ocr-ukr python-is-python3


echo "=== 2. Installing and configuring FNM (Fast Node Manager) ==="
curl -fsSL https://fnm.vercel.app/install | bash

# Activate FNM in the current script session
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env`"

fnm install --lts
fnm use lts-latest

echo "=== 3. Installing MegaSync ==="
# Dynamically determine the OS version
UBUNTU_VER=$(lsb_release -rs)
MEGA_OS="xUbuntu_${UBUNTU_VER}"
MEGA_DEB="/tmp/megasync-${MEGA_OS}_amd64.deb"

echo "Detected OS for Mega: $MEGA_OS"

wget -O "$MEGA_DEB" "https://mega.nz/linux/repo/${MEGA_OS}/amd64/megasync-${MEGA_OS}_amd64.deb"
sudo apt install -y "$MEGA_DEB"
rm "$MEGA_DEB"

echo "=== 4. Setting up Google Cloud CLI repository ==="
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/cloud.google.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

echo "=== 5. Installing system packages (Podman + Google CLI) ==="
# Single apt update for new repositories
sudo apt update
# Full list of packages: everything is installed in one command
sudo apt install -y podman podman-docker uidmap google-cloud-cli

# Migration for Podman
podman system migrate

echo "=== 6. Installing VS Code (Microsoft repository) ==="
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

echo "=== 7. Install npm applications ==="
# Check if npm is available (installed via FNM in step 2)
if ! command -v npm &> /dev/null; then
  echo "Error: npm not found. FNM may not be configured."
  exit 1
fi
echo "=== 7.1 Install npm applications (tokscale) ==="
npm i -g tokscale

echo "=== 8. Installing OpenCode AI ==="
curl -fsSL https://opencode.ai/install | bash

echo "=== 9. Install some temporary software ==="
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok

echo "=== 10. Installing Hermes Agent (at the very end to avoid conflicts) ==="
# --non-interactive: skips steps requiring input (API keys, etc.)
# --skip-setup: skips the interactive setup wizard
# Hermes will detect Node.js from FNM and won't install its own
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup --non-interactive

echo ""
echo "=== Installation completed successfully! ==="
echo "Please restart the terminal or run: source ~/.bashrc"
echo ""
echo "=== After restarting the terminal, run: hermes setup ==="
