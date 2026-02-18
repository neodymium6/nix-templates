# nix-templates

Project templates powered by Copier and Nix.

## Usage

### List templates

```bash
nix run github:neodymium6/nix-templates#new -- --help
```

### One-shot (recommended)

```bash
nix run github:neodymium6/nix-templates#new -- --template python --dest myproj
```

### Bootstrap via `nix flake init/new`

```bash
nix flake new myproj -t github:neodymium6/nix-templates#python
# or: nix flake init -t github:neodymium6/nix-templates#python

cd myproj
nix run .#init
```

### If using a fork

```bash
TEMPLATE_REPO=github:<you>/<repo> nix run .#init
```
