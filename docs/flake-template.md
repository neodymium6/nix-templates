# Flake Template

`flake` template generates a lightweight Nix flake project with practical defaults.

## Included Files

- `flake.nix` with `formatter` and a `devShell`
- `.envrc` for `direnv` + flakes
- `.gitignore` for common Nix/direnv artifacts
- `.pre-commit-config.yaml` for baseline checks
- `.github/workflows/ci.yml` for CI checks on push/PR
- `justfile` with helper commands
- `LICENSE`
- `README.md`

## Included Commands

After generating a project, use:

```bash
just init
just fmt
just check
just ci
just update
```

## GitHub Repository Helper

The generated `justfile` includes:

```bash
just repo-create
```

- Default repo name: project name
- Default visibility: selected during Copier prompt (`private/public/internal`)
- You can override both:

```bash
just repo-create your-repo-name public
```

If `gh` is not authenticated, run:

```bash
gh auth login
```
