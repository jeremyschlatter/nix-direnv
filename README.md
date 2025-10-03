# nix-direnv installer

One-command setup for nix + direnv + nix-direnv:

```bash
curl -fsSL https://raw.githubusercontent.com/jeremyschlatter/nix-direnv/main/install.sh | sh
```

This installs:
- [Nix](https://determinate.systems/posts/determinate-nix-installer) (via Determinate Systems installer)
- [direnv](https://direnv.net/)
- [nix-direnv](https://github.com/nix-community/nix-direnv)

The script is idempotent — safe to run multiple times.
