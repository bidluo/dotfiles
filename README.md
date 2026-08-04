# dotfiles

Cross-platform config, symlinked with [GNU Stow](https://www.gnu.org/software/stow/).
Linux side is the **Nocturne** Hyprland rice; macOS shares the editor/shell/CLI stack.

## Layout

```
shared/   cross-platform  → nvim, fish, starship, git, lazygit, fastfetch, fonts
linux/    Arch/Hyprland   → hypr, DankMaterialShell, matugen, kitty, gtk/qt, btop,
                            ~/.local/bin/{wall,nocturne-render}, systemd user units
macos/    macOS only      → tmux (tpm/catppuccin), Terminal theme, scripts
```

Each package mirrors `~`, so `stow shared` links `shared/.config/nvim` → `~/.config/nvim`, etc.

## Install

```sh
git clone git@github.com:bidluo/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./install.sh              # auto-picks shared+linux (Arch) or shared+macos (macOS)
```

`install.sh` runs `stow -R -t ~` for this OS's packages. If a real config file is
already in the way, adopt it into the repo and review with git:

```sh
./install.sh --adopt      # moves existing files into the repo, then `git diff`
```

## Prerequisites

**Arch:** `paru -S --needed stow dms-shell dms-shell-hyprland matugen neovim starship
bat eza fd ripgrep fzf zoxide lazygit git-delta btop fastfetch adw-gtk-theme
papirus-icon-theme bibata-cursor-theme-bin qt5ct qt6ct kvantum vesktop-bin spotify
spicetify-cli zapzap` (full list in the Notion reference).

**macOS:** `brew install stow neovim starship bat eza fd ripgrep fzf zoxide lazygit
git-delta fastfetch tmux fish` + tpm for tmux plugins.

## Notes

- **Colors are wallpaper-driven** on Linux: matugen regenerates palettes into files
  that are **gitignored** (they rebuild on every `wall`). The repo holds the *source*
  templates in `linux/.config/matugen/`.
- **Neovim** is shared and works on both OSes — on macOS the colorscheme falls back to
  the built-in Nocturne palette (no matugen there).
- **tmux is macOS-only** now (Linux uses Hyprland tiling).
- Pre-Hyprland i3 / picom / Xresources / vim-plug configs were removed — recover from
  git history if ever needed.
