# nix-templates

Project templates powered by Copier and Nix.

## Template Docs

- [Python template](docs/python-template.md)
- [Flake template](docs/flake-template.md)

## Usage

### List templates

```bash
nix run github:neodymium6/nix-templates#new -- --help
```

### One-shot (recommended)

```bash
nix run github:neodymium6/nix-templates#new -- --template python --dest myproj
nix run github:neodymium6/nix-templates#new -- --template flake --dest myflake
```

### Bootstrap via `nix flake init/new`

```bash
nix flake new myproj -t github:neodymium6/nix-templates#python
# or: nix flake init -t github:neodymium6/nix-templates#python

nix flake new myflake -t github:neodymium6/nix-templates#flake
# or: nix flake init -t github:neodymium6/nix-templates#flake

cd myproj
nix run .#init
```

### If using a fork

```bash
TEMPLATE_REPO=github:<you>/<repo> nix run .#init
```
