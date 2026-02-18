#!/usr/bin/env bash
set -euo pipefail

if command -v ansible-playbook >/dev/null 2>&1; then
  echo "Ansible already installed"
  exit 0
fi

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found, installing Homebrew first"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  brew install ansible
  exit 0
fi

if [[ "$OS" == "Linux" ]]; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y ansible
    exit 0
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y ansible
    exit 0
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm ansible
    exit 0
  fi
fi

echo "Unsupported platform/package manager for automatic Ansible install"
echo "Please install Ansible manually: https://docs.ansible.com/ansible/latest/installation_guide/index.html"
exit 1
