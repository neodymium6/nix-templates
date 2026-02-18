# shellcheck shell=bash
set -euo pipefail

template=""
dest=""
templates_root="@SELF@/copier"

die() {
  echo "Error: $*" >&2
  exit 2
}

require_option_value() {
  local option="$1"
  local value="${2-}"

  if [ -z "$value" ] || [ "${value#-}" != "$value" ]; then
    die "Missing value for $option"
  fi
}

list_templates() {
  local path
  local name

  if [ ! -d "$templates_root" ]; then
    return
  fi

  shopt -s nullglob
  for path in "$templates_root"/*; do
    [ -d "$path" ] || continue
    name="${path##*/}"
    printf '  - %s\n' "$name"
  done | sort
  shopt -u nullglob
}

show_help() {
  cat <<'USAGE'
Usage:
  nix run .#new -- --template <name> --dest <dir> [-- <copier args>]

Examples:
  nix run .#new -- --template python --dest myproj
  nix run .#new -- --template python --dest myproj -- -d author="Taro"

Notes:
  - After `--`, arguments are passed to `copier copy`.
  - Templates live under ./copier/<name>

Available templates:
USAGE

  list_templates
}

while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    show_help
    exit 0
    ;;
  --template)
    require_option_value "$1" "${2-}"
    template="$2"
    shift 2
    ;;
  --dest)
    require_option_value "$1" "${2-}"
    dest="$2"
    shift 2
    ;;
  --)
    shift
    break
    ;;
  -*)
    die "Unknown option: $1"
    ;;
  *)
    die "Unexpected argument before '--': $1"
    ;;
  esac
done

if [ -z "$template" ] || [ -z "$dest" ]; then
  show_help >&2
  die "Both --template and --dest are required"
fi

if [ "${template#../}" != "$template" ] || [ "${template#*/}" != "$template" ] || [ "$template" = ".." ]; then
  die "Template name must be a single directory name: $template"
fi

if [ ! -d "$templates_root/$template" ]; then
  show_help >&2
  die "Unknown template: $template"
fi

if [ -e "$dest" ]; then
  die "Destination already exists: $dest"
fi

copier_args=()
has_noninteractive_flag=false
for arg in "$@"; do
  case "$arg" in
  --defaults | -l | --force | -f)
    has_noninteractive_flag=true
    break
    ;;
  esac
done

if { ! [ -t 0 ] || ! [ -t 1 ]; } && [ "$has_noninteractive_flag" = false ]; then
  copier_args+=(--defaults)
fi

copier copy "$templates_root/$template" "$dest" "${copier_args[@]}" "$@"

# Copier may preserve read-only mode bits from templates under /nix/store.
# Ensure generated project files are editable by the current user.
chmod -R u+rwX "$dest"

echo "Created: $dest"
echo "Next: cd \"$dest\""
echo "Then: direnv allow (if you use direnv) or nix develop"
