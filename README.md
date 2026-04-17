# 💻 Dotfiles: Zsh + Neovim + Tmux

A portable, high-performance development environment managed with **GNU Stow**. Designed for seamless transitions between **macOS** and **Enterprise Linux (RHEL/Rocky)**.

## 🚀 Installation

```bash
# 1. Clone to your home directory
git clone [https://github.com/YOUR_USERNAME/dotfiles.git](https://github.com/YOUR_USERNAME/dotfiles.git) ~/.dotfiles
cd ~/.dotfiles

# 2. Run the automated installer
chmod +x install.sh
./install.sh
```

### Flags

| Flag | Description |
| :--- | :--- |
| `--no-deps` | Skip all package installation (Homebrew, apt, dnf). Only links configs and runs stow. |
| `--skip a,b,c` | Comma-separated list of configs to skip. Skips both the config setup step and the stow symlink for each name. |

Available names for `--skip`: any top-level folder in this repo (e.g. `vscode`, `macos`, `nvim`, `tmux`, `zsh`, `git`, `ghostty`).

**Examples:**

```bash
# Corp machine: skip deps and VS Code
./install.sh --no-deps --skip vscode

# Skip multiple configs
./install.sh --skip vscode,ghostty,macos
```

## 🛠 Features

* **Shell:** `Zsh` + `Antidote` for lightning-fast plugin management.
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
| `Prefix h/j/k/l` | Switch panes (Vim keys) |
| `Prefix d` | Detach session |

## ⚙️ Customization

To add languages or tools, edit the config files in `nvim/.config/nvim/`:
* **`lsp-languages.txt`**: List LSPs, formatters, and linters (Mason slugs).
* **`treesitter.txt`**: List languages for high-fidelity syntax highlighting.

---
