# nix-templates

Project templates powered by Copier and Nix.

## Template Docs

See `docs/` for template-specific guides.

## Usage

### List templates

```bash
nix run github:neodymium6/nix-templates#new -- --help
```

### One-shot (recommended)

```bash
repo=github:neodymium6/nix-templates
nix run "$repo#new" -- --template <template> --dest <dest>
```

### Bootstrap via `nix flake init/new`

```bash
repo=github:neodymium6/nix-templates
nix flake new <dest> -t "$repo#<template>"
# or: nix flake init -t "$repo#<template>"

cd <dest>
nix run .#init
```

### If using a fork

```bash
TEMPLATE_REPO=github:<you>/<repo> nix run .#init
```
