# Flake Template

`flake` template generates a lightweight Nix flake project with practical defaults.

## Included Files

- `flake.nix` with `formatter` and a `devShell`
- `.envrc` for `direnv` + flakes
- `.gitignore` for common Nix/direnv artifacts
- `.pre-commit-config.yaml` for baseline checks
- `.github/workflows/ci.yml` for CI checks on push/PR when `remote` is enabled
- `justfile` with helper commands
- `LICENSE`
- `README.md`

## Template Options

- `remote`: include remote repository helper and CI workflow (default: `true`)

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

When `remote` is enabled, the generated `justfile` includes:

```bash
just repo-create
```

- Default repo name: project name
- Default visibility: selected during Copier prompt (`private/public`)
- You can override both:

```bash
just repo-create your-repo-name public
```

If `gh` is not authenticated, run:

```bash
gh auth login
```
