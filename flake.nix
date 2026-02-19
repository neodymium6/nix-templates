{
  description = "Copier-based project generators (nix run .#new)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      perSystemOutputs = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          newScript = builtins.replaceStrings [ "@SELF@" ] [ "${self}" ] (builtins.readFile ./scripts/new.sh);

          new = pkgs.writeShellApplication {
            name = "new";
            runtimeInputs = with pkgs; [
              copier
              coreutils
            ];
            text = newScript;
          };
        in
        {
          formatter = pkgs.nixfmt;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              just
              nixfmt
              pre-commit
            ];
          };

          apps = {
            new = {
              type = "app";
              program = "${new}/bin/new";
            };
            default = {
              type = "app";
              program = "${new}/bin/new";
            };
          };
        }
      );

      templates = rec {
        python = {
          path = ./templates/python;
          description = "Python bootstrap template";
          welcomeText = ''
            Python bootstrap template

            Run:

            ```bash
            nix run .#init
            ```

            If using a fork:

            ```bash
            TEMPLATE_REPO=github:<you>/<repo> nix run .#init
            ```

            Alternative one-shot (skip bootstrap: `nix flake init/new` + `nix run .#init`):

            ```bash
            repo=github:neodymium6/nix-templates
            nix run $repo#new -- --template python --dest myproj
            ```
          '';
        };
        flake = {
          path = ./templates/flake;
          description = "Nix flake bootstrap template";
          welcomeText = ''
            Nix flake bootstrap template

            Run:

            ```bash
            nix run .#init
            ```

            If using a fork:

            ```bash
            TEMPLATE_REPO=github:<you>/<repo> nix run .#init
            ```

            Alternative one-shot (skip bootstrap: `nix flake init/new` + `nix run .#init`):

            ```bash
            repo=github:neodymium6/nix-templates
            nix run $repo#new -- --template flake --dest myflake
            ```
          '';
        };
        default = python;
      };
    in
    perSystemOutputs
    // {
      inherit templates;
    };
}
