{
  description = "dwm flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;

      overlayList = [ self.overlays.default ];

      pkgsBySystem = forEachSystem (
        system:
        import nixpkgs {
          inherit system;
          overlays = overlayList;
        }
      );

    in
  {

      overlays.default = (final: prev: {
        dwmPatched = prev.dwm.overrideAttrs (oldAttrs: {
        version = "master";
        src = ./.;
    });
  });
      packages = forEachSystem (system: {
        dwmPatched = pkgsBySystem.${system}.dwmPatched;
        default = pkgsBySystem.${system}.dwmPatched;
      });

      nixosModules.overlays = overlayList;

    };
}
