#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ ! -d "$ROOT_DIR/ansible" || ! -d "$ROOT_DIR/chezmoi" ]]; then
  echo "Expected ansible/ and chezmoi/ directories in repo root"
  exit 1
fi

"$ROOT_DIR/scripts/install-ansible.sh"

ansible-galaxy collection install -r "$ROOT_DIR/ansible/collections/requirements.yml"

ANSIBLE_BECOME_ARGS=()
if [[ "$(uname -s)" == "Linux" ]] && command -v sudo >/dev/null 2>&1; then
  ANSIBLE_BECOME_ARGS=(--ask-become-pass)
  echo "Linux detected; Ansible will prompt for sudo password"
fi

ANSIBLE_CONFIG="$ROOT_DIR/ansible/ansible.cfg" ANSIBLE_ROLES_PATH="$ROOT_DIR/ansible/roles" ansible-playbook "${ANSIBLE_BECOME_ARGS[@]}" -i "$ROOT_DIR/ansible/inventories/local/hosts.yml" "$ROOT_DIR/ansible/playbooks/bootstrap.yml"

CHEZMOI_BIN=""

if command -v chezmoi >/dev/null 2>&1; then
  CHEZMOI_BIN="chezmoi"
elif [[ -x "$HOME/.local/bin/chezmoi" ]]; then
  CHEZMOI_BIN="$HOME/.local/bin/chezmoi"
else
  echo "chezmoi was not found after Ansible bootstrap"
  echo "Check Ansible output and install logs"
  exit 1
fi

"$CHEZMOI_BIN" apply --source "$ROOT_DIR/chezmoi"

echo "Bootstrap complete"
