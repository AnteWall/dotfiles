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

   Go defaults are configurable:
   - `go_version` in `ansible/group_vars/all.yml` (for example `1.24.0`)
   - `fnm_node_version` in `ansible/group_vars/all.yml` (for example `25.6.1`)
   - `go.privateModules` in `chezmoi/.chezmoidata.yaml` (defaults to `github.com/tickup-se/*`)
   - `ssh.keyFiles` in `chezmoi/.chezmoidata.yaml` (for example `id_ed25519`, `id_rsa`)
   - `rustup_default_toolchain` in `ansible/group_vars/all.yml` (for example `stable`)
   - `rustup_profile` in `ansible/group_vars/all.yml` (`minimal`, `default`, or `complete`)

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
- Go is installed from official `go.dev/dl` tarballs to `~/.local/go/go<version>` with `~/.local/go/current` symlinked to the selected `go_version`.
- Shell config exports `GOPRIVATE` using `go.privateModules` from chezmoi data.
- Rust is installed with `rustup` from `https://sh.rustup.rs` using configurable `rustup_default_toolchain` and `rustup_profile`.
- Shell config includes `~/.cargo/bin` so `cargo`, `rustc`, and `rustup` are available in new shells.
- `fnm` is installed via Homebrew and sets `fnm_node_version` as the default Node.js version.
- Bootstrap ensures `~/.ssh` exists with secure permissions (`0700`).
- zsh config starts `ssh-agent` automatically when needed and loads keys listed in `ssh.keyFiles`.
- Shell config initializes `fnm env --use-on-cd --shell zsh` so the selected Node.js version is active in new zsh sessions.
- Shell prompt uses `oh-my-posh` with upstream default `eval "$(oh-my-posh init zsh)"`.
- chezmoi externals include `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins.

Oh My Posh notes (from upstream docs):

- Add `eval "$(oh-my-posh init zsh)"` to the end of `~/.zshrc`.
- Nerd Font install is automated by Ansible (`oh_my_posh_install_font: true`, `oh_my_posh_font: meslo`).
- Configure your terminal emulator to use the installed Nerd Font (for Meslo: `MesloLGM Nerd Font`).
- If colors look wrong, ensure `$TERM` supports colors (for example `xterm-256color`).

WSL2 users: see `docs/wsl.md` for Windows Terminal font and shell setup.

## WSL2

If you want to use `copilot.lua`/Copilot in Neovim on WSL2, install these packages manually first:

```bash
sudo apt update
sudo apt install -y wslu firefox
```

This provides `wslview` (from `wslu`) and a browser (`firefox`) for GitHub device/code login flow.

To refresh external plugins managed by chezmoi:

```bash
chezmoi -R apply --source ./chezmoi
```
