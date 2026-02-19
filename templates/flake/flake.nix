{
  description = "Bootstrap flake (materialize via Copier)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        init = pkgs.writeShellApplication {
          name = "init";
          runtimeInputs = with pkgs; [ nix rsync coreutils findutils ];
          text = ''
            set -euo pipefail

            repo="''${TEMPLATE_REPO:-github:neodymium6/nix-templates}"
            tmp_root="$(mktemp -d .copier-tmp.XXXXXX)"
            tmp="$tmp_root/rendered"
            trap 'rm -rf "$tmp_root"' EXIT

            nix run "$repo#new" -- --template flake --dest "$tmp" -- "$@"

            conflicts=()
            while IFS= read -r rel; do
              rel="''${rel#./}"
              [ "$rel" = "flake.nix" ] && continue
              if [ -e "$rel" ]; then
                conflicts+=("$rel")
              fi
            done < <(cd "$tmp" && find . -mindepth 1 -print | sort)

            if [ "''${#conflicts[@]}" -gt 0 ]; then
              echo "Refusing to overwrite existing files:" >&2
              printf '  - %s\n' "''${conflicts[@]}" >&2
              echo "Only flake.nix may be replaced during bootstrap." >&2
              exit 1
            fi

            rsync -a --exclude '.git' "$tmp"/ ./

            echo "Bootstrap completed."
            echo "Next: direnv allow (if you use direnv) or nix develop"
          '';
        };
      in
      {
        apps = {
          init = { type = "app"; program = "${init}/bin/init"; meta.description = "Bootstrap the flake template into the current directory."; };
          default = { type = "app"; program = "${init}/bin/init"; meta.description = "Bootstrap the flake template into the current directory."; };
        };
      });
}
