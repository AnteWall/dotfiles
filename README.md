# Dotfiles Bootstrap (Ansible + chezmoi)

Starter repo for managing:

- machine setup and packages with Ansible
- shell/editor/tool config with chezmoi
- both macOS and Linux from one workflow

## Repo layout

```text
.
├── ansible/
│   ├── ansible.cfg
│   ├── collections/requirements.yml
│   ├── group_vars/all.yml
│   ├── inventories/local/hosts.yml
│   ├── playbooks/bootstrap.yml
│   └── roles/
│       ├── common/tasks/main.yml
│       ├── linux/tasks/main.yml
│       └── macos/tasks/main.yml
├── chezmoi/
│   ├── .chezmoidata.yaml
│   ├── dot_gitconfig.tmpl
│   └── dot_zshrc.tmpl
├── scripts/
│   ├── bootstrap.sh
│   └── install-ansible.sh
└── Makefile
```

## Quick start

1. Clone this repo.
2. Run bootstrap:

   ```bash
   ./scripts/bootstrap.sh
   ```

3. Customize values:
   - `ansible/group_vars/all.yml`
   - `chezmoi/.chezmoidata.yaml`

4. Re-run anytime:

   ```bash
   make setup
   make diff
   make status
   make apply
   ```

This starter uses `./chezmoi` as the source directory, so run chezmoi commands with `--source ./chezmoi`.

On Linux, package tasks use sudo and will prompt for your password:

```bash
make ansible
```

## Notes

- `scripts/bootstrap.sh` installs or verifies Ansible, runs Ansible playbook (including chezmoi install), then applies chezmoi source from `./chezmoi`.
- macOS bootstrap installs Homebrew if missing, then uses Homebrew for package installs.
- Linux bootstrap installs Homebrew if missing, then can install both distro packages and optional Homebrew packages.
- Default Homebrew tap includes `anomalyco/tap` with `anomalyco/tap/opencode` in the starter package list.
- Shell prompt uses `oh-my-posh` with upstream default `eval "$(oh-my-posh init zsh)"`.
- chezmoi externals include `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins.

Oh My Posh notes (from upstream docs):

- Add `eval "$(oh-my-posh init zsh)"` to the end of `~/.zshrc`.
- Nerd Font install is automated by Ansible (`oh_my_posh_install_font: true`, `oh_my_posh_font: meslo`).
- Configure your terminal emulator to use the installed Nerd Font (for Meslo: `MesloLGM Nerd Font`).
- If colors look wrong, ensure `$TERM` supports colors (for example `xterm-256color`).

WSL2 users: see `docs/wsl.md` for Windows Terminal font and shell setup.

To refresh external plugins managed by chezmoi:

```bash
chezmoi -R apply --source ./chezmoi
```
