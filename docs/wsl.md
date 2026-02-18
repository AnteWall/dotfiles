# WSL2 + Windows Terminal setup

This repo bootstraps Linux (inside WSL2). Your prompt/font rendering is still controlled by your Windows terminal app.

## 1) Run bootstrap inside WSL2

```bash
./scripts/bootstrap.sh
chezmoi apply --source ./chezmoi
exec zsh
```

## 2) Set Nerd Font in Windows Terminal

Oh My Posh icons require a Nerd Font on the host terminal.

- Open Windows Terminal settings.
- Open your WSL profile (for example Ubuntu).
- Set font face to: `MesloLGM Nerd Font`.
- Save and open a new tab.

JSON example (`settings.json`):

```json
{
  "profiles": {
    "defaults": {
      "font": {
        "face": "MesloLGM Nerd Font"
      }
    }
  }
}
```

## 3) If colors still look wrong

- Ensure terminal supports 256 colors.
- In WSL, verify: `echo $TERM`
- If needed, set `TERM=xterm-256color` in your terminal/profile.

## 4) PowerShell vs WSL shell

- `~/.zshrc` only affects zsh in WSL.
- Native Windows PowerShell uses `$PROFILE` instead.
- If you also want Oh My Posh in PowerShell, add this to your PowerShell profile:

```powershell
oh-my-posh init pwsh | Invoke-Expression
```
