# Show available recipes.
default:
  @just --list

# Install git hooks.
init:
  pre-commit install --install-hooks

# Format Nix files.
fmt:
  find . -type d \( -name .git -o -name .direnv \) -prune -o -type f -name "*.nix" -exec nixfmt {} +

# Evaluate flake checks.
check:
  pre-commit run --all-files
  nix flake check

# CI alias (same checks as `check`).
ci: check

# Update flake inputs.
update:
  nix flake update

# Remove local Nix and direnv artifacts.
clean:
  rm -rf .direnv .pre-commit-cache result result-*
