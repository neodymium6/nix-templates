{
  description = "Copier-based project generators (nix run .#new)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        newScript = builtins.replaceStrings
          [ "@SELF@" ]
          [ "${self}" ]
          (builtins.readFile ./scripts/new.sh);

        new = pkgs.writeShellApplication {
          name = "new";
          runtimeInputs = with pkgs; [ copier coreutils ];
          text = newScript;
        };
      in
      {
        apps = {
          new = { type = "app"; program = "${new}/bin/new"; };
          default = { type = "app"; program = "${new}/bin/new"; };
        };
      });
}
