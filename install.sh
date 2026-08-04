#!/usr/bin/env bash
# Nocturne dotfiles — symlink the right packages for this OS with GNU Stow.
#   Arch/Linux : stow shared + linux
#   macOS      : stow shared + macos
# First-time on a machine that already has real config files? Use --adopt to
# pull them into the repo, then `git diff` to review:  ./install.sh --adopt
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
extra=("$@")
case "$(uname -s)" in
  Linux)  pkgs=(shared linux) ;;
  Darwin) pkgs=(shared macos) ;;
  *) echo "unsupported OS: $(uname -s)"; exit 1 ;;
esac
command -v stow >/dev/null || { echo "install GNU Stow first (paru -S stow / brew install stow)"; exit 1; }
echo "stow ${extra[*]:-} -t $HOME  ${pkgs[*]}"
stow -v -R -t "$HOME" "${extra[@]}" "${pkgs[@]}"
echo "done."
