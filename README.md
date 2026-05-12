# nix-templates

Project templates powered by Copier and Nix.

## Template Docs

See `docs/` for template-specific guides.

- [flake](docs/flake-template.md)
- [python](docs/python-template.md)
- [latex](docs/latex-template.md)

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

### Examples

```bash
nix run github:neodymium6/nix-templates#new -- --template python --dest my-python-project
nix run github:neodymium6/nix-templates#new -- --template flake --dest my-flake
nix run github:neodymium6/nix-templates#new -- --template latex --dest my-paper
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

## Development

```bash
# if you use direnv
direnv allow
just init
just ci

# without direnv
nix develop
just init
just ci
```
