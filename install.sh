#!/bin/sh
set -eu

nix_installed=true
direnv_installed=true

# Install nix if needed
if ! command -v nix >/dev/null 2>&1; then
  echo "Installing nix..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  nix_installed=false
else
  echo "nix already installed"
fi

# Install direnv if needed
if ! command -v direnv >/dev/null 2>&1; then
  echo "Installing direnv..."
  nix profile add nixpkgs#direnv
  direnv_installed=false
else
  echo "direnv already installed"
fi

# Install nix-direnv if needed
if ! grep -q nix-direnv "$HOME/.config/direnv/direnvrc" 2>/dev/null; then
  echo "Installing nix-direnv..."
  nix profile add nixpkgs#nix-direnv
  mkdir -p "$HOME/.config/direnv"
  echo 'source $HOME/.nix-profile/share/nix-direnv/direnvrc' > "$HOME/.config/direnv/direnvrc"
else
  echo "nix-direnv already installed"
fi

# Print instructions
direnv_installed=false
nix_installed=false
if [ "$direnv_installed" = false ] || [ "$nix_installed" = false ]; then
  echo
  echo "=========================================="
  echo "Success!"
  echo

  if [ "$direnv_installed" = false ]; then
    echo "Now add the direnv hook to your shell config:"
    echo
    case "${SHELL##*/}" in
      bash)
        printf '  \033[1mecho '\''eval "$(direnv hook bash)"'\'' >> ~/.bashrc\033[0m\n'
        ;;
      zsh)
        printf '  \033[1mecho '\''eval "$(direnv hook zsh)"'\'' >> ~/.zshrc\033[0m\n'
        ;;
      fish)
        printf '  \033[1mecho '\''direnv hook fish | source'\'' >> ~/.config/fish/config.fish\033[0m\n'
        ;;
      tcsh|csh)
        printf '  \033[1mecho '\''eval `direnv hook tcsh`'\'' >> ~/.cshrc\033[0m\n'
        ;;
      *)
        echo '  See: https://direnv.net/docs/hook.html'
        ;;
    esac
  fi

  if [ "$nix_installed" = false ]; then
    if [ "$direnv_installed" = false ]; then
      echo
      echo "Then open a new shell or run:"
    else
      echo "Now open a new shell or run:"
    fi
    echo
    printf '  \033[1m. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh\033[0m\n'
  fi

  echo "=========================================="
else
  echo "Done!"
fi
