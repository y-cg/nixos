{
  inputs,
  ...
}:
let
  lib = import ../lib;
  inherit (inputs) nixpkgs nixpkgs-unstable;
  mkNixosSystem =
    {
      meta,
      nixosModules,
      homeManagerModules,
      extraSpecialArgs ? { },
      f ? nixpkgs.lib.nixosSystem,
      ...
    }:
    let
      specialArgs = {
        inherit inputs nixpkgs-unstable meta;
      } // extraSpecialArgs;
      homeManagerInjection = lib.injectHomeManager {
        inherit (meta) whoami;
        inherit homeManagerModules;
        extraSpecialArgs = specialArgs;
      };
    in
    f {
      inherit (meta) system;
      inherit specialArgs;
      modules = nixosModules ++ [
        inputs.home-manager.nixosModules.default
        homeManagerInjection
      ];
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
