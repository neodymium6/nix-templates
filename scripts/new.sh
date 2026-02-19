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

is_known_template() {
  local wanted="$1"
  local path
  local name

  if [ ! -d "$templates_root" ]; then
    return 1
  fi

  shopt -s nullglob
  for path in "$templates_root"/*; do
    [ -d "$path" ] || continue
    name="${path##*/}"
    if [ "$name" = "$wanted" ]; then
      shopt -u nullglob
      return 0
    fi
  done
  shopt -u nullglob
  return 1
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

if ! is_known_template "$template"; then
  show_help >&2
  die "Unknown template: $template"
fi

if [ -e "$dest" ]; then
  die "Destination already exists: $dest"
fi

copier_args=()
has_noninteractive_flag=false
has_author_data=false
has_data_file=false
expect_data_value=false
expect_data_file_value=false
autofill_author=false
for arg in "$@"; do
  if [ "$expect_data_file_value" = true ]; then
    has_data_file=true
    expect_data_file_value=false
    continue
  fi

  if [ "$expect_data_value" = true ]; then
    case "$arg" in
    author=*)
      has_author_data=true
      ;;
    esac
    expect_data_value=false
    continue
  fi

  case "$arg" in
  --defaults | -l | --force | -f)
    has_noninteractive_flag=true
    ;;
  -d | --data)
    expect_data_value=true
    ;;
  --data-file)
    expect_data_file_value=true
    ;;
  --data=author=*)
    has_author_data=true
    ;;
  --data-file=*)
    has_data_file=true
    ;;
  esac
done

if [ "$has_noninteractive_flag" = true ]; then
  autofill_author=true
fi

if { ! [ -t 0 ] || ! [ -t 1 ]; } && [ "$has_noninteractive_flag" = false ]; then
  copier_args+=(--defaults)
  autofill_author=true
fi

if [ "$autofill_author" = true ] && [ "$has_author_data" = false ] && [ "$has_data_file" = false ] && { [ "$template" = "python" ] || [ "$template" = "flake" ]; }; then
  author_default="${GIT_AUTHOR_NAME:-${GIT_COMMITTER_NAME:-${USER:-}}}"
  if [ -n "$author_default" ]; then
    copier_args+=(--data "author=$author_default")
  fi
fi

copier copy "$templates_root/$template" "$dest" "${copier_args[@]}" "$@"

# Copier may preserve read-only mode bits from templates under /nix/store.
# Ensure generated project files are editable by the current user.
chmod -R u+rwX "$dest"

echo "Created: $dest"
echo "Next: cd \"$dest\""
echo "Then: direnv allow (if you use direnv) or nix develop"
