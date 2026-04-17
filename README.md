# 💻 Dotfiles: Zsh + Bash + Neovim + Tmux

A portable development environment for **macOS** and **Enterprise Linux (RHEL/Rocky)**. Shared shell config, Catppuccin Mocha theme everywhere, and rootless install scripts for locked-down infra machines.

## 🚀 Installation

### Full install (macOS / Linux with sudo)

```bash
git clone https://github.com/Razer6/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Infra / corp machines (no sudo)

```bash
git clone https://github.com/Razer6/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --no-deps --skip vscode,macos,ghostty

# Install tools without root
./scripts/install-neovim.sh
./scripts/install-starship.sh
```

### Flags

| Flag | Description |
| :--- | :--- |
| `--no-deps` | Skip all package installation (Homebrew, apt, dnf). Only links configs. |
| `--skip a,b,c` | Comma-separated list of configs to skip. Skips both the config setup step and the symlink for each name. |

Available names for `--skip`: any top-level folder in this repo (e.g. `vscode`, `macos`, `nvim`, `tmux`, `zsh`, `bash`, `git`, `ghostty`, `starship`).

### Rootless install scripts

For machines without root access, use the scripts in `scripts/`:

| Script | Description |
| :--- | :--- |
| `scripts/install-neovim.sh` | Downloads prebuilt Neovim binary to `~/.local/bin` (Linux x86_64/arm64, macOS) |
| `scripts/install-starship.sh` | Downloads Starship prompt to `~/.local/bin` |

All rootless installs go to `~/.local/bin`, which is added to `PATH` automatically via `.shell_common`.

## 📁 Structure

```
dotfiles/
├── bash/           # .bashrc, .bash_profile (infra machines)
├── zsh/            # .zshrc, .zsh_plugins.txt (local machines)
├── shell/          # .shell_common (shared config sourced by both)
├── nvim/           # Neovim config (Lazy.nvim, LSP, Treesitter)
├── tmux/           # Tmux config (Ctrl-a prefix, vim keys)
├── ghostty/        # Ghostty terminal config
├── starship/       # Starship prompt config (Catppuccin Mocha)
├── git/            # .gitconfig (shared), uses ~/.gitconfig.local for identity
├── vscode/         # VS Code settings
├── macos/          # macOS system defaults
├── scripts/        # Rootless install scripts (not symlinked)
├── packages.sh     # Package manifest (Brew/DNF/APT)
└── install.sh      # Main installer
```

### Local overrides

Machine-specific config goes in `.local` files (not tracked by git):

| File | Purpose |
| :--- | :--- |
| `~/.zshrc.local` | Zsh overrides (auto-created from existing `.zshrc` on install) |
| `~/.bashrc.local` | Bash overrides (auto-created from existing `.bashrc` on install) |
| `~/.gitconfig.local` | Git identity and machine-specific settings (included via `[include]`) |

## 🛠 Features

* **Shell:** `Zsh` + `Antidote` (local) or `Bash` (infra), with shared config.
* **Prompt:** `Starship` with Catppuccin Mocha theme (works over SSH).
* **Editor:** `Neovim` (Lazy.nvim) with LSP, Treesitter, and Telescope.
* **Multiplexer:** `Tmux` with `Ctrl-a` prefix and Vim-style navigation.
* **Package Management:** Cross-platform support via `packages.sh` (Brew/DNF/APT).

## ⌨️ Essential Shortcuts

### Neovim (Leader = `Space`)
| Shortcut | Action |
| :--- | :--- |
| `<Leader>ff` | Find files |
| `<Leader>fg` | Search text (grep) |
| `<Leader>e` | File explorer |
| `K` | View documentation (LSP) |
| `gd` | Go to definition |

### Tmux (Prefix = `Ctrl-a`)
| Shortcut | Action |
| :--- | :--- |
| `Prefix |` | Split vertical |
| `Prefix -` | Split horizontal |
| `Prefix h/j/k/l` | Switch panes |
| `Prefix H/J/K/L` | Resize panes |
| `Prefix c` | New window (keeps path) |
| `Prefix d` | Detach session |
| `v` (copy mode) | Begin selection |
| `y` (copy mode) | Yank to system clipboard |

## ⚙️ Customization

To add languages or tools, edit the config files in `nvim/.config/nvim/`:
* **`lsp-languages.txt`**: List LSPs, formatters, and linters (Mason slugs).
* **`treesitter.txt`**: List languages for high-fidelity syntax highlighting.

---
