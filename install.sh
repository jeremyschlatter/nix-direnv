#!/bin/sh
set -eu

direnv_installed=true

# Install nix if needed
if ! command -v nix >/dev/null 2>&1; then
  echo "Installing nix..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "nix already installed"
fi

# Install direnv if needed
if ! command -v direnv >/dev/null 2>&1; then
  echo "Installing direnv..."
  nix profile install nixpkgs#direnv
  direnv_installed=false
else
  echo "direnv already installed"
fi

# Install nix-direnv if needed
if ! grep -q nix-direnv "$HOME/.config/direnv/direnvrc" 2>/dev/null; then
  echo "Installing nix-direnv..."
  nix profile install nixpkgs#nix-direnv
  mkdir -p "$HOME/.config/direnv"
  echo 'source $HOME/.nix-profile/share/nix-direnv/direnvrc' > "$HOME/.config/direnv/direnvrc"
else
  echo "nix-direnv already installed"
fi

# Print shell hook message if direnv was just installed
if [ "$direnv_installed" = false ]; then
  echo
  echo "=========================================="
  echo "direnv installed successfully!"
  echo
  echo "Add the following to your shell config:"
  echo

  case "${SHELL##*/}" in
    bash)
      echo '  ~/.bashrc:'
      echo '  eval "$(direnv hook bash)"'
      ;;
    zsh)
      echo '  ~/.zshrc:'
      echo '  eval "$(direnv hook zsh)"'
      ;;
    fish)
      echo '  ~/.config/fish/config.fish:'
      echo '  direnv hook fish | source'
      ;;
    tcsh|csh)
      echo '  ~/.cshrc:'
      echo '  eval `direnv hook tcsh`'
      ;;
    *)
      echo "  See: https://direnv.net/docs/hook.html"
      ;;
  esac

  echo "=========================================="
else
  echo "Done!"
fi
