{
  inputs,
  ...
}:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
  mkNixosSystem =
    {
      meta,
      nixosModules,
      extraSpecialArgs ? { },
      f ? nixpkgs.lib.nixosSystem,
      ...
    }:
    let
      pkgs-unstable = import nixpkgs-unstable {
        system = meta.system;
        config = {
          allowUnfree = true;
        };
      };
    in
    f {
      system = meta.system;
      specialArgs = {
        inherit
          inputs
          pkgs-unstable
          nixpkgs-unstable
          meta
          ;
      }
      // extraSpecialArgs;
      modules = nixosModules;
    };
in
{
  systems = [ ];
  flake =
    { ... }:
    {
      nixosConfigurations = {
        rpi = mkNixosSystem (import ../configurations/rpi4.nix { inherit inputs; });
        vps = mkNixosSystem (import ../configurations/server.nix { inherit inputs; });
        wsl = mkNixosSystem (import ../configurations/wsl.nix { inherit inputs; });
      };
    };
}
