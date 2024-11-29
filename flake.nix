{
  description = "dwm nix flake";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            (final: prev: {
              dwmPtch = prev.dwm.overrideAttrs (oldAttrs: {
                version = "master";
                src = ./.;
              });
            })
          ];
        };
      in
      {

        packages.x86_64-linux.dwmPtch = pkgs.dwmPtch;
        packages.x86_64-linux.default = pkgs.dwmPtch;

        devShell.x86_64-linux = pkgs.mkShell {
          buildInputs = with pkgs; [ xorg.libX11 xorg.libXft xorg.libXinerama gcc bear ];
        };
      };
}
