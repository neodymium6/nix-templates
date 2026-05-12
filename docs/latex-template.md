# LaTeX Template

`latex` template generates a LuaLaTeX project with Nix-managed tooling and
`just` commands.

## Included Tooling

- `texliveFull` for a complete TeX Live environment
- `latexmk` for PDF builds
- `biber` + BibLaTeX for bibliography support
- `chktex` for LaTeX checks
- `latexindent` for formatting
- `texlab` for editor/LSP support
- `pre-commit` hooks for checks
- `just` task runner
- `gh` for optional GitHub repository creation

## Template Options

- `language`: `english` or `japanese`
- `bibliography`: include BibLaTeX/Biber setup and `references.bib`

Japanese documents use LuaLaTeX with `ltjsarticle` and `luatexja`.

## Generated Commands

After generating a project, use:

```bash
direnv allow
just init
just build
just watch
just check
```

`just build` and `just watch` unset `SOURCE_DATE_EPOCH` for the LaTeX build so
PDF metadata uses the actual build time instead of Nix's reproducible timestamp.

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
