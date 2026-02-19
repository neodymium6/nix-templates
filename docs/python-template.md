# Python Template

`python` template generates a Python project with Nix + Copier.

## Included Tooling

- `uv` for dependency management and virtualenv
- `pytest` for tests
- `mypy` for type checking
- `ruff` for lint/format
- `pre-commit` hooks for checks
- `just` task runner
- `gh` for optional GitHub repository creation

## Generated Commands

After generating a project, use:

```bash
just init
just test
just check
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
