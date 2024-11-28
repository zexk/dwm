{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              dwmPtch = prev.dwm.overrideAttrs (oldAttrs: rec {
                version = "master";
                src = ./.;
              });
            })
          ];
        };
      in
      rec {
        apps = {
          dwm = {
            type = "app";
            program = "${defaultPackage}/bin/st";
          };
        };

        packages.dwmPtch = pkgs.dwmPtch;
        defaultApp = apps.dwm;
        defaultPackage = pkgs.dwmPtch;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ xorg.libX11 xorg.libXft xorg.libXinerama gcc bear ];
        };
      }
    );
}
